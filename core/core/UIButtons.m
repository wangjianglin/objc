//
//  UIButtons.m
//  LinCore
//
//  Created by lin on 8/19/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "UIButtons.h"
#import <objc/runtime.h>

@interface LinButton(){
    
}
@property UIColor * selectColor;

@property UIColor * disableColor;

@property UIColor * normalColor;

@property BOOL isListener;

@end
@implementation LinButton

//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
//        [self addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
////        self.enabled
//        //self
//        [self setBackgroundColor:nil];
//    }
//    return self;
//}

//[mTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
//处理属性改变事件
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    [self changeBackground];
//}

-(void)touchDown:(id)_{
    [self changeBackground:UIControlEventTouchDown];
    
}

-(void)touchUpInside:(id)_{
    [self changeBackground:UIControlEventTouchUpInside];
    
}

-(void)touchUpOutside:(id)_{
    [self changeBackground:UIControlEventTouchUpOutside];
    
}

-(void)changeBackground:(UIControlEvents)envnt{
    if (self.enabled == FALSE) {
        self.backgroundColor = self.disableColor;
        return;
    }
//    NSLog(@"state:%@",self.state);
    switch (envnt) {
        case UIControlEventTouchDown:
            self.backgroundColor = self.selectColor;
            break;
            
            
//        case UIControlStateDisabled:
//            self.backgroundColor = self.disableColor;
//            break;
            
            
//        case UIControlEventTouchUpOutside:
//        case UIControlStateHighlighted:
//            self.backgroundColor = self.normalColor;
//            break;
            
        default:
            self.backgroundColor = self.normalColor;
            break;
    }
//    switch (self.state) {
//        case UIControlStateSelected:
//            self.backgroundColor = self.selectColor;
//            break;
//            
//        default:
//            self.backgroundColor = self.normalColor;
//            break;
//    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self changeBackground:UIControlEventTouchDown];
}

//-(void)dealloc{
//    [self removeObserver:self forKeyPath:@"state"];
//    [self removeObserver:self forKeyPath:@"enabled"];
//}
-(void)setBackgroundColor:(UIColor *)color forState :(UIControlState)state{
//    objc_setAssociatedObject(self,@"stat_color",color,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.isListener == FALSE) {
//        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        //        [self addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
        [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        self.isListener = TRUE;
    }
    switch (state) {
        case UIControlStateSelected:
            self.selectColor = color;
            break;
            
            
        case UIControlStateDisabled:
            self.disableColor = color;
            break;
            
            
        case UIControlStateNormal:
            self.normalColor = color;
            break;
            
        default:
            break;
    }
    [self changeBackground:UIControlEventTouchUpInside];
}

//-(UIColor*)selectColor{
//    id v = objc_getAssociatedObject(self, @"background_select_color");
//    if ([v isKindOfClass:[UIColor class]]) {
//        return (UIColor*)v;
//    }
//    return nil;
//}
//-(void)setSelectColor:(UIColor*)color{
//    objc_setAssociatedObject(self,@"background_select_color",color,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(UIColor*)disableColor{
//    id v = objc_getAssociatedObject(self, @"background_disable_color");
//    if ([v isKindOfClass:[UIColor class]]) {
//        return (UIColor*)v;
//    }
//    return nil;
//}
//-(void)setDisableColor:(UIColor*)color{
//    objc_setAssociatedObject(self,@"background_disable_color",color,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(UIColor*)normalColor{
//    id v = objc_getAssociatedObject(self, @"background_normal_color");
//    if ([v isKindOfClass:[UIColor class]]) {
//        return (UIColor*)v;
//    }
//    return nil;
//}
//-(void)setNormalColor:(UIColor*)color{
//    objc_setAssociatedObject(self,@"background_normal_color",color,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//-(void)setIsListener:(BOOL)v{
//    objc_setAssociatedObject(self,@"is_set_listener",@(v),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//-(BOOL)isListener{
//    id v = objc_getAssociatedObject(self, @"is_set_listener");
//    if (v) {
//        return TRUE;
//    }
//    return  FALSE;
//}

@end
