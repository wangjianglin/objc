//
//  WeiXinPlugin.h
//  buyers
//
//  Created by lin on 4/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinWebPlugin.h"

@interface WeiXinPlugin : LinWebPlugin


-(Json*)share:(Json*)args;

//-(Json*)shareLink:(Json*)args;
//
//-(Json*)shareText:(Json*)args;
@end
