//
//  FormButtonCell.m
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FormButtonCell.h"
#import "FormButtonDescriptor.h"


@implementation FormButtonCell

+(void)formViewController:(FormViewController *)formViewController didSelectRow:(FormBaseCell *)didSelectRow{
    FormButtonDescriptor * cell = (FormButtonDescriptor*)didSelectRow.rowDescriptor;
    if (cell != nil && cell.click != nil) {
        cell.click();
    }
}

@end

