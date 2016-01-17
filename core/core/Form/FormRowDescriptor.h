//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>


typedef NSString*(^TitleFormatter)(NSObject*);

@interface FormRowDescriptor : NSObject


@property NSString * title;

@property NSString * name;

@property NSObject * value;

@property void(^valueChanged)(NSObject * newValue,NSObject * oldValue) ;

@property TitleFormatter titleFormatter;

@property UITableViewCellStyle cellStyle;

@property BOOL enabled;
//    
//    //背影颜色
@property UIColor * backgroundColor;

-(id)initWithTitle:(NSString*)title name:(NSString*)name value:(NSObject*)value;
-(id)initWithTitle:(NSString*)title name:(NSString*)name;

-(NSString*)titleForOptionValue:(NSObject*)optionValue;

-(Class)formBaseCellClassFromRowDescriptor;

@end

