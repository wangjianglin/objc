//
//  HZAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZLocation.h"

typedef enum {
    HZAreaPickerWithStateAndCity,
    HZAreaPickerWithStateAndCityAndDistrict
} HZAreaPickerStyle;

@class HZAreaPickerView;

//@protocol HZAreaPickerDelegate <NSObject>
//
//@optional
//- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;
//
//@end

@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;
@property (nonatomic) HZAreaPickerStyle pickerStyle;

//- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id <HZAreaPickerDelegate>)delegate;
- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle data:(NSArray *)data;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end

//@interface HZAreaPickerView()
//-(void)setDelegateAction:(void(^)(HZLocation *))action;
//@end
