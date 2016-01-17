//
//  FormBaseCell.h
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormRowDescriptor.h"
#import "FormViewController.h"

@interface FormBaseCell : UITableViewCell


@property FormRowDescriptor * rowDescriptor;

-(void)configure;
-(void)update;
+(CGFloat)formRowCellHeight;
//public class func formViewController(formViewController: FormViewController, didSelectRow: FormBaseCell)
+(void)formViewController:(FormViewController*)formViewController didSelectRow:(FormBaseCell*)didSelectRow;

@end
