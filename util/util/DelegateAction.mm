//
//  DeleteAction.swift
//  LinCore
//
//  Created by lin on 1/21/15.
//  Copyright (c) 2015 lin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DelegateAction.h"


NSMutableArray * delegateActionItems;
NSLock * lock;

@interface DelegateAction (){
    @private
    BOOL _isWithObjectSameLifecycle;
    __weak NSObject * _withObjectSameLifecycle;
}


@end

dispatch_once_t DelegateActionThreadPredicate_dispatch_once_t = 0;

@implementation DelegateAction

+(void)resetObj{
    if ([delegateActionItems count] < 1) {
        return;
    }
    [lock lock];
    if (delegateActionItems.count > 0) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (DelegateAction * item in delegateActionItems) {
            if (item.withObjectSameLifecycle == nil) {
                [array addObject:item];
            }
        }
        [delegateActionItems removeObjectsInArray:array];

    }
    [lock unlock];
}

-(NSObject *)withObjectSameLifecycle{
    return self->_withObjectSameLifecycle;
}

-(void)setWithObjectSameLifecycle:(NSObject *)withObjectSameLifecycle{
    self->_withObjectSameLifecycle = withObjectSameLifecycle;
    if (withObjectSameLifecycle != nil) {
        if (_isWithObjectSameLifecycle == false) {
            [lock lock];
            [delegateActionItems addObject:self];
            [lock unlock];
        }
        _isWithObjectSameLifecycle = true;
    }else{
        _isWithObjectSameLifecycle = false;
    }
}

-(id)initWithThreadAction:(void(^)(NSObject*))threadAction{
    return [super init];
}

-(id)init{
    self = [super init];
    if (self) {
        dispatch_once(&DelegateActionThreadPredicate_dispatch_once_t,^{
        
            EventDelegateAction * threadAction = [[EventDelegateAction alloc] initWithThreadAction:^(NSObject * obj) {
                while (TRUE) {
                    [DelegateAction resetObj];
                    [NSThread sleepForTimeInterval:2];
                }
            }];
            
            NSThread * thread = [[NSThread alloc] initWithTarget:threadAction selector:@selector(action:) object:nil];
            thread.name = @"delegate action thread";
            [thread start];
            
        });
    }
    return self;
}

-(void)actionForObjectExist:(void (^)())action{
    if (action == nil) {
        return;
    }
    NSObject * tmp = self.withObjectSameLifecycle;
    if (_isWithObjectSameLifecycle == false || tmp != nil) {
        action();
    }
}
@end


@interface EventDelegateAction (){
    @private
    void (^delegateAction)(NSObject*);
}

@end

@implementation EventDelegateAction

-(id)initWithThreadAction:(void (^)(NSObject*))threadAction{
    self = [super initWithThreadAction:threadAction];
    
    if (self) {
        self->delegateAction = threadAction;
    }
    
    return self;
}

-(id)initWithAction:(void (^)(NSObject*))action{
    self = [super init];
    
    if (self) {
        self->delegateAction = action;
    }
    
    return self;
}

-(void)action:(NSObject *)sender{
    if (delegateAction == nil) {
        return;
    }
    [self actionForObjectExist:^{
        delegateAction(sender);
    }];
}

@end

class DelegateActionThreadPredicate_dispatch_once_tInit_Delega{
public:
    DelegateActionThreadPredicate_dispatch_once_tInit_Delega(){
        delegateActionItems = [[NSMutableArray alloc] init];
    }
};
DelegateActionThreadPredicate_dispatch_once_tInit_Delega __DelegateActionThreadPredicate_dispatch_once_tInit_Delega;