//
//  FormSegueDescriptor.h
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import "FormSegueDescriptor.h"
#import "FormSegueCell.h"

@implementation FormSegueDescriptor

-(id)initWithTitle:(NSString *)title segue:(NSString *)segue{
    self = [super initWithTitle:title name:@""];
    if (self) {
        self->_segue = segue;
    }
    return self;
}

-(Class)formBaseCellClassFromRowDescriptor{
    return [FormSegueCell class];
}

@end
