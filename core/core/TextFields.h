//
//  TextFields.h
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UITextField(LinCore)

/**
 * setup
 */
-(void)setup;


//@property void(^textFieldDidChange)(UITextField *textView);
@property BOOL(^textFieldShouldBeginEditing)(UITextField *textView);
//@property BOOL(^textViewShouldEndEditing)(UITextView *textView);
//@property void(^textViewDidBeginEditing)(UITextView *textView);
//@property void(^textViewDidEndEditing)(UITextView *textView);
//@property BOOL(^textView)(UITextView *textView,NSRange range,NSString *text);

@end
