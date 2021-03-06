//
//  EICheckBox.m
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import "LinUtil/util.h"
#import "QCheckBox.h"

#define Q_CHECK_ICON_WH                    (15.0)
#define Q_ICON_TITLE_MARGIN                (5.0)

@implementation QCheckBox

//@synthesize delegate = _delegate;
@synthesize checked = _checked;
@synthesize userInfo = _userInfo;
@synthesize type = _type;

- (id)initWithDelegate:(id)delegate {
    self = [self init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        
        self.exclusiveTouch = YES;
        self.type = Check;
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setType:(QCheckBoxType)type{

    _type = type;
    if ( _type == Check ){
//#if iOS7
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/checkbox1_unchecked.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/checkbox1_checked.png"] forState:UIControlStateSelected];
//#else
//        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinControls.bundle/check/checkbox1_unchecked.png"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinControls.bundle/check/checkbox1_checked.png"] forState:UIControlStateSelected];
//#endif
    }else{
//#if iOS7
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/uncheck_icon.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/check_icon.png"] forState:UIControlStateSelected];
//#else
//        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinControls.bundle/check/uncheck_icon.png"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinControls.bundle/check/check_icon.png"] forState:UIControlStateSelected];
//#endif
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_CHECK_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

- (void)dealloc {
//    [_userInfo release];
//    _delegate = nil;
//    [super dealloc];
}

@end


@interface __QCheckBoxDelegateImpl3 : DelegateAction<QCheckBoxDelegate>{
@private
    void (^_didSelectedCheckBoxAction)(QCheckBox*);
}
@property void(^didSelectedCheckBoxAction)(QCheckBox*);
-(id)initWithObject:(NSObject*)object;

@end

@implementation __QCheckBoxDelegateImpl3


-(void (^)(QCheckBox *))didSelectedCheckBoxAction{
    return self->_didSelectedCheckBoxAction;
}

-(void)setDidSelectedCheckBoxAction:(void (^)(QCheckBox *))didSelectedCheckBoxAction{
    self->_didSelectedCheckBoxAction = didSelectedCheckBoxAction;
}

-(id)initWithObject:(NSObject *)object{
    self = [super init];
    if (self) {
        self.withObjectSameLifecycle = object;
    }
    return self;
}

-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    if (self->_didSelectedCheckBoxAction != nil) {
        self->_didSelectedCheckBoxAction(checkbox);
    }
}


@end



@implementation QCheckBox(Actions)

-(__QCheckBoxDelegateImpl3*)actionDelegate{
    
    __QCheckBoxDelegateImpl3 * delegate = nil;
    if ([self.delegate isKindOfClass:[__QCheckBoxDelegateImpl3 class]]){
        delegate = self.delegate;
    }else{
        delegate = [[__QCheckBoxDelegateImpl3 alloc] initWithObject:self];
        self.delegate = delegate;
    }
    return delegate;
}

-(void (^)(QCheckBox *))didSelectedCheckBoxAction{
    return self.actionDelegate.didSelectedCheckBoxAction;
}

-(void)setDidSelectedCheckBoxAction:(void (^)(QCheckBox *))didSelectedCheckBoxAction{
    self.actionDelegate.didSelectedCheckBoxAction = didSelectedCheckBoxAction;
}

@end