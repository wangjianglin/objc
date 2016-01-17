//
//  FormSegueDescriptor.h
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FormRowDescriptor.h"

@interface FormSegueDescriptor:FormRowDescriptor

@property(readonly) NSString * segue;

-initWithTitle:(NSString*)title segue:(NSString*)segue;

@end
