//
//  FormSwitchCell.m
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import "FormSwitchCell.h"

@interface FormSwitchCell (){
    @private
    UISwitch * switchView;
}

@end

@implementation FormSwitchCell

-(void)configure{
    [super configure];
    self.selectionStyle = UITableViewCellAccessoryNone;
    switchView = [[UISwitch alloc] init];
    self.accessoryView = switchView;
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)update{
//    [super update];
    if (self.rowDescriptor.title != nil) {
        self.textLabel.text = self.rowDescriptor.title;
    }else{
        self.textLabel.text = @"";
    }
    switchView.enabled = self.rowDescriptor.enabled;
    if (self.rowDescriptor.value != nil) {
        switchView.on = [((NSNumber*)self.rowDescriptor.value) boolValue];
    }else{
        switchView.on = FALSE;
    }
}

-(void)valueChanged:(UISwitch*)sender{
    self.rowDescriptor.value = [[NSNumber alloc] initWithBool:switchView.on];
}

@end
