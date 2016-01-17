//
//  FormRowDescriptor.m
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import "FormRowDescriptor.h"
#import "FormBaseCell.h"


@interface FormRowDescriptor (){
    @private
    void (^_valueChanged)(NSObject * newValue, NSObject * oldValue);
    TitleFormatter _titleFormatter;
    NSObject * _value;
}

@end

@implementation FormRowDescriptor

-(void (^)(NSObject * newValue, NSObject * oldValue))valueChanged{
    return _valueChanged;
}
-(void)setValueChanged:(void (^)(NSObject * newValue, NSObject * oldValue))valueChanged{
    _valueChanged = valueChanged;
}

-(TitleFormatter)titleFormatter{
    return _titleFormatter;
}

-(void)setTitleFormatter:(TitleFormatter)titleFormatter{
    _titleFormatter = titleFormatter;
}

-(NSObject *)value{
    return _value;
}
-(void)setValue:(NSObject *)value{
    if (_valueChanged != nil) {
        NSObject * oldValue = _value;
        _value = value;
        _valueChanged(value,oldValue);
    }else{
        _value = value;
    }
}

-(id)initWithTitle:(NSString *)title name:(NSString *)name value:(NSObject *)value{
    self = [super init];
    if (self) {
        self.name = name;
        self.title = title;
        _value = value;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title name:(NSString *)name{
    return [self initWithTitle:title name:name value:nil];
}


-(NSString *)titleForOptionValue:(NSObject *)optionValue{
    if (_titleFormatter != nil) {
        return _titleFormatter(optionValue);
    }
    return [[NSString alloc] initWithFormat:@"%@",optionValue];
}

-(Class)formBaseCellClassFromRowDescriptor{
    return [FormBaseCell class];
}

@end


