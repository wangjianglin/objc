//
//  FormGeneralRowDescriptor.m
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

//import UIKit
//
//
//public enum FormRowType {
//    case Button
//    case BooleanSwitch
//    case BooleanCheck
//    case SegmentedControl
//    case Picker
//    case Date
//    case Time
//    case DateAndTime
//    case MultipleSelector
////    case Custom
//}

#import "FormGeneralRowDescriptor.h"
#import "FormButtonCell.h"
#import "FormSwitchCell.h"

dispatch_once_t __FormGeneralRowDescriptor_onceDefaultCellClass = 0;
NSMutableDictionary * __FormGeneralRowDescriptor_defaultCellClasses = nil;

@implementation FormGeneralRowDescriptor

-(id)initWithTitle:(NSString *)title name:(NSString *)name rowType:(FormRowType)rowType value:(NSObject *)value{
    self = [super initWithTitle:title name:name value:value];
    if (self) {
        self->_rowType = rowType;
    }
    return self;
}
-(id)initWithTitle:(NSString *)title name:(NSString *)name rowType:(FormRowType)rowType{
    return [self initWithTitle:title name:name rowType:rowType value:nil];
}
//
+(NSString*)rowTypeToString:(FormRowType)rowType{
    switch (rowType) {
//        case FormRowTypeButton:
//            return @"FormRowTypeButton";
//            break;
        case FormRowTypeBooleanCheck:
            return @"FormRowTypeBooleanCheck";
        case FormRowTypeBooleanSwitch:
            return @"FormRowTypeBooleanSwitch";
        case FormRowTypeDate:
            return @"FormRowTypeDate";
        case FormRowTypeDateAndTime:
            return @"FormRowTypeDateAndTime";
        case FormRowTypeMultipleSelector:
            return @"FormRowTypeMultipleSelector";
        case FormRowTypePicker:
            return @"FormRowTypePicker";
        case FormRowTypeSegmentedControl:
            return @"FormRowTypeSegmentedControl";
        case FormRowTypeTime:
            return @"FormRowTypeSegmentedControl";
        default:
            return @"";
    }
}
//    private class func defaultCellClassForRowType(rowType: FormRowType) -> FormBaseCell.Type {
+(Class)defaultCellClassForRowType:(FormRowType)rowType{
//        dispatch_once(&Static.onceDefaultCellClass) {
////            Static.defaultCellClasses[FormRowType.Text] = FormTextFieldCell.self
////            Static.defaultCellClasses[FormRowType.Phone] = FormTextFieldCell.self
////            Static.defaultCellClasses[FormRowType.URL] = FormTextFieldCell.self
////            Static.defaultCellClasses[FormRowType.Email] = FormTextFieldCell.self
////            Static.defaultCellClasses[FormRowType.Password] = FormTextFieldCell.self
    dispatch_once(&__FormGeneralRowDescriptor_onceDefaultCellClass, ^{
        __FormGeneralRowDescriptor_defaultCellClasses = [[NSMutableDictionary alloc] init];
       
//            Static.defaultCellClasses[FormRowType.Button] = FormButtonCell.self
//        __FormGeneralRowDescriptor_defaultCellClasses[[self rowTypeToString:FormRowTypeButton]] = [FormButtonCell class];
//            Static.defaultCellClasses[FormRowType.BooleanSwitch] = FormSwitchCell.self
        __FormGeneralRowDescriptor_defaultCellClasses[[self rowTypeToString:FormRowTypeBooleanSwitch]] = [FormSwitchCell class];
//            Static.defaultCellClasses[FormRowType.BooleanCheck] = FormCheckCell.self
//            Static.defaultCellClasses[FormRowType.SegmentedControl] = FormSegmentedControlCell.self
//            Static.defaultCellClasses[FormRowType.Picker] = FormPickerCell.self
//            Static.defaultCellClasses[FormRowType.Date] = FormDateCell.self
//            Static.defaultCellClasses[FormRowType.Time] = FormDateCell.self
//            Static.defaultCellClasses[FormRowType.DateAndTime] = FormDateCell.self
//            Static.defaultCellClasses[FormRowType.MultipleSelector] = FormSelectorCell.self
//        }
    });
    return __FormGeneralRowDescriptor_defaultCellClasses[[self rowTypeToString:rowType]];

}

-(Class)formBaseCellClassFromRowDescriptor{
    Class formBaseCellClass;
    if (self.cellClass == nil) {
        formBaseCellClass = [FormGeneralRowDescriptor defaultCellClassForRowType:self.rowType];
    }else{
        formBaseCellClass = self.cellClass;
    }
    return formBaseCellClass;
}

@end
