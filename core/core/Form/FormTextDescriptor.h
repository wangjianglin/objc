//
//  FormTextDescriptor.h
//  LinCore
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormRowDescriptor.h"


typedef NS_ENUM(NSInteger,TextType){
    Text,Name,Phone,URL,Email,Password
};

@interface FormTextDescriptor : FormRowDescriptor

@property TextType textType;

-(id)initWithTitle:(NSString*)title name:(NSString*)name textType:(TextType)textType value:(NSObject*)value;
-(id)initWithTitle:(NSString*)title name:(NSString*)name textType:(TextType)textType;


@end
