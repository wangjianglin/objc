//
//  Stack.h
//  LinUtil
//
//  Created by lin on 8/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject
- (void)push:(id)anObject;
- (id)pop;
- (void)clear;
@property (nonatomic, readonly) int count;
@end
