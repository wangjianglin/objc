//
//  LinImagesController.m
//  seller
//
//  Created by lin on 12/28/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <UIkit/UIKit.h>
#import "ScrollImagesView.h"
#import "ImageViews.h"
#import "UIGestureRecognizers.h"
#import "CameraViewController.h"
#import "UIViews.h"

//int LinImagesViewFullScreenCurrentItem = 0;
//BOOL isLinImagesViewFullScreen = FALSE;
//LinImagesView * preLinImagesView;
//LinImagesController * fullScreenController;



//@interface LinImagesController (){
//@public
//    BOOL _isFullScreen;
//    int _fullScreenItem;
//@private
//    LinImagesView * _imageView;
//    BOOL _edited;
//    NSArray * _imagePaths;
//    BOOL _fullScreen;
//    //    BOOL _isFullScreen;
//    BOOL _showPositionLabel;
//    LinImagesFill _fill;
//    BOOL _zoom;
//    NSString * _noImage;
//    NSURL * _vedioUrl;
//    BOOL _hasVedio;
//}

//-(void)setImageView:(LinImagesVi ew*)imageView;
//@end

@interface LinImagesContentView : UIScrollView<UIScrollViewDelegate>{
    @package
    NSString * _imagePath;
    CacheImageView * imageView;
    ImageFill _fill;
    BOOL _zoom;
    UIView * contentView;
    CGSize _preImageSize;
    CGSize _preViewSize;
    ScrollImagesView * _linImagesView;
}


-(id)initWithImagePath:(NSString *)imagePath fill:(ImageFill)fill zoom:(BOOL)zoom linImagesView:(ScrollImagesView*)linImagesView;

@property UIImage * image;
//
//    //使图像填满
@property ImageFill fill;
//
//    //缩放
@property BOOL zoom;

@end



@implementation LinImagesContentView

-(id)initWithImagePath:(NSString *)imagePath fill:(ImageFill)fill zoom:(BOOL)zoom linImagesView:(ScrollImagesView*)linImagesView{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        self->_imagePath = imagePath;
        self.fill = fill;
        self.zoom = zoom;
        self->_linImagesView = linImagesView;
        [self initView];
    }
    return self;
}

-(UIImage *)image{
    return self->imageView.image;
}
-(void)setImage:(UIImage *)image{
    self->imageView.image = image;
}

//    //使图像填满
-(ImageFill)fill{
    return self->_fill;
}
-(void)setFill:(ImageFill)fill{
    self->_fill = fill;
}

//    //缩放
-(BOOL)zoom{
    return self->_zoom;
}
-(void)setZoom:(BOOL)zoom{
    self->_zoom = zoom;
    self.bouncesZoom = zoom;
    self.zoomScale = 1;
    self.minimumZoomScale = 1;
    self.maximumZoomScale = zoom ? 8 : 1;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return contentView;
}

-(void)initView{
    __weak LinImagesContentView * wself = self;

//    self.backgroundColor = [UIColor grayColor];
    self.backgroundColor = [UIColor clearColor];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    contentView.backgroundColor = [[UIColor alloc] initWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];

    imageView = [[CacheImageView alloc] init];
    imageView.noImage = self->_linImagesView.noImage;
    imageView.imageChanged = ^(CacheImageView * _){
        [wself update];
    };
    imageView.path = self->_imagePath;

    [contentView addSubview:imageView];
    self.delegate = self;
    self.autoresizesSubviews = TRUE;
//    self.userInteractionEnabled = FALSE;
    self.contentMode = UIViewContentModeRedraw;

    self.scrollsToTop = false;
    self.delaysContentTouches = false;
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    self.contentMode = UIViewContentModeRedraw;
    self.userInteractionEnabled = true;
    self.autoresizesSubviews = false;
}

-(void)update{
    CGRect contentViewRect = contentView.bounds;
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return;
    }
    if (imageView.image == nil) {
        return;
    }
    if (contentViewRect.size.height != self.bounds.size.height ||
        contentViewRect.size.width != self.bounds.size.width) {
        CGRect contentViewRect2 = contentView.bounds;
        contentViewRect2.size.height = self.bounds.size.height;
        contentViewRect2.size.width = self.bounds.size.width;
        contentView.frame = contentViewRect2;
        self.zoomScale = 1;
    }
    CGSize imageSize = imageView.image.size;
    if (imageSize.width != _preImageSize.width || imageSize.height != _preImageSize.height
        || self.bounds.size.width != _preViewSize.width || self.bounds.size.height != _preViewSize.height
        ) {
        _preImageSize = imageSize;
        _preViewSize = self.bounds.size;
        contentViewRect = contentView.bounds;
        CGFloat s = 1.0;
        if (self.fill != ImageFillFill) {
            s = (_preImageSize.width * 1.0 /_preImageSize.height)/(self.bounds.size.width * 1.0 /self.bounds.size.height);
        }
        if ((ImageFillDefault == self.fill && s > 1) || self.fill == ImageFillWithWidth) {
            contentViewRect.size.width = self.bounds.size.width;
            contentViewRect.size.height = self.bounds.size.height / s;
            contentViewRect.origin.x = 0;
            contentViewRect.origin.y = (self.bounds.size.height - contentViewRect.size.height) / 2;
        }else{
            contentViewRect.size.width = self.bounds.size.width * s;
            contentViewRect.size.height = self.bounds.size.height;
            contentViewRect.origin.y = 0;
            contentViewRect.origin.x = (self.bounds.size.width - contentViewRect.size.width) / 2;
        }
        imageView.frame = contentViewRect;
        self.zoomScale = 1;
    }
}

-(void)layoutSubviews{
    [self update];
}
@end


@interface ScrollImagesView()<QBImagePickerControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    @public
    BOOL _isFullScreen;
    int _fullScreenItem;
    
    @private
    BOOL _edited;
    ImageFill _fill;
    BOOL _zoom;
    BOOL _showPositionLabel;
    BOOL _fullScreen;
    NSMutableArray * addImages;
    NSMutableArray * views;
    UIView * positionLabelView;
    BOOL resetImagePaths;
    NSArray * _imagePaths;
    NSURL * _vedioUrl;
    BOOL _hasVedio;
    NSMutableArray * noneImageLabels;
    UIScrollView * scrollView;
    int _currentItem;
    UILabel * positionLabel;
//    MPMoviePlayerController * player;
    FillImageView * _playImageView;
}
@end

@implementation ScrollImagesView

-(instancetype)init{
    self = [super init];
    if (self) {
        resetImagePaths = true;
        self.showPositionLabel = true;
        [self initView];
    }
    return self;
}


-(BOOL)edited{
    return self->_edited;
}
-(void)setEdited:(BOOL)edited{
    self->_edited = edited;
//    self.userInteractionEnabled = self->_edited || self->_fullScreen;
//    self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen);
    self.userInteractionEnabled = TRUE;
//    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
//    NSLog(@"controller:%@",self->_controller);
    if (addImages != nil) {
        for (UIView * item in addImages) {
            item.hidden = !edited;
        }
    }
}

-(BOOL)fullScreen{
    return _fullScreen;
}

-(void)setFullScreen:(BOOL)fullScreen{
    _fullScreen = fullScreen;
//    self.userInteractionEnabled = self->_edited || self->_fullScreen;
//     self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen);
    self.userInteractionEnabled = TRUE;
//    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
}

////使图像填满
-(ImageFill)fill{
    return _fill;
}
-(void)setFill:(ImageFill)fill{
    _fill = fill;
    if (views != nil) {
        for (LinImagesContentView * item in views) {
            item.fill = self.fill;
        }
    }
}
////缩放
-(BOOL)zoom{
    return _zoom;
}
-(void)setZoom:(BOOL)zoom{
    _zoom = zoom;
    if (views != nil) {
        for (LinImagesContentView * item in views) {
            item.zoom = zoom;
        }
    }
}
//
////是否显示位置标记
-(BOOL)showPositionLabel{
    return _showPositionLabel;
}
-(void)setShowPositionLabel:(BOOL)showPositionLabel{
    _showPositionLabel = showPositionLabel;
    positionLabelView.hidden = !showPositionLabel;
}

-(NSArray *)imagesForEdited{
    NSMutableArray * images = [[NSMutableArray alloc] init];
    if (views!=nil) {
        for (LinImagesContentView * item in views) {
            if (item.tag == 2) {
                [images addObject:item.image];
            }else{
                [images addObject:[NSNull null]];
            }
        }
    }
    return images;
}

-(NSArray *)images{
    NSMutableArray * images = [[NSMutableArray alloc] init];
    
    if (views != nil) {
        for (LinImagesContentView * item in views) {
            if (item->imageView.image == nil) {
                [images addObject:[NSNull null]];
            }else{
                [images addObject:item->imageView.image];
            }
        }
    }
    
    return  images;
}

-(NSURL *)vedioUrl{
    return _vedioUrl;
}

-(void)setVedioUrl:(NSURL*)vedioUrl{
    _vedioUrl = vedioUrl;
    [self resetVedioView];
}

-(BOOL)hasVedio{
    return _hasVedio;
}
-(void)setHasVedio:(BOOL)hasVedio{
    _hasVedio = hasVedio;
    [self resetVedioView];
}
-(NSArray *)imagePaths{
    return _imagePaths;
}
-(void)setImagePaths:(NSArray *)imagePaths{
    _imagePaths = imagePaths;
    [self resetImageViews];
}
-(void)resetVedioView{
    if (!_hasVedio) {
        
        //if (views != nil && views.count > 0 && [NSStringFromClass([views[0] class]) isEqualToString:@"MPMovieView"] ){
        if (_playImageView != nil) {
            [views[0] removeFromSuperview];
            [views removeObjectAtIndex:0];
            [addImages removeObjectAtIndex:0];
            [self update];
        }
        return;
    }
    if (views == nil) {
        views = [[NSMutableArray alloc] init];
    }
    //if (views == nil && [views[0] isKindOfClass:[MPMovieView Class]]) {
    if (_playImageView == nil) {
//        player = [[MPMoviePlayerController alloc] initWithContentURL:nil];
//        
//        //player.view.frame = CGRectMake(20, 20, 200, 300);
//        player.controlStyle = MPMovieControlStyleDefault;
//        //player.moviewControlMode = MPMovieControlModeDefault;
//        
//        //[views addObject:player.view];
//        player.view.backgroundColor = [UIColor clearColor];
        
        _playImageView = [[FillImageView alloc] init];
        _playImageView.frame = CGRectMake(0, 0, 100, 100);
        //        [views insertObject:player.view atIndex:0];
//        [scrollView addSubview:player.view];
        [views insertObject:_playImageView atIndex:0];
        [scrollView addSubview:_playImageView];
        _playImageView.image = self.vedioImage;
//        _playImageView.image = [UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_camera_add.png"];;
        
        _playImageView.userInteractionEnabled = TRUE;
        
        [_playImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVedio:)]];
        
        UIImageView * itemAddImage = [[UIImageView alloc] init];
        //[addImages addObject:itemAddImage];
        [addImages insertObject:itemAddImage atIndex:0];
        itemAddImage.image = [UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_camera_add.png"];
        
        [scrollView addSubview:itemAddImage];
        
        
        itemAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        itemAddImage.frame = CGRectMake(0, 0, 64, 50);
        itemAddImage.hidden = !self.edited;

        
    }
//    player.contentURL = _vedioUrl;
    [self update];
    
}

-(void)movieFinishedCallback:(id)sender{
    MPMoviePlayerController * playerViewController = ((NSNotification*)sender).object;
    //    playerViewController view
    //    [playerViewController removeFromParentViewController];
    [playerViewController.view removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //    self.navigationController.navigationBar.hidden = FALSE;
}

-(void)playVedio:(id)_{
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:_vedioUrl];
    
//    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] init];
    
    [self.rootViewController addChildViewController:playerViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[playerViewController moviePlayer]];
    //-- add to view---
    [self.rootViewController.view addSubview:playerViewController.view];
    
    //playerViewController.view.frame = CGRectMake(20, 20, 200, 300);
    
    //playerViewController.
    
    //---play movie---
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    
    //player.contentURL = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
//    player.contentURL = _vedioUrl;
    
//    [player prepareToPlay];
    [player play];
}
-(void)resetImageViews{
    if (resetImagePaths == false) {
        return;
    }
    if (views != nil) {
        for (UIView * item in views) {
            [item removeFromSuperview];
        }
    }

    if (noneImageLabels) {
        for (UIView * item in noneImageLabels) {
            [item removeFromSuperview];
        }
    }

    if (addImages != nil) {
        for (UIView * item in addImages) {
            [item removeFromSuperview];
        }
    }

    views = [[NSMutableArray alloc] init];
    noneImageLabels = [[NSMutableArray alloc] init];
    addImages = [[NSMutableArray alloc] init];

    LinImagesContentView * itemView;
    
    if (_playImageView != nil) {
//        [views addObject:player.view];
//        [scrollView addSubview:player.view];
        [views addObject:_playImageView];
        [scrollView addSubview:_playImageView];
        
        UIImageView * itemAddImage = [[UIImageView alloc] init];
        [addImages addObject:itemAddImage];
        [scrollView addSubview:itemAddImage];
//        itemAddImage.image = [UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_camera_add.png"];
        
        itemAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        itemAddImage.frame = CGRectMake(0, 0, 60, 60);
        itemAddImage.hidden = !self.edited;

        
    }
    
    
    for (int n=0; n<_imagePaths.count; n++) {
        itemView = [[LinImagesContentView alloc] initWithImagePath:_imagePaths[n] fill:self.fill zoom:self.zoom linImagesView:self];
//        itemView.backgroundColor = [[UIColor alloc] initWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
        itemView.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:itemView];
        [views addObject:itemView];

        UIImageView * itemAddImage = [[UIImageView alloc] init];
        [addImages addObject:itemAddImage];
        itemAddImage.image = [UIImage imageNamed:@"resources.bundle/publish/imagesEditAdd.png"];
        [scrollView addSubview:itemAddImage];
        itemAddImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        itemAddImage.frame = CGRectMake(0, 0, 60, 60);
        itemAddImage.hidden = !self.edited;
        itemAddImage.tag = n;

        UILabel * itemNoneImageLabel = [[UILabel alloc] init];
        [noneImageLabels addObject:itemNoneImageLabel];
        itemNoneImageLabel.text = @"没有图像";
        itemNoneImageLabel.textAlignment = NSTextAlignmentCenter;
        itemNoneImageLabel.frame = CGRectMake(0, 0, 160, 60);
        itemNoneImageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [scrollView addSubview:itemNoneImageLabel];
    }
    if (self->_isFullScreen) {
        [self setCurrentItem:self->_fullScreenItem];
    }else{
        [self setCurrentItem:0];
    }
    [self update];
}

-(void)initView{
    
    self.userInteractionEnabled = TRUE;

    __weak ScrollImagesView * wself = self;
    scrollView = [[UIScrollView alloc] init];
    self.backgroundColor = [[UIColor alloc] initWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.autoresizesSubviews = TRUE;
    scrollView.contentMode = UIViewContentModeRedraw;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.scrollsToTop = FALSE;
    scrollView.delaysContentTouches = FALSE;
    scrollView.pagingEnabled = TRUE;
    scrollView.bouncesZoom = FALSE;
    scrollView.zoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 1;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    positionLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    positionLabelView.userInteractionEnabled = FALSE;
    positionLabelView.hidden = !self.showPositionLabel;
    positionLabelView.backgroundColor = [UIColor clearColor];
    [self addSubview:positionLabelView];

    positionLabel = [[UILabel alloc] init];
    positionLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    positionLabel.backgroundColor = [UIColor clearColor];

    CGRect pathFrame = CGRectMake(0, 0, 40, 40);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:20];

    CAShapeLayer * circleShape = [[CAShapeLayer alloc] init];
    circleShape.path = path.CGPath;
    circleShape.position = CGPointMake(0, 0);
    circleShape.fillColor = [[[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:0.85] CGColor];
    circleShape.strokeColor = [[UIColor clearColor] CGColor];
    circleShape.lineWidth = 1.0;
    
    [positionLabelView.layer addSublayer:circleShape];
    [positionLabelView addSubview:positionLabel];
//    positionLabelView.backgroundColor = [UIColor redColor];
    positionLabel.frame =CGRectMake(positionLabelView.bounds.origin.x, positionLabelView.bounds.origin.y, positionLabelView.bounds.size.width, positionLabelView.bounds.size.height);
    positionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithAction:^(NSObject * sender) {
        [wself addImageTap];
    }]];
//    self.userInteractionEnabled = FALSE;
//     self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen);
    self.userInteractionEnabled = TRUE;
//    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
}

-(void)update{
//    self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen) && self->_controller;
    self.userInteractionEnabled = TRUE;
    CGRect rect = self.bounds;
    if (rect.size.width == 0 || rect.size.height == 0) {
        return;
    }
    
    LinImagesContentView * imageItme;
    UIView * item;
    int imageItemN = -1;
    for(int n=0;n<views.count;n++){
        
        item = (UIView*)views[n];
        
        CGRect itemRect = item.bounds;
        if (itemRect.size.width == 0) {
            itemRect.origin.x = rect.size.width*n;
        }else{
            itemRect.origin.x = rect.size.width * n + itemRect.origin.x / itemRect.size.width * rect.size.width;
        }
        
        itemRect.size.width = rect.size.width;
        itemRect.size.height = rect.size.height;
        item.frame = itemRect;

        
        UIImageView * itemAddImage = addImages[n];
        
        itemAddImage.hidden = !self.edited;
        
        if (_playImageView != nil && n == 0) {
            itemAddImage.hidden = FALSE;
            if (self.edited) {
                itemAddImage.image = [UIImage imageNamed:@"resources.bundle/publish/imagesEditAdd.png"];
            }else{
               itemAddImage.image = [UIImage imageNamed:@"LinCore.bundle/play.png"];
            }
        }
        
        CGRect itemAddImageRect = itemAddImage.bounds;
        itemAddImageRect.origin.x = rect.size.width * n + (rect.size.width - itemAddImageRect.size.width ) / 2;
        itemAddImageRect.origin.y = (rect.size.height - itemAddImageRect.size.height) / 2.0;
        itemAddImage.frame = itemAddImageRect;
        
        [scrollView bringSubviewToFront:itemAddImage];
        
        if ([views[n] isKindOfClass:[LinImagesContentView class]]) {
            
            imageItemN++;
            
            imageItme = (LinImagesContentView*)views[n];
            
            ((UIView*)noneImageLabels[imageItemN]).hidden = imageItme->_imagePath != nil || self.edited;
        }
    }
    scrollView.contentSize = CGSizeMake(rect.size.width * views.count, rect.size.height);
    CGPoint offsetX = scrollView.contentOffset;
    offsetX.x = rect.size.width * [self currentItem];
    scrollView.contentOffset = offsetX;

    CGRect positionLabelRect = CGRectMake(0, 0, 40, 40);
    positionLabelRect.origin.x = rect.size.width - 40 - rect.size.width * 0.05;
    positionLabelRect.origin.y = rect.size.height * 0.05;
    positionLabelView.frame = positionLabelRect;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self update];
}

-(void)addImageTap{
    if (self.edited) {
        
        if (_hasVedio && _currentItem == 0) {
            
            __weak ScrollImagesView * wself = self;
            CameraViewController * camera = [[CameraViewController alloc] init];
            //CameraViewController
            //self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>
            //[self presentViewController:]
            [camera setResult:^(NSURL *file) {
                NSLog(@"file:%@",file);
//                player.contentURL = file;
//                [player play];
                ScrollImagesView * w = wself;
                w->_vedioUrl = file;
            }];
            [self.viewController presentViewController:camera animated:TRUE completion:nil];
            return;
        }
        int videoCount = _hasVedio?1:0;
        int index = _currentItem - videoCount;
        
        QBImagePickerController * imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
        imagePickerController.allowsMultipleSelection = TRUE;
        uint maxSelection = 0;
//        for (NSObject * item in self.imagePaths) {
        NSObject * item = nil;
        for (int n=0; n<self.imagePaths.count; n++) {
            item = self.imagePaths[n];
            if ((item == nil || [item isKindOfClass:[NSNull class]]) && [views[n+videoCount] isKindOfClass:[LinImagesContentView class]] &&
                ((LinImagesContentView*)views[n+videoCount]).image == nil
                //&&
                //(((LinImagesContentView*)views[n])->_imagePath == nil || [((LinImagesContentView*)views[n])->_imagePath isKindOfClass:[NSNull class]])
                ) {
                maxSelection++;
            }
        }
        if ((self.imagePaths[index] != nil && ![self.imagePaths[index] isKindOfClass:[NSNull class]])
            || ((LinImagesContentView*)views[_currentItem]).image != nil)
             {
            maxSelection++;
        }
        imagePickerController.maximumNumberOfSelection = maxSelection;
        imagePickerController.limitsMaximumNumberOfSelection = TRUE;
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self.viewController presentViewController:navigationController animated:TRUE completion:nil];

    }else {
        if (self->_isFullScreen) {//退出全屏
//            isLinImagesViewFullScreen = FALSE;
//            [preLinImagesView setCurrentItem:[self currentItem]];
            [self.viewController dismissViewControllerAnimated:TRUE completion:nil];
        }else if(self.fullScreen){//进入全屏
//            LinImagesViewFullScreenCurrentItem = [self currentItem];
//            isLinImagesViewFullScreen = TRUE;
            
//            preLinImagesView = self;
            
            ScrollImagesView * fullScreenView = [[ScrollImagesView alloc] init];
//            fullScreenController = [[LinImagesController alloc] init];
            
//            LinImagesView * fullImagesView = [[LinImagesView alloc] init];
            fullScreenView.edited = FALSE;
            fullScreenView.fill = FALSE;
            fullScreenView.zoom = TRUE;
            fullScreenView.fullScreen = FALSE;
            fullScreenView.imagePaths = self.imagePaths;
            fullScreenView.noImage = self.noImage;
            fullScreenView->_isFullScreen = TRUE;
            fullScreenView->_fullScreenItem = [self currentItem];
//            fullImagesView.controller = fullScreenController;
            fullScreenView.showPositionLabel = FALSE;
            
//            [fullScreenController setImageView:fullImagesView];
            fullScreenView.backgroundColor = [[UIColor alloc] initWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
            
            UIViewController * fullScreenController = [[UIViewController alloc] init];
            
            [fullScreenController.view addSubview:fullScreenView];
            fullScreenView.frame = CGRectMake(0, 0, fullScreenController.view.bounds.size.width, fullScreenController.view.bounds.size.height);
            fullScreenView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.viewController presentViewController:fullScreenController animated:TRUE completion:nil];
        }
    }
}

-(int)currentItem{
    return _currentItem;
}
-(void)setCurrentItem:(int)currentItem{
    if (views != nil) {
        if (views.count > 0) {
            positionLabel.text = [[NSString alloc] initWithFormat:@"%d/%lu",currentItem+1,(unsigned long)views.count ];
            if ([self->views[currentItem] isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView*)self->views[currentItem]).zoomScale = 1.0;
                ((UIScrollView*)self->views[currentItem]).zoomScale = 1.0;
            }
        }else{
            positionLabel.text = @"0/0";
        }
    }
    _currentItem = currentItem;
    
    CGPoint point = scrollView.contentOffset;
    point.x = self.bounds.size.width * currentItem;
    scrollView.contentOffset = point;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView2{
    CGFloat contentOffsetX = scrollView2.contentOffset.x;
    if (views != nil) {
        UIView * item;
        for (int n=0;n<views.count;n++) {
            item = views[n];
            CGFloat tmp = item.frame.origin.x - contentOffsetX;
            CGFloat w = item.frame.size.width / 2 - 10;
            if (tmp > -w && tmp < w) {
                [self setCurrentItem:n];
                break;
            }
        }
    }
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info{

    if (imagePickerController.allowsMultipleSelection) {
        NSArray * mediaInfoArray = (NSArray*)info;
        int start = [self currentItem];
        for (NSDictionary * item in mediaInfoArray) {
            while (!([views[start % views.count] isKindOfClass:[LinImagesContentView class]]) || (
                   ((LinImagesContentView*)views[start % views.count]).image != nil &&
                   ![((LinImagesContentView*)views[start % views.count]).image isKindOfClass:[NSNull class]] && start != [self currentItem]))
            {
                start++;
            }
            UIImage * image = (UIImage*)(item[@"UIImagePickerControllerOriginalImage"]);
            ((LinImagesContentView*)views[start%views.count]).image = image;
            ((LinImagesContentView*)views[start%views.count]).tag = 2;
            start++;
        }
    }
    [imagePickerController dismissViewControllerAnimated:TRUE completion:nil];

}

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [imagePickerController dismissViewControllerAnimated:TRUE completion:nil];
}

-(NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController{
    return @"选择所有";
}

-(NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController{
    return @"取消所有选择";
}

-(NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos{
    return [[NSString alloc] initWithFormat:@"共有%lu张照片",(unsigned long)numberOfPhotos];
}

-(NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos{
    return [[NSString alloc] initWithFormat:@"共有%lu个视频",(unsigned long)numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos{
    return [[NSString alloc] initWithFormat:@"共有%lu张照片，%lu个视频",(unsigned long)numberOfPhotos,(unsigned long)numberOfVideos];
}

@end



//@implementation LinImagesController
//
////-(void)setFullScreenStatus:(BOOL)fullScreenStatus{
////    _isFullScreen = fullScreenStatus;
////    imageView->_isFullScreen = fullScreenStatus;
////}
//-(BOOL)edited{
//    if(_imageView){
//        return _imageView.edited;
//    }
//    return _edited;
//}
//-(void)setEdited:(BOOL)edited{
//    _edited = edited;
//    [_imageView setEdited:edited];
//}
//
//-(NSArray *)imagesForEdited{
//    return [_imageView imagesForEdited];
//}
//
//-(NSArray *)images{
//    if(_imageView){
//        return _imageView.images;
//    }
//    return nil;
//}
//-(NSURL *)vedioUrl{
//    if (_imageView) {
//        return _imageView.vedioUrl;
//    }
//    return _vedioUrl;
//}
//
//-(void)setVedioUrl:(NSURL*)vedioUrl{
//    if (_imageView) {
//        _imageView.vedioUrl = vedioUrl;
//    }
//    _vedioUrl = vedioUrl;
//}
//
//-(BOOL)hasVedio{
//    if (_imageView) {
//        return _imageView.hasVedio;
//    }
//    return _hasVedio;
//}
//-(void)setHasVedio:(BOOL)hasVedio{
//    if (_imageView) {
//        _imageView.hasVedio = hasVedio;
//    }
//    _hasVedio = hasVedio;
//}
//
//-(NSArray *)imagePaths{
//    if (_imageView != nil) {
//        return [_imageView imagePaths];
//    }
//    return _imagePaths;
//}
//-(void)setImagePaths:(NSArray *)imagePaths{
//    [_imageView setImagePaths:imagePaths];
//    self->_imagePaths = imagePaths;
//}
//
////    //是否可以全屏
//-(BOOL)fullScreen{
//    if(_imageView){
//        return _imageView.fullScreen;
//    }
//    return _fullScreen;
//}
//-(void)setFullScreen:(BOOL)fullScreen{
//    [_imageView setFullScreen:fullScreen];
//    _fullScreen = fullScreen;
//}
////
////    //使图像填满
//-(LinImagesFill)fill{
//    if(_imageView){
//        return _imageView.fill;
//    }
//    return _fill;
//}
//-(void)setFill:(LinImagesFill)fill{
//    _fill = fill;
//    [_imageView setFill:fill];
//}
////    //缩放
//-(BOOL)zoom{
//    if(_imageView){
//        return _imageView.zoom;
//    }
//    return _zoom;
//}
//-(void)setZoom:(BOOL)zoom{
//    _zoom = zoom;
//    [_imageView setZoom:zoom];
//}
////    
////    //是否显示位置标记
//-(BOOL)showPositionLabel{
//    if(_imageView){
//        return _imageView.showPositionLabel;
//    }
//    return _showPositionLabel;
//}
//-(void)setShowPositionLabel:(BOOL)showPositionLabel{
//    _showPositionLabel = showPositionLabel;
//    [_imageView setShowPositionLabel:showPositionLabel];
//}
//
//-(NSString *)noImage{
//    if(_imageView){
//        return _imageView.noImage;
//    }
//    return _noImage;
//}
//-(void)setNoImage:(NSString *)noImage{
//    self->_noImage = noImage;
//    [_imageView setNoImage:noImage];
//}
//
////-(void)loadView{
////    imageView = [[LinImagesView alloc] init];
////    self.view = imageView;
////}
//
//
//-(void)setImageView:(LinImagesView*)imageView{
//    self->_imageView = imageView;
//}
//-(void)viewDidLoad{
//    [super viewDidLoad];
//
//    if(_imageView){
//        _imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self.view addSubview:_imageView];
//        return;
//    }
//    _imageView = [[LinImagesView alloc] init];
//    _imageView.controller = self;
//    _imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _imageView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_imageView];
//
//    _imageView->_isFullScreen = self->_isFullScreen;
//    _imageView->_fullScreenItem = self->_fullScreenItem;
//    _imageView.edited = self->_edited;
//    _imageView.fill =self->_fill;
//    _imageView.zoom = self->_zoom;
//    _imageView.fullScreen = self->_fullScreen;
//    _imageView.showPositionLabel = self->_showPositionLabel;
//    _imageView.noImage = self->_noImage;
//    _imageView.imagePaths = _imagePaths;
//    _imageView.vedioUrl = _vedioUrl;
//    _imageView.hasVedio = _hasVedio;
//    
//}
//
//@end
