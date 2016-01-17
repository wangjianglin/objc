//
//  TextFields.m
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import "TextFields.h"
#import "LinUtil/util.h"

@interface UITextFieldLinCoreDelegateAction : DelegateAction{
    @private
    UITextField * _target;
}

-initWithTarget:(UITextField*)target;
-(void)textFieldDidBeginEditing:(NSNotification *) notification;
-(void) keyboardDidShow:(NSNotification *) notification;
-(void)keyboardWillHide:(NSNotification*)notification;
-(void)doneButtonIsClicked:(NSObject*)sender;
-(void)textFieldDidEndEditing:(NSNotification*)notification;
-(void)deviceOrientationDidChangeNotification:(NSNotification*)notification;

@end

@interface UITextFieldsLinCoreDelegateActionImpl : DelegateAction<UITextFieldDelegate>{
    //UITextFieldDelegate
    @package
    BOOL (^_textFieldShouldBeginEditing)(UITextField *);
}

@end

@implementation UITextFieldsLinCoreDelegateActionImpl
//
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    if (_textFieldShouldBeginEditing != nil) {
        return _textFieldShouldBeginEditing(textField);
    }
    return TRUE;
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.


@end


@implementation UITextField(LinCore)

-(void)setup{
    NSNotificationCenter * defaultConter = [NSNotificationCenter defaultCenter];
    UITextFieldLinCoreDelegateAction * delegateAction = [[UITextFieldLinCoreDelegateAction alloc] initWithTarget:self];
    
    [defaultConter addObserver:delegateAction selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [defaultConter addObserver:delegateAction selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    delegateAction.withObjectSameLifecycle = self;
    
//    self.delegate
}

-(UITextFieldsLinCoreDelegateActionImpl*)delegateAction{
    id action = self.delegate;
    if ([action isKindOfClass:[UITextFieldsLinCoreDelegateActionImpl class]]) {
        return action;
    }
    UITextFieldsLinCoreDelegateActionImpl * delegateA = [[UITextFieldsLinCoreDelegateActionImpl alloc] init];
    delegateA.withObjectSameLifecycle = self;
    self.delegate = delegateA;
    return delegateA;
}

//-(void (^)(UITextView *))textViewDidChange{
//    return [self delegateAction]->_textViewDidChange;
//}
//
//-(void)setTextViewDidChange:(void (^)(UITextView *))textViewDidChange{
//    [self delegateAction]->_textViewDidChange = textViewDidChange;
//}

-(BOOL (^)(UITextField *))textFieldShouldBeginEditing{
    return [self delegateAction]->_textFieldShouldBeginEditing;
}

-(void)setTextFieldShouldBeginEditing:(BOOL (^)(UITextField *))textFieldShouldBeginEditing{
    [self delegateAction]->_textFieldShouldBeginEditing = textFieldShouldBeginEditing;
}

@end

@implementation UITextFieldLinCoreDelegateAction

-(id)initWithTarget:(UITextField *)target{
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}
-(UIToolbar*)getToolbar{
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _target.window.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem * doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonIsClicked:)];

    UIBarButtonItem * spaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[spaceBarButton,doneBarButton];
    
    return toolbar;
}

-(void)textFieldDidBeginEditing:(NSNotification *) notification{

    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];

    _target.inputAccessoryView = [self getToolbar];
    [_target becomeFirstResponder];
}
//    
-(void) keyboardDidShow:(NSNotification *) notification{

    NSDictionary * info = notification.userInfo;
    NSValue * aValue = (NSValue*)info[UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboarSize = [aValue CGRectValue].size;
    [self scrollToTextView:keyboarSize];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    [_target resignFirstResponder];
    [self removeObservers];
}
-(void)deviceOrientationDidChangeNotification:(NSNotification*)notification{
//    [_target resignFirstResponder];
//    [self removeObservers];
}

-(void)doneButtonIsClicked:(NSObject*)sender{
    [self hiddenWindow];
}

-(void)removeObservers{
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)textFieldDidEndEditing:(NSNotification*)notification{
    [self removeObservers];
    [self hiddenWindow];
}

-(void)hiddenWindow{

    CGRect frame = _target.window.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _target.window.frame = frame;
    [_target resignFirstResponder];
}

-(void)scrollToTextView:(CGSize)keyboardSize{

    CGRect frame = _target.window.frame;
    CGRect rect = _target.bounds;
    rect.origin = [_target convertPoint:rect.origin toView:_target.window];
    
    CGRect aRect = _target.window.bounds;
    
    if (aRect.origin.y + aRect.size.height - rect.origin.y < keyboardSize.height + 40) {
        frame.origin.y = aRect.origin.y + aRect.size.height - rect.origin.y - keyboardSize.height - 40 - 40;
    }
    _target.window.frame = frame;

}


@end