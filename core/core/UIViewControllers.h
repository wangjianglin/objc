//
//  UIViewController+UIViewControllers.h
//  LinCore
//
//  Created by lin on 2/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIViewController (UIViewControllers)



-(void)performUnwindSegueWithAction:(NSString*)action sender:(id)sender;
//performSegueWithIdentifier

//UIViewControllers
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
// This code will only compile on versions >= iOS 5.0
#endif
@end
