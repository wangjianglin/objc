//
//  ALAssetsLibrarys.h
//  LinCore
//
//  Created by lin on 1/29/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary(LinCore)

-(void)writeImageToSavedPhotosAlbums:(NSArray*)images albumName:(NSString*)albumName metadata:(NSDictionary*)metadata completion:(void(^)(NSArray * urls,NSArray * errors))completion;

-(void)writeImageToSavedPhotosAlbum:(CGImageRef)image albumName:(NSString*)albumName metadata:(NSDictionary*)metadata completion:(void(^)(NSURL * url,NSError * error))completion;

@end
