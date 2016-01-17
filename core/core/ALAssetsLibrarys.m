//
//  ALAssetsLibrarys.swift
//  LinCore
//
//  Created by lin on 1/29/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "ALAssetsLibrarys.h"
#import "LinUtil/util.h"


@implementation ALAssetsLibrary(LinCore)

-(void)writeImageToSavedPhotosAlbums:(NSArray*)images albumName:(NSString*)albumName metadata:(NSDictionary*)metadata completion:(void(^)(NSArray * urls,NSArray * errors))completion{
    
    
    [Queue asynThread:^{
        AutoResetEvent * set = [[AutoResetEvent alloc] init];
        for (NSObject * tmp in images) {
            CGImageRef image = (__bridge CGImageRef)(tmp);
            [set reset];
            [self writeImageToSavedPhotosAlbum:image albumName:albumName metadata:metadata completion:^(NSURL *url, NSError *error) {
                [set set];
            }];
            [set waitOne];
        }
        [Queue mainQueue:^{
            completion(nil,nil);
        }];
    }];
}

-(void)writeImageToSavedPhotosAlbum:(CGImageRef)image albumName:(NSString*)albumName metadata:(NSDictionary*)metadata completion:(void(^)(NSURL * url,NSError * error))completion{

    [self writeImageToSavedPhotosAlbum:image metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
       

        __weak ALAssetsLibrary * wself = self;
        if (error != nil) {
            if (completion != nil) {
                completion(assetURL,error);
            }
            return;
        }
        __block BOOL albumWasFound = FALSE;
        
        [wself enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group != nil) {
                NSComparisonResult r = [albumName compare:(NSString*)[group valueForProperty:ALAssetsGroupPropertyName]];
                if (r == NSOrderedSame) {
                    albumWasFound = TRUE;
                    [wself assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completion != nil) {
                            completion(nil,nil);
                        }
                    } failureBlock:^(NSError *error) {
                        if (completion != nil) {
                            completion(nil,error);
                        }
                    }];
                }
                return;
            }
            if (group == nil && albumWasFound == FALSE) {
                [wself addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group2) {
                    [wself assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group2 addAsset:asset];
                        if (completion != nil) {
                            completion(nil,nil);
                        }
                    } failureBlock:^(NSError *error) {
                        if (completion != nil) {
                            completion(nil,error);
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    if (completion != nil) {
                        completion(nil,error);
                    }
                }];
            }
            
        } failureBlock:^(NSError *error) {
            if (completion != nil) {
                completion(nil,error);
            }
        }];

        
    }];

}
@end