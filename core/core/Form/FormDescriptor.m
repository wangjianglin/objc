//
//  FormDescriptor.m
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

#import "FormDescriptor.h"


@interface FormDescriptor(){
    @private
    NSMutableArray * _sections;
}

@end

@implementation FormDescriptor


-(instancetype)init{
    self = [super init];
    if (self) {
        _sections = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)sections{
    return _sections;
}
-(void)setSections:(NSArray *)sections{
    [_sections removeAllObjects];
    if (sections != nil) {
        [_sections addObjectsFromArray:sections];
    }
}

-(void)addSection:(FormSectionDescriptor *)section{
    [_sections addObject:section];
}

-(void)removeSection:(FormSectionDescriptor *)section{
    [_sections removeObject:section];
}


-(NSDictionary *)formValues{
    NSMutableDictionary * formValues = [[NSMutableDictionary alloc] init];
    for (FormSectionDescriptor * section in _sections) {
        for (FormRowDescriptor * row in section.rows) {
            if (row.name != nil) {
                if(row.value != nil){
                    formValues[row.name] = row.value;
                }else{
                    formValues[row.name] = [NSNull null];
                }
            }
        }
    }
    return formValues;
}
@end
