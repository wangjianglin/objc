//
//  FormSectionDescriptor.h
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormRowDescriptor.h"

@interface FormSectionDescriptor : NSObject

@property NSString * headerTitle;
@property NSString * footerTitle;

@property NSArray * rows;
-(void)addRow:(FormRowDescriptor*)row;
-(void)removeRow:(FormRowDescriptor*)row;

@end

