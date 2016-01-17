//
//  FormViewController.h
//  SwiftForms
//
//  Created by Miguel Angel Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FormDescriptor.h"
#import "FormRowDescriptor.h"


@class FormViewController;

@protocol FormViewControllerDelegate

@optional -(void)formViewController:(FormViewController*)controller didSelectRowDescriptor:(FormRowDescriptor*)didSelectRowDescriptor;

@end


@interface FormViewController : UITableViewController


@property FormDescriptor * form;

@property(assign) id<FormViewControllerDelegate> delegate;

-(id)init;

-(id)initWithForm:(FormDescriptor*)form;


@end


