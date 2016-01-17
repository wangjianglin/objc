//
//  FormDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormSectionDescriptor.h"

@interface FormDescriptor : NSObject


@property NSString * title;

@property NSArray * sections;

-(void)addSection:(FormSectionDescriptor*)section;

-(void)removeSection:(FormSectionDescriptor*)section;

-(NSDictionary*)formValues;

@end


