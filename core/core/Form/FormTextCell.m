//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//


#import "FormTextCell.h"

@interface FormTextCell (){
    @private
    UILabel * valueLabel;
    
}

@end

@implementation FormTextCell


-(void)configure{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    valueLabel = [[UILabel alloc] init];
    valueLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:valueLabel];
    valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

+(void)formViewController:(FormViewController *)formViewController didSelectRow:(FormBaseCell *)didSelectRow{
    
}

-(void)update{

    self.textLabel.text = self.rowDescriptor.title;
    valueLabel.text = [[NSString alloc] initWithFormat:@"%@",self.rowDescriptor.value];
    
    if (self.rowDescriptor.enabled) {
        valueLabel.frame = CGRectMake(self.textLabel.bounds.origin.x + self.textLabel.bounds.size.width + 5, 0, self.bounds.size.width - self.textLabel.bounds.size.width - 30, self.bounds.size.height);
    }else{
        valueLabel.frame = CGRectMake(self.textLabel.bounds.origin.x + self.textLabel.bounds.size.width + 5, 0, self.bounds.size.width - self.textLabel.bounds.size.width - 10, self.bounds.size.height);
    }

}

@end

