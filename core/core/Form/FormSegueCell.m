//
//  SegueCell.m
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import "FormSegueCell.h"
#import "FormSegueDescriptor.h"

@implementation FormSegueCell



-(void)configure{
    [super configure];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


+(void)formViewController:(FormViewController *)formViewController didSelectRow:(FormBaseCell *)didSelectRow{
    FormSegueDescriptor * segue = (FormSegueDescriptor*)didSelectRow.rowDescriptor;
    [formViewController performSegueWithIdentifier:segue.segue sender:nil];
}

@end
