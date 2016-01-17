//
//  UIViewController+UIViewControllers.m
//  LinCore
//
//  Created by lin on 2/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "UIViewControllers.h"
#import "LinUtil/util.h"

@implementation UIViewController (UIViewControllers)


-(void)performUnwindSegueWithAction:(NSString*)action sender:(id)sender{
//    - (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL select = @selector(viewControllerForUnwindAction:fromViewController:withSender:);
#pragma clang diagnostic pop
    UIViewController * parent = self.parentViewController;
    while (parent != nil) {
        if ([parent respondsToSelector:select]) {
//            NSLog(@"ok.");
//            NSMutableArray * objs = @[action,self,sender];
            NSMutableArray * objs = [[NSMutableArray alloc] init];
            if (action == nil) {
                [objs addObject:@""];
            }else{
                [objs addObject:action];
            }
            [objs addObject:self];
            if (sender == nil) {
                [objs addObject:[NSNull null]];
            }else{
                [objs addObject:sender];
            }
            
            id obj = [parent performSelector:select withObjects:objs];
           
            if ([obj isKindOfClass:[UIViewController class]]) {
                [[self navigationController] presentViewController:((UIViewController *)obj) animated:true completion:nil];
            
            break;
            }
        }
        parent = parent.parentViewController;
    }
//    self performSelector:(SEL) withObject:(id) withObject:(id)
//    self per
}
@end
