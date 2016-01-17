//
//  Buttons.swift
//  LinCore
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Controls.h"
#import "LinUtil/util.h"

@implementation UIControl(Actions)


-(void)addActionForEvent:(UIControlEvents)event action:(void(^)(NSObject*))action{
    
    EventDelegateAction * delegateAction = [[EventDelegateAction alloc] initWithAction:action];
    delegateAction.withObjectSameLifecycle = self;
    
    [self addTarget:delegateAction action:@selector(action:) forControlEvents:event];
    
}

@end


