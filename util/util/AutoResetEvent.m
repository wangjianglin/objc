//
//  AutoResetEvent.m
//  LinUtil
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "AutoResetEvent.h"


@interface AutoResetEvent(){
    int canMainThread;
    BOOL isSet;
    NSCondition * lock;
}

@end
@implementation AutoResetEvent
-(id)initWithIsSet:(BOOL)_isSet{
    self = [super init];
    if (self) {
        self->canMainThread = 1;
        self->isSet = _isSet;
        self->lock = [[NSCondition alloc] init];
    }
    return self;
}

-(id)init{
    return [self initWithIsSet:FALSE];
}
//public init(isSet:Bool = false){
//    self.isSet = isSet;
//    self.lock = NSCondition();
//}
//
-(void)set{
    [lock lock];
    self->isSet = TRUE;
    [lock signal];
    [lock unlock];
}
//
//private var canMainThread:Int = 1;
//
-(BOOL)canEnterMainThread{
    BOOL can = FALSE;
    [lock lock];
    if (canMainThread == 1) {
        can = TRUE;
        canMainThread = 2;
    }
    [lock unlock];
    return can;
//public func canEnterMainThread()->Bool{
//    var can = false;
//    lock.lock();
//    if canMainThread == 1 {
//        can = true;
//        canMainThread = 2;
//    }
//    lock.unlock();
//    return can;
//}
    return YES;
}
-(void)waitOne{
//public func waitOne(){
//
//
//    lock.lock();
    [lock lock];
    if ([NSThread isMainThread]) {
        if (canMainThread == 2) {
            [lock unlock];
            return;
        }
        canMainThread = 0;
    }
    while (!self->isSet) {
        [lock wait];
    }
    [lock unlock];
//
//    if NSThread.isMainThread() {
//        if canMainThread == 2  {
//            lock.unlock();
//            return;
//        }
//
//        canMainThread = 0;
//    }
//    while(!self.isSet){
//        lock.wait();
//    }
//    lock.unlock();
//}
//
}
-(void)reset{
    [lock lock];
    self->isSet = FALSE;
    [lock signal];
    [lock unlock];
//public func reset(){
//    lock.lock();
//    isSet = false;
//    lock.signal();
//    lock.unlock();
//}
}
@end
