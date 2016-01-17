//
//  AutoResetEvent.h
//  LinUtil
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoResetEvent : NSObject

-(id)initWithIsSet:(BOOL)isSet;
//public init(isSet:Bool = false){
//    self.isSet = isSet;
//    self.lock = NSCondition();
//}
//
-(void)set;
//public func set(){
//    lock.lock();
//    //timeToDoWork++;
//    self.isSet = true;
//    lock.signal();
//    lock.unlock();
//}
//
//private var canMainThread:Int = 1;
//
-(BOOL)canEnterMainThread;
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
//
-(void)waitOne;
//public func waitOne(){
//    
//    
//    lock.lock();
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
-(void)reset;
//public func reset(){
//    lock.lock();
//    isSet = false;
//    lock.signal();
//    lock.unlock();
//}
@end
