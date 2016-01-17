//
//  LogoutButtonDescriptor.h
//  seller
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import "FormRowDescriptor.h"


@interface FormButtonDescriptor : FormRowDescriptor

@property void(^click)();

-(instancetype)initWithTitle:(NSString *)title;

@end
