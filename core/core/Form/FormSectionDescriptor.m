//
//  FormSectionDescriptor.m
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import "FormSectionDescriptor.h"


@interface FormSectionDescriptor(){
    @private
    NSMutableArray * _rows;
}


@end
@implementation FormSectionDescriptor

-(instancetype)init{
    self = [super init];
    if (self) {
        _rows = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)rows{
    return _rows;
}
-(void)setRows:(NSArray *)rows{
    [_rows removeAllObjects];
    [_rows addObjectsFromArray:rows];
}

-(void)addRow:(FormRowDescriptor *)row{
    [_rows addObject:row];
}

-(void)removeRow:(FormRowDescriptor *)row{
    [_rows removeObject:row];
}


@end
