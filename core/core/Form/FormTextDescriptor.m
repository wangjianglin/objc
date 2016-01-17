//
//  FormTextDescriptor.m
//  LinCore
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//



#import "FormTextDescriptor.h"
#import "FormTextCell.h"


@implementation FormTextDescriptor


-(id)initWithTitle:(NSString *)title name:(NSString *)name textType:(TextType)textType value:(NSObject *)value{
    self = [super initWithTitle:title name:name value:value];
    if (self) {
        self.textType = textType;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title name:(NSString *)name textType:(TextType)textType{
    return [self initWithTitle:title name:name textType:textType value:nil];
}

-(Class)formBaseCellClassFromRowDescriptor{
    return [FormTextCell class];
}

@end

