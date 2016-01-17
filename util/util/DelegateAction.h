//
//  DeleteAction.swift
//  LinCore
//
//  Created by lin on 1/21/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelegateAction : NSObject

@property(nonatomic,assign) NSObject * withObjectSameLifecycle;

-(void)actionForObjectExist:(void (^)())action;
//@property (nonatomic,assign) NSObject * sameLifecycle;
@end


@interface EventDelegateAction : DelegateAction

-(id)initWithAction:(void(^)(NSObject*))action;
-(void)action:(NSObject*)sender;
@end

