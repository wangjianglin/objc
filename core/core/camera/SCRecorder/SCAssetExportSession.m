//
//  SCAssetExportSession.m
//  SCRecorder
//
//  Created by Simon CORSIN on 14/05/14.
//  Copyright (c) 2014 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAssetExportSession.h"
#import "SCRecorderTools.h"

#define EnsureSuccess(error, x) if (error != nil) { _error = error; if (x != nil) x(); return; }
#define kAudioFormatType kAudioFormatLinearPCM

@interface SCAssetExportSession() {
    AVAssetWriter *_writer;
    AVAssetReader *_reader;
    AVAssetReaderOutput *_audioOutput;
    AVAssetReaderOutput *_videoOutput;
    AVAssetWriterInput *_audioInput;
    AVAssetWriterInput *_videoInput;
    AVAssetWriterInputPixelBufferAdaptor *_videoPixelAdaptor;
    NSError *_error;
    dispatch_queue_t _dispatchQueue;
    dispatch_group_t _dispatchGroup;
    EAGLContext *_eaglContext;
    CIContext *_ciContext;
    BOOL _animationsWereEnabled;
    CMTime _nextAllowedVideoFrame;
    Float64 _totalDuration;
    SCFilter *_watermarkFilter;
    CGSize _outputBufferSize;
    BOOL _outputBufferDiffersFromInput;
}

@end

@implementation SCAssetExportSession

-(id)init {
    self = [super init];
    
    if (self) {
        _dispatchQueue = dispatch_queue_create("me.corsin.EvAssetExportSession", nil);
        _dispatchGroup = dispatch_group_create();
        _useGPUForRenderingFilters = YES;
        _audioConfiguration = [SCAudioConfiguration new];
        _videoConfiguration = [SCVideoConfiguration new];
        _timeRange = CMTimeRangeMake(kCMTimeZero, kCMTimePositiveInfinity);
    }
    
    return self;
}

- (id)initWithAsset:(AVAsset *)inputAsset {
    self = [self init];
    
    if (self) {
        self.inputAsset = inputAsset;
    }
    
    return self;
}

- (AVAssetWriterInput *)addWriter:(NSString *)mediaType withSettings:(NSDictionary *)outputSettings {
    AVAssetWriterInput *writer = [AVAssetWriterInput assetWriterInputWithMediaType:mediaType outputSettings:outputSettings];
    
    if ([_writer canAddInput:writer]) {
        [_writer addInput:writer];
    }
    
    return writer;
}

- (BOOL)processPixelBuffer:(CVPixelBufferRef)pixelBuffer presentationTime:(CMTime)presentationTime {
    return [_videoPixelAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
}

- (BOOL)processSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (_videoPixelAdaptor != nil) {
        CVPixelBufferRef inputPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        NSTimeInterval timeSeconds = CMTimeGetSeconds(time);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CVPixelBufferRef outputPixelBuffer = nil;
        
        if (_outputBufferDiffersFromInput) {
            CVReturn ret = CVPixelBufferPoolCreatePixelBuffer(nil, _videoPixelAdaptor.pixelBufferPool, &outputPixelBuffer);
            
            if (ret != kCVReturnSuccess) {
                NSLog(@"Unable to allocate pixelBuffer: %d", ret);
                return NO;
            }
            
            CVPixelBufferLockBaseAddress(outputPixelBuffer, 0);
        } else {
            outputPixelBuffer = inputPixelBuffer;
        }
        

        CVPixelBufferLockBaseAddress(inputPixelBuffer, 0);
        
        if (_ciContext != nil) {
            CIImage *image = [CIImage imageWithCVPixelBuffer:inputPixelBuffer];
            
            CIImage *result = image;
            
            if (_videoConfiguration.filter != nil) {
                result = [_videoConfiguration.filter imageByProcessingImage:result atTime:timeSeconds];
            }
            
            if (_watermarkFilter != nil) {
                [_watermarkFilter setParameterValue:result forKey:kCIInputBackgroundImageKey];
                result = [_watermarkFilter parameterValueForKey:kCIOutputImageKey];
            }
            
            if (!CGSizeEqualToSize(result.extent.size, _outputBufferSize)) {
                result = [result imageByCroppingToRect:CGRectMake(0, 0, _outputBufferSize.width, _outputBufferSize.height)];
            }
            
            [_ciContext render:result toCVPixelBuffer:outputPixelBuffer bounds:result.extent colorSpace:colorSpace];
        }
        
        UIView<SCVideoOverlay> *overlay = self.videoConfiguration.overlay;
        
        if (overlay != nil) {
            if ([overlay respondsToSelector:@selector(updateWithVideoTime:)]) {
                [overlay updateWithVideoTime:timeSeconds];
            }
            
            CGContextRef ctx = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(outputPixelBuffer), CVPixelBufferGetWidth(outputPixelBuffer), CVPixelBufferGetHeight(outputPixelBuffer), 8, CVPixelBufferGetBytesPerRow(outputPixelBuffer), colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);

            CGContextTranslateCTM(ctx, 1, CGBitmapContextGetHeight(ctx));
            CGContextScaleCTM(ctx, 1, -1);
            
            overlay.frame = CGRectMake(0, 0, CVPixelBufferGetWidth(outputPixelBuffer), CVPixelBufferGetHeight(outputPixelBuffer));
            [overlay layoutIfNeeded];
            
            [overlay.layer renderInContext:ctx];
            
            CGContextRelease(ctx);
        }
        
        BOOL success = [self processPixelBuffer:outputPixelBuffer presentationTime:time];
        
        CVPixelBufferUnlockBaseAddress(inputPixelBuffer, 0);
        
        if (inputPixelBuffer != outputPixelBuffer) {
            CVPixelBufferUnlockBaseAddress(outputPixelBuffer, 0);
            CVPixelBufferRelease(outputPixelBuffer);
        }
        
        CGColorSpaceRelease(colorSpace);
        
        return success;
    } else {
        return [_videoInput appendSampleBuffer:sampleBuffer];
    }
}

- (void)markInputComplete:(AVAssetWriterInput *)input error:(NSError *)error {
    if (_reader.status == AVAssetReaderStatusFailed) {
        _error = _reader.error;
    } else if (error != nil) {
        _error = error;
    }
    
    [input markAsFinished];
}

- (void)beginReadWriteOnInput:(AVAssetWriterInput *)input fromOutput:(AVAssetReaderOutput *)output {
    if (input != nil) {
        id<SCAssetExportSessionDelegate> delegate = self.delegate;
        
        if ([delegate respondsToSelector:@selector(assetExportSession:shouldReginReadWriteOnInput:fromOutput:)] && ![delegate assetExportSession:self shouldReginReadWriteOnInput:input fromOutput:output]) {
            return;
        }
        
        BOOL shouldNotifyProgress = input == _videoInput || _videoInput == nil;
        
        dispatch_group_enter(_dispatchGroup);
        [input requestMediaDataWhenReadyOnQueue:_dispatchQueue usingBlock:^{
            BOOL shouldReadNextBuffer = YES;
            while (input.isReadyForMoreMediaData && shouldReadNextBuffer) {
                CMSampleBufferRef buffer = [output copyNextSampleBuffer];
                
                if (buffer != nil) {
                    CMTime currentTime = CMSampleBufferGetPresentationTimeStamp(buffer);
                    if (input == _videoInput) {
                        if (CMTIME_COMPARE_INLINE(currentTime, >=, _nextAllowedVideoFrame)) {
//                            NSLog(@"Appending at %fs (%fs)", CMTimeGetSeconds(currentVideoTime), CMTimeGetSeconds(CMSampleBufferGetOutputDuration(buffer)));
                            shouldReadNextBuffer = [self processSampleBuffer:buffer];
                            
                            if (_videoConfiguration.maxFrameRate > 0) {
                                _nextAllowedVideoFrame = CMTimeAdd(currentTime, CMTimeMake(1, _videoConfiguration.maxFrameRate));
                            }
                        } else {
//                            NSLog(@"Skipping at %fs (%fs)", CMTimeGetSeconds(currentVideoTime), CMTimeGetSeconds(CMSampleBufferGetOutputDuration(buffer)));
                        }
                    } else {
                        shouldReadNextBuffer = [input appendSampleBuffer:buffer];
                    }
                    
                    if (shouldNotifyProgress) {
                        float progress = CMTimeGetSeconds(currentTime) / _totalDuration;
                        [self _setProgress:progress];
                    }
                    
                    CFRelease(buffer);
                } else {
                    shouldReadNextBuffer = NO;
                }
            }
            
            if (!shouldReadNextBuffer) {
                [self markInputComplete:input error:nil];
                
                dispatch_group_leave(_dispatchGroup);
            }
        }];
    }
}

- (void)_setProgress:(float)progress {
    [self willChangeValueForKey:@"progress"];
    
    _progress = progress;
    
    [self didChangeValueForKey:@"progress"];
    
    id<SCAssetExportSessionDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(assetExportSessionDidProgress:)]) {
        [delegate assetExportSessionDidProgress:self];
    }
}

- (void)callCompletionHandler:(void (^)())completionHandler {
    [self _setProgress:1];
    
    if (completionHandler != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });
    }
}

- (BOOL)setupCoreImage:(AVAssetTrack *)videoTrack {
    if ([self needsCIContext] && _videoInput != nil) {
        if (self.useGPUForRenderingFilters) {
            _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        }
        
        if (_eaglContext == nil) {
            NSDictionary *options = @{ kCIContextUseSoftwareRenderer : [NSNumber numberWithBool:YES] };
            _ciContext = [CIContext contextWithOptions:options];
        } else {
            NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null], kCIContextOutputColorSpace : [NSNull null] };

            _ciContext = [CIContext contextWithEAGLContext:_eaglContext options:options];
        }
        
        return YES;
    } else {
        _ciContext = nil;
        _eaglContext = nil;
        
        return NO;
    }
}

- (BOOL)needsInputPixelBufferAdaptor {
    id<SCAssetExportSessionDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector:@selector(assetExportSessionNeedsInputPixelBufferAdaptor:)] && [delegate assetExportSessionNeedsInputPixelBufferAdaptor:self]) {
        return YES;
    }
    
    return _ciContext != nil || self.videoConfiguration.overlay != nil;
}

+ (NSError*)createError:(NSString*)errorDescription {
    return [NSError errorWithDomain:@"SCAssetExportSession" code:200 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
}

- (BOOL)needsCIContext {
    return (_videoConfiguration.filter != nil && !_videoConfiguration.filter.isEmpty) || _videoConfiguration.watermarkImage != nil;
}

- (void)setupPixelBufferAdaptor:(CGSize)videoSize {
    if ([self needsInputPixelBufferAdaptor] && _videoInput != nil) {
        NSDictionary *pixelBufferAttributes = @{
                                                (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA],
                                                (id)kCVPixelBufferWidthKey : [NSNumber numberWithFloat:videoSize.width],
                                                (id)kCVPixelBufferHeightKey : [NSNumber numberWithFloat:videoSize.height]
                                                };
        
        _videoPixelAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoInput sourcePixelBufferAttributes:pixelBufferAttributes];
    }
}

- (SCFilter *)_buildWatermarkFilterForVideoTrack:(AVAssetTrack *)videoTrack {
    UIImage *watermarkImage = self.videoConfiguration.watermarkImage;
    
    if (watermarkImage != nil) {
        CGSize videoSize = videoTrack.naturalSize;
        
        CGRect watermarkFrame = self.videoConfiguration.watermarkFrame;
        
        switch (self.videoConfiguration.watermarkAnchorLocation) {
            case SCWatermarkAnchorLocationTopLeft:

                break;
            case SCWatermarkAnchorLocationTopRight:
                watermarkFrame.origin.x = videoSize.width - watermarkFrame.size.width - watermarkFrame.origin.x;
                break;
            case SCWatermarkAnchorLocationBottomLeft:
                watermarkFrame.origin.y = videoSize.height - watermarkFrame.size.height - watermarkFrame.origin.y;
                
                break;
            case SCWatermarkAnchorLocationBottomRight:
                watermarkFrame.origin.y = videoSize.height - watermarkFrame.size.height - watermarkFrame.origin.y;
                watermarkFrame.origin.x = videoSize.width - watermarkFrame.size.width - watermarkFrame.origin.x;
                break;
        }
        
        UIGraphicsBeginImageContextWithOptions(videoSize, NO, 1);
        
        [watermarkImage drawInRect:watermarkFrame];
        
        UIImage *generatedWatermarkImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        SCFilter *watermarkFilter = [SCFilter filterWithCIFilterName:@"CISourceOverCompositing"];
        CIImage *watermarkCIImage = [CIImage imageWithCGImage:generatedWatermarkImage.CGImage];
        [watermarkFilter setParameterValue:watermarkCIImage forKey:kCIInputImageKey];
        
        return watermarkFilter;
    }
    
    return nil;
}

- (void)exportAsynchronouslyWithCompletionHandler:(void (^)())completionHandler {
    _nextAllowedVideoFrame = kCMTimeZero;
    NSError *error = nil;
    
    [[NSFileManager defaultManager] removeItemAtURL:self.outputUrl error:nil];
    
    _writer = [AVAssetWriter assetWriterWithURL:self.outputUrl fileType:self.outputFileType error:&error];
    _writer.metadata = [SCRecorderTools assetWriterMetadata];

    EnsureSuccess(error, completionHandler);
    
    _reader = [AVAssetReader assetReaderWithAsset:self.inputAsset error:&error];
    _reader.timeRange = _timeRange;
    EnsureSuccess(error, completionHandler);
    
    NSArray *audioTracks = [self.inputAsset tracksWithMediaType:AVMediaTypeAudio];
    if (audioTracks.count > 0 && self.audioConfiguration.enabled && !self.audioConfiguration.shouldIgnore) {
        // Input
        NSDictionary *audioSettings = [_audioConfiguration createAssetWriterOptionsUsingSampleBuffer:nil];
        _audioInput = [self addWriter:AVMediaTypeAudio withSettings:audioSettings];
        
        // Output
        AVAudioMix *audioMix = self.audioConfiguration.audioMix;
        
        AVAssetReaderOutput *reader = nil;
        NSDictionary *settings = @{ AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatType] };
        if (audioMix == nil) {
            reader = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTracks.firstObject outputSettings:settings];
        } else {
            AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:audioTracks audioSettings:settings];
            audioMixOutput.audioMix = audioMix;
            reader = audioMixOutput;
        }
        reader.alwaysCopiesSampleData = NO;
        
        if ([_reader canAddOutput:reader]) {
            [_reader addOutput:reader];
            _audioOutput = reader;
        } else {
            NSLog(@"Unable to add audio reader output");
        }
    } else {
        _audioOutput = nil;
    }
    
    NSArray *videoTracks = [self.inputAsset tracksWithMediaType:AVMediaTypeVideo];
    CGSize inputBufferSize = CGSizeZero;
    AVAssetTrack *videoTrack = nil;
    if (videoTracks.count > 0 && self.videoConfiguration.enabled && !self.videoConfiguration.shouldIgnore) {
        videoTrack = [videoTracks objectAtIndex:0];

        // Input
        NSDictionary *videoSettings = [_videoConfiguration createAssetWriterOptionsWithVideoSize:videoTrack.naturalSize];
        
        _videoInput = [self addWriter:AVMediaTypeVideo withSettings:videoSettings];
        if (_videoConfiguration.keepInputAffineTransform) {
            _videoInput.transform = videoTrack.preferredTransform;
        } else {
            _videoInput.transform = _videoConfiguration.affineTransform;
        }
        
        // Output
        NSDictionary *settings = nil;
        if ([self needsCIContext] || self.videoConfiguration.overlay != nil) {
            settings = @{
                         (id)kCVPixelBufferPixelFormatTypeKey     : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA],
                         (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]
                         };
        }
        
        AVVideoComposition *videoComposition = self.videoConfiguration.composition;
        
        _watermarkFilter = [self _buildWatermarkFilterForVideoTrack:videoTrack];
        
        AVAssetReaderOutput *reader = nil;
        
        if (videoComposition == nil) {
            inputBufferSize = videoTrack.naturalSize;
            reader = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:settings];
        } else {
            AVAssetReaderVideoCompositionOutput *videoCompositionOutput = [AVAssetReaderVideoCompositionOutput assetReaderVideoCompositionOutputWithVideoTracks:videoTracks videoSettings:settings];
            videoCompositionOutput.videoComposition = videoComposition;
            reader = videoCompositionOutput;
            inputBufferSize = videoComposition.renderSize;
        }
        
        reader.alwaysCopiesSampleData = NO;

        if ([_reader canAddOutput:reader]) {
            [_reader addOutput:reader];
            _videoOutput = reader;
        } else {
            NSLog(@"Unable to add video reader output");
        }
    } else {
        _videoOutput = nil;
    }
    
    EnsureSuccess(error, completionHandler);
    
    CGSize outputBufferSize = inputBufferSize;
    if (!CGSizeEqualToSize(self.videoConfiguration.bufferSize, CGSizeZero)) {
        outputBufferSize = self.videoConfiguration.bufferSize;
    }
    
    _outputBufferSize = outputBufferSize;
    _outputBufferDiffersFromInput = !CGSizeEqualToSize(inputBufferSize, outputBufferSize);
    
    [self setupCoreImage:videoTrack];
    [self setupPixelBufferAdaptor:outputBufferSize];
    
    if (![_reader startReading]) {
        EnsureSuccess(_reader.error, completionHandler);
    }
    
    if (![_writer startWriting]) {
        EnsureSuccess(_writer.error, completionHandler);
    }
    
    [_writer startSessionAtSourceTime:kCMTimeZero];
    
    _totalDuration = CMTimeGetSeconds(_inputAsset.duration);
    
    [self beginReadWriteOnInput:_videoInput fromOutput:_videoOutput];
    [self beginReadWriteOnInput:_audioInput fromOutput:_audioOutput];
    
    dispatch_group_notify(_dispatchGroup, _dispatchQueue, ^{
        if (_error == nil) {
            _error = _writer.error;
        }
        
        if (_error == nil) {
            [_writer finishWritingWithCompletionHandler:^{
                _error = _writer.error;
                [self callCompletionHandler:completionHandler];
            }];
        } else {
            [self callCompletionHandler:completionHandler];
        }
    });
}

- (NSError *)error {
    return _error;
}

- (dispatch_queue_t)dispatchQueue {
    return _dispatchQueue;
}

- (dispatch_group_t)dispatchGroup {
    return _dispatchGroup;
}

- (AVAssetWriterInput *)videoInput {
    return _videoInput;
}

- (AVAssetWriterInput *)audioInput {
    return _audioInput;
}

- (AVAssetReader *)reader {
    return _reader;
}

@end
