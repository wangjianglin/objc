//
//  AlertView.swift
//  LinControls
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AlertView.h"
#import "LinUtil/util.h"


//
//@protocol UIAlertViewDelegate <NSObject>
//@optional
@interface UIAlertViewDelegateImpl : DelegateAction<UIAlertViewDelegate>{
    void(^_alertViewCancelAction)(UIAlertView*alertView);
    void(^_clickedButtonAtIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);
    void(^_willPresentAlertViewAction)(UIAlertView * alertView);
    void(^_didPresentAlertViewAction)(UIAlertView * alertView);
    void(^_willDismissWithButtonIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);
    void(^_didDismissWithButtonIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);
    BOOL(^_alertViewShouldEnableFirstOtherButtonAction)(UIAlertView *alertView);
}

//
//// Called when a button is clicked. The view will be automatically dismissed after this call returns
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@property void(^clickedButtonAtIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);
//
//// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
//// If not defined in the delegate, we simulate a click in the cancel button
//- (void)alertViewCancel:(UIAlertView *)alertView;
@property void(^alertViewCancelAction)(UIAlertView*alertView) ;
//
//- (void)willPresentAlertView:(UIAlertView *)alertView;  // before animation and showing view
@property void(^willPresentAlertViewAction)(UIAlertView * alertView);
//- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
@property void(^didPresentAlertViewAction)(UIAlertView * alertView);
//
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
@property void(^willDismissWithButtonIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
@property void(^didDismissWithButtonIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);
//
//// Called after edits in any of the default fields added by the style
//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;
@property BOOL(^alertViewShouldEnableFirstOtherButtonAction)(UIAlertView *alertView);
//
@end

@implementation UIAlertViewDelegateImpl

-(void (^)(UIAlertView *alertView))alertViewCancelAction{
    return _alertViewCancelAction;
}
-(void)setAlertViewCancelAction:(void (^)(UIAlertView *alertView))alertViewCancelAction{
    _alertViewCancelAction = alertViewCancelAction;
}

-(void (^)(UIAlertView * alertView, NSInteger buttonIndex))clickedButtonAtIndexAction{
    return _clickedButtonAtIndexAction;
}

-(void)setClickedButtonAtIndexAction:(void (^)(UIAlertView * alertView, NSInteger buttonIndex))clickedButtonAtIndexAction{
    _clickedButtonAtIndexAction = clickedButtonAtIndexAction;
}

-(void (^)(UIAlertView *))willPresentAlertViewAction{
    return _willPresentAlertViewAction;
}

-(void)setWillPresentAlertViewAction:(void (^)(UIAlertView *))willPresentAlertViewAction{
    _willPresentAlertViewAction = willPresentAlertViewAction;
}

-(void (^)(UIAlertView *))didPresentAlertViewAction{
    return _didPresentAlertViewAction;
}
-(void)setDidPresentAlertViewAction:(void (^)(UIAlertView *))didPresentAlertViewAction{
    _didPresentAlertViewAction = didPresentAlertViewAction;
}

-(void (^)(UIAlertView * alertView,NSInteger buttonIndex))willDismissWithButtonIndexAction{
    return _willDismissWithButtonIndexAction;
}
-(void)setWillDismissWithButtonIndexAction:(void (^)(UIAlertView * alertView,NSInteger buttonIndex))willDismissWithButtonIndexAction{
    _willDismissWithButtonIndexAction = willDismissWithButtonIndexAction;
}

-(void (^)(UIAlertView * alertView,NSInteger buttonIndex))didDismissWithButtonIndexAction{
    return _didDismissWithButtonIndexAction;
}
-(void)setDidDismissWithButtonIndexAction:(void (^)(UIAlertView * alertView,NSInteger buttonIndex))willDismissWithButtonIndexAction{
    _didDismissWithButtonIndexAction = willDismissWithButtonIndexAction;
}

-(BOOL (^)(UIAlertView *))alertViewShouldEnableFirstOtherButtonAction{
    return _alertViewShouldEnableFirstOtherButtonAction;
}
-(void)setAlertViewShouldEnableFirstOtherButtonAction:(BOOL (^)(UIAlertView *))alertViewShouldEnableFirstOtherButtonAction{
    _alertViewShouldEnableFirstOtherButtonAction = alertViewShouldEnableFirstOtherButtonAction;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_clickedButtonAtIndexAction != nil) {
        _clickedButtonAtIndexAction(alertView,buttonIndex);
    }
}

//
//// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
//// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView{
    if (_alertViewCancelAction != nil) {
        _alertViewCancelAction(alertView);
    }
}

//
- (void)willPresentAlertView:(UIAlertView *)alertView{  // before animation and showing view
    if(_willPresentAlertViewAction != nil){
        _willPresentAlertViewAction(alertView);
    }
}
- (void)didPresentAlertView:(UIAlertView *)alertView{ // after animation
    if (_didPresentAlertViewAction) {
        _didPresentAlertViewAction(alertView);
    }
}
//
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{ // before animation and hiding view
    if (_willDismissWithButtonIndexAction) {
        _willDismissWithButtonIndexAction(alertView,buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{  // after animation
    if (_didDismissWithButtonIndexAction) {
        _didDismissWithButtonIndexAction(alertView,buttonIndex);
    }
}
//
//// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if (_alertViewShouldEnableFirstOtherButtonAction != nil) {
        return _alertViewShouldEnableFirstOtherButtonAction(alertView);
    }
    return TRUE;
}

@end


@implementation AlertView

+(void)show:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

+(void)show:(NSString *)titie message:(NSString *)message buttonTitle:(NSString *)buttonTitle{
    [[[UIAlertView alloc] initWithTitle:titie message:message delegate:buttonTitle cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}
@end

@implementation UIAlertView(LinCore)

-(UIAlertViewDelegateImpl*)delegateAction{
    id action = self.delegate;
    if ([action isKindOfClass:[UIAlertViewDelegateImpl class]]) {
        return action;
    }
    UIAlertViewDelegateImpl * delegateA = [[UIAlertViewDelegateImpl alloc] init];
    delegateA.withObjectSameLifecycle = self;
    self.delegate = delegateA;
    return delegateA;
}

-(void (^)(UIAlertView *alertView))alertViewCancelAction{
    return [self delegateAction].alertViewCancelAction;
}
-(void)setAlertViewCancelAction:(void (^)(UIAlertView *alertView))alertViewCancelAction{
    [self delegateAction].alertViewCancelAction = alertViewCancelAction;
}

-(void (^)(UIAlertView * alertView, NSInteger buttonIndex))clickedButtonAtIndexAction{
    return [self delegateAction].clickedButtonAtIndexAction;
}

-(void)setClickedButtonAtIndexAction:(void (^)(UIAlertView * alertView, NSInteger buttonIndex))clickedButtonAtIndexAction{
    [self delegateAction].clickedButtonAtIndexAction = clickedButtonAtIndexAction;
}

-(void (^)(UIAlertView *))willPresentAlertViewAction{
    return [self delegateAction].willPresentAlertViewAction;
}

-(void)setWillPresentAlertViewAction:(void (^)(UIAlertView *))willPresentAlertViewAction{
    [self delegateAction].willPresentAlertViewAction = willPresentAlertViewAction;
}

-(void (^)(UIAlertView *))didPresentAlertViewAction{
    return [self delegateAction].didPresentAlertViewAction;
}
-(void)setDidPresentAlertViewAction:(void (^)(UIAlertView *))didPresentAlertViewAction{
    [self delegateAction].didPresentAlertViewAction = didPresentAlertViewAction;
}

-(void (^)(UIAlertView * alertView,NSInteger buttonIndex))willDismissWithButtonIndexAction{
    return [self delegateAction].willDismissWithButtonIndexAction;
}
-(void)setWillDismissWithButtonIndexAction:(void (^)(UIAlertView * alertView,NSInteger buttonIndex))willDismissWithButtonIndexAction{
    [self delegateAction].willDismissWithButtonIndexAction = willDismissWithButtonIndexAction;
}

-(void (^)(UIAlertView * alertView,NSInteger buttonIndex))didDismissWithButtonIndexAction{
    return [self delegateAction].didDismissWithButtonIndexAction;
}
-(void)setDidDismissWithButtonIndexAction:(void (^)(UIAlertView * alertView,NSInteger buttonIndex))willDismissWithButtonIndexAction{
    [self delegateAction].didDismissWithButtonIndexAction = willDismissWithButtonIndexAction;
}

-(BOOL (^)(UIAlertView *))alertViewShouldEnableFirstOtherButtonAction{
    return [self delegateAction].alertViewShouldEnableFirstOtherButtonAction;
}
-(void)setAlertViewShouldEnableFirstOtherButtonAction:(BOOL (^)(UIAlertView *))alertViewShouldEnableFirstOtherButtonAction{
    [self delegateAction].alertViewShouldEnableFirstOtherButtonAction = alertViewShouldEnableFirstOtherButtonAction;
}


@end
