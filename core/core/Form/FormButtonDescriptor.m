//
//  LogoutButtonDescriptor.m
//  seller
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import "FormButtonDescriptor.h"
#import "FormButtonCell.h"

@interface FormButtonDescriptor (){
    @private
    void (^_click)();
}

@end

@implementation FormButtonDescriptor

-(void (^)())click{
    return _click;
}
-(void)setClick:(void (^)())click{
    _click = click;
}

-(instancetype)initWithTitle:(NSString *)title{
    return [super initWithTitle:title name:@""];
}

-(Class)formBaseCellClassFromRowDescriptor{
    return [FormButtonCell class];
}

@end
