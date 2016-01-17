////
////  UIView.swift
////  LinCore
////
////  Created by lin on 1/18/15.
////  Copyright (c) 2015 lin. All rights reserved.
////
//

#import "UIViews.h"

//
//extension UIView{
//    
//    //    (view2?.convertRect(CGRectMake(0, 0, 0, 0), toView: self.view)
//    public func contentRect()->CGRect{
//        return self.contentRectImpl(self);
//    }
//    private func contentRectImpl(view:UIView)->CGRect{
//        var rect = CGRectMake(0, 0, 0, 0);
//        
//        for item in self.subviews {
//            
//            if let item = item as? UIView {
//                
//                var subRect:CGRect!;
//                
//                if let sv = item as? UIScrollView {
//                    subRect = sv.bounds;
//                }else{
//                    subRect = item.contentRect();
//                }
//                var itemRect = item.bounds;
//                var r = self.mergeRect(subRect,rect2:itemRect);
//                var r2 = item.convertRect(r, toView: view)
//                rect = self.mergeRect(r2, rect2: rect);
//            }
//        }
//        
//        return rect;
//    }
//    
//    private func mergeRect(rect1:CGRect,rect2:CGRect)->CGRect{
//        var result = CGRectMake(0, 0, 0, 0);
//        result.origin.x = rect1.origin.x > rect2.origin.x ? rect2.origin.x : rect1.origin.x;
//        
//        result.origin.y = rect1.origin.y > rect2.origin.y ? rect2.origin.y : rect1.origin.y;
//        
//        var maxX = rect2.width + rect2.origin.x;
//        if maxX < rect1.width + rect1.origin.x {
//            maxX = rect1.width + rect1.origin.x
//        }
//        
//        result.size.width = maxX - result.origin.x;
//        
//        var maxY = rect2.height + rect2.origin.y;
//        if maxY < rect1.height + rect1.origin.y {
//            maxY = rect1.height + rect1.origin.y
//        }
//        
//        result.size.height = maxY - result.origin.y;
//        
//        return result;
//    }
//}

@implementation UIView(LinUtil)

+(UIViewController*)getRootViewController{
    return [UIView rootViewControllerImpl];
}
-(UIViewController*)rootViewController{
    return [UIView rootViewControllerImpl];
}

+(UIViewController*)rootViewControllerImpl{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
    
}
-(UIViewController*)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
