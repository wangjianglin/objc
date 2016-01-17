//
//  FormGeneralRowDescriptor.h
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormRowDescriptor.h"

typedef NS_ENUM(NSInteger,FormRowType){
//    FormRowTypeButton,
    FormRowTypeBooleanSwitch,
    FormRowTypeBooleanCheck,
    FormRowTypeSegmentedControl,
    FormRowTypePicker,
    FormRowTypeDate,
    FormRowTypeTime,
    FormRowTypeDateAndTime,
    FormRowTypeMultipleSelector
};

@interface FormGeneralRowDescriptor : FormRowDescriptor

@property Class cellClass;
@property(readonly) FormRowType rowType;
@property NSDateFormatter * dateFormatter;

-(id)initWithTitle:(NSString*)title name:(NSString*)name rowType:(FormRowType)rowType value:(NSObject*)value;

-(id)initWithTitle:(NSString*)title name:(NSString*)name rowType:(FormRowType)rowType;

@end

