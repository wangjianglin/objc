//
//  TextView.swift
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//



#import "TextViews.h"
#import "LinUtil/util.h"

@interface UITextViewLinCoreDelegateAction : DelegateAction{
@private
    UITextView * _target;
}

-initWithTarget:(UITextView*)target;
-(void)textFieldDidBeginEditing:(NSNotification *) notification;
-(void) keyboardDidShow:(NSNotification *) notification;
-(void)keyboardWillHide:(NSNotification*)notification;
-(void)doneButtonIsClicked:(NSObject*)sender;
-(void)textFieldDidEndEditing:(NSNotification*)notification;
-(void)deviceOrientationDidChangeNotification:(NSNotification*)notification;

@end

@interface UITextViewsLinCoreDelegateActionImple : DelegateAction<UITextViewDelegate>{
    @public
    void(^_textViewDidChange)(UITextView *textView);
    BOOL(^_textViewShouldBeginEditing)(UITextView *textView);
    BOOL(^_textViewShouldEndEditing)(UITextView *textView);
    void(^_textViewDidBeginEditing)(UITextView *textView);
    void(^_textViewDidEndEditing)(UITextView *textView);
    BOOL(^_textView)(UITextView *textView,NSRange range,NSString *text);
}

@end

@implementation UITextViewsLinCoreDelegateActionImple


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(_textViewShouldBeginEditing){
        return _textViewShouldBeginEditing(textView);
    }
    return TRUE;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(_textViewShouldEndEditing){
        return _textViewShouldEndEditing(textView);
    }
    return TRUE;
}
//
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(_textViewShouldBeginEditing){
        _textViewShouldBeginEditing(textView);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_textViewDidEndEditing) {
        _textViewDidEndEditing(textView);
    }
}
//
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(_textView){
        return _textView(textView,range,text);
    }
    return TRUE;
}
- (void)textViewDidChange:(UITextView *)textView{
    if(_textViewDidChange){
        _textViewDidChange(textView);
    }
}
//
//- (void)textViewDidChangeSelection:(UITextView *)textView;
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);


@end


@implementation UITextView(LinCore)


-(UITextViewsLinCoreDelegateActionImple*)delegateAction{
    id action = self.delegate;
    if ([action isKindOfClass:[UITextViewsLinCoreDelegateActionImple class]]) {
        return action;
    }
    UITextViewsLinCoreDelegateActionImple * delegateA = [[UITextViewsLinCoreDelegateActionImple alloc] init];
    delegateA.withObjectSameLifecycle = self;
    self.delegate = delegateA;
    return delegateA;
}

-(void (^)(UITextView *))textViewDidChange{
    return [self delegateAction]->_textViewDidChange;
}

-(void)setTextViewDidChange:(void (^)(UITextView *))textViewDidChange{
    [self delegateAction]->_textViewDidChange = textViewDidChange;
}

-(BOOL (^)(UITextView *))textViewShouldBeginEditing{
    return [self delegateAction]->_textViewShouldBeginEditing;
}

-(void)setTextViewShouldBeginEditing:(BOOL (^)(UITextView *))textViewShouldBeginEditing{
    [self delegateAction]->_textViewShouldBeginEditing = textViewShouldBeginEditing;
}

-(BOOL (^)(UITextView *))textViewShouldEndEditing{
    return [self delegateAction]->_textViewShouldEndEditing;
}

-(void)setTextViewShouldEndEditing:(BOOL (^)(UITextView *))textViewShouldEndEditing{
    [self delegateAction]->_textViewShouldEndEditing = textViewShouldEndEditing;
}

-(void (^)(UITextView *))textViewDidBeginEditing{
    return [self delegateAction]->_textViewDidBeginEditing;
}

-(void)setTextViewDidBeginEditing:(void (^)(UITextView *))textViewDidBeginEditing{
    [self delegateAction]->_textViewDidBeginEditing = textViewDidBeginEditing;
}

-(void (^)(UITextView *))textViewDidEndEditing{
    return [self delegateAction]->_textViewDidEndEditing;
}

-(void)setTextViewDidEndEditing:(void (^)(UITextView *))textViewDidEndEditing{
    [self delegateAction]->_textViewDidEndEditing = textViewDidEndEditing;
}

-(BOOL (^)(UITextView *, NSRange, NSString *))textView{
    return [self delegateAction]->_textView;
}

-(void)setTextView:(BOOL (^)(UITextView *, NSRange, NSString *))textView{
    [self delegateAction]->_textView = textView;
}


-(void)setup{
    NSNotificationCenter * defaultConter = [NSNotificationCenter defaultCenter];
    UITextViewLinCoreDelegateAction * delegateAction = [[UITextViewLinCoreDelegateAction alloc] initWithTarget:self];
    
    [defaultConter addObserver:delegateAction selector:@selector(textFieldDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [defaultConter addObserver:delegateAction selector:@selector(textFieldDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    delegateAction.withObjectSameLifecycle = self;
}

@end

@implementation UITextViewLinCoreDelegateAction

-(id)initWithTarget:(UITextView *)target{
    self = [super init];
    if (self) {
        _target = target;
        [self setToolbar];
    }
    return self;
}

-(void)setToolbar{
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _target.window.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UIBarButtonItem * doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonIsClicked:)];

    UIBarButtonItem * spaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    toolbar.items = @[spaceBarButton,doneBarButton];
    _target.inputAccessoryView = toolbar;
}

-(void)textFieldDidBeginEditing:(NSNotification *) notification{

    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];

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

-(void)deviceOrientationDidChangeNotification:(NSNotification*)notification;{
    
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