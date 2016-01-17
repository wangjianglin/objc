//
//  TextView.h
//  LinCore
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextView(LinCore)

-(void)setup;


@property void(^textViewDidChange)(UITextView *textView);
@property BOOL(^textViewShouldBeginEditing)(UITextView *textView);
@property BOOL(^textViewShouldEndEditing)(UITextView *textView);
@property void(^textViewDidBeginEditing)(UITextView *textView);
@property void(^textViewDidEndEditing)(UITextView *textView);
@property BOOL(^textView)(UITextView *textView,NSRange range,NSString *text);
@end
