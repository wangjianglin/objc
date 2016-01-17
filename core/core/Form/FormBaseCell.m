//
//  FormBaseCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import "FormBaseCell.h"


@interface FormBaseCell(){
    @private
    FormRowDescriptor * _rowDescriptor;
    UILabel * valueLabel;
}

@end

@implementation FormBaseCell

-(FormRowDescriptor *)rowDescriptor{
    return _rowDescriptor;
}
-(void)setRowDescriptor:(FormRowDescriptor *)rowDescriptor{
    _rowDescriptor = rowDescriptor;
    if (rowDescriptor != nil && rowDescriptor.backgroundColor != nil) {
        self.backgroundColor = rowDescriptor.backgroundColor;
    }
    [self update];
}

-(void)configure{
    
    self.accessoryType = UITableViewCellAccessoryNone;
    
    valueLabel = [[UILabel alloc] init];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:valueLabel];
    valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

-(void)update{
    if (self.rowDescriptor.title != nil) {
        self.textLabel.text = self.rowDescriptor.title;
    }else{
        self.textLabel.text = @"";
    }
    if (self.rowDescriptor.value != nil) {
        valueLabel.text = [[NSString alloc] initWithFormat:@"%@",self.rowDescriptor.value];
    }else{
        valueLabel.text = @"";
    }
    [self.textLabel sizeToFit];
    if (self.accessoryType == UITableViewCellAccessoryNone) {
        valueLabel.frame = CGRectMake(self.textLabel.bounds.origin.x + self.textLabel.bounds.size.width + 5, 0, self.bounds.size.width - self.textLabel.bounds.size.width - 25, self.bounds.size.height);
    }else{
        valueLabel.frame = CGRectMake(self.textLabel.bounds.origin.x + self.textLabel.bounds.size.width + 5, 0, self.bounds.size.width - self.textLabel.bounds.size.width - 10, self.bounds.size.height);
    }
}

+(CGFloat)formRowCellHeight{
    return 44;
}

+(void)formViewController:(FormViewController *)formViewController didSelectRow:(FormBaseCell *)didSelectRow{
    
}
@end
