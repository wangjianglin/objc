//
//  UIButtons.h
//  LinCore
//
//  Created by lin on 8/19/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface UIButton(LinCore)
@interface LinButton : UIButton

-(void)setBackgroundColor:(UIColor*)color forState:(UIControlState)state;
@end
