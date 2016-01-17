//
//  Queue.swift
//  LinCore
//
//  Created by lin on 1/27/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Queue.h"
#import "DelegateAction.h"

//public class AsynOperation : NSOperation{
// 
//    private var action:(()->());
//    private init(action:(()->())){
//        self.action = action;
//    }
//    public override func main() {
//        self.action();
//    }
//}


@interface AsynOperation : NSOperation{
    @private
    void (^_action)();
}

-(id)initWithAction:(void(^)())action;

@end


@implementation AsynOperation

-(id)initWithAction:(void (^)())action{
    self = [super init];
    if (self) {
        self->_action = action;
    }
    return self;
}

-(void)main{
    self->_action();
}

@end

//public class Queue{
//    
//    
//    private class var asynQueue:NSOperationQueue{
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:NSOperationQueue? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = NSOperationQueue();
//            YRSingleton.instance!.maxConcurrentOperationCount = 10;
//        })
//        return YRSingleton.instance!
//    }


@interface Queue (){
    @private
    NSOperationQueue * _queue;
}

@end

@implementation Queue

-(id)init{
    return [self initWithCount:5];
}
-(id)initWithCount:(uint)count{
    self  = [super init];
    if (self) {
        self->_queue = [[NSOperationQueue alloc] init];
        if (count < 1) {
            count = 1;
        }
        self->_queue.maxConcurrentOperationCount = count;
    }
    return self;
}


+(NSOperationQueue*)asynQueue{
    
    static dispatch_once_t asynQueue_predicate = 0;
    static NSOperationQueue * asynQueue_instance = nil;
  
    dispatch_once(&asynQueue_predicate,^{
        asynQueue_instance = [[NSOperationQueue alloc] init];
        asynQueue_instance.maxConcurrentOperationCount = 50;
    });
    
    
    return asynQueue_instance;
}

//    
//    
//    public class func mainQueue(action:(()->())){
//        dispatch_async(dispatch_get_main_queue(), {() in
//            action();
//        });
//    }
+(void)mainQueue:(void (^)())action{
    dispatch_async(dispatch_get_main_queue(), ^{
        action();
    });
}
//    public class func asynQueue(action:(()->())){
//        var operation = AsynOperation(action: action);
//        Queue.asynQueue.addOperation(operation);
//    }
+(void)asynQueue:(void (^)())action{
    AsynOperation * operation = [[AsynOperation alloc] initWithAction:action];
    [Queue.asynQueue addOperation:operation];
}

//-(void)asynQueueWithAction:(void (^)())action{
-(void)addAction:(void (^)())action{
    AsynOperation * operation = [[AsynOperation alloc] initWithAction:action];
    [self->_queue addOperation:operation];
}

//-(void)asynQueueWithOperation:(NSOperation*)operation{
-(void)addOperation:(NSOperation*)operation{
    if (operation != nil) {
        [self->_queue addOperation:operation];
    }
}
//    public class func asynThread(action:(()->())){
////        var operation = AsynOperation(action: action);
////        Queue.asynQueue.addOperation(operation);
////        init(target: AnyObject, selector: Selector, object argument: AnyObject?)
//        var delegate = EventDelegateAction(action:{(_:AnyObject) in
//            action();
//        });
//        var thread = NSThread(target:delegate,selector:"action:",object:nil);
//        thread.name = "upload log thread";
//        thread.start();
//    }
+(void)asynThread:(void (^)())action{
    EventDelegateAction * delegate = [[EventDelegateAction alloc] initWithAction:^(NSObject * sender){
        action();
    }];
    NSThread * thread = [[NSThread alloc] initWithTarget:delegate selector:@selector(action:) object:nil];
    [thread start];
}
//}

@end