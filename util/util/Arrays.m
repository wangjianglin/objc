//
//  Arrays.m
//  LinUtil
//
//  Created by lin on 8/6/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "Arrays.h"


@implementation NSMutableArray(LinUtil)

-(void)addObjectsFromArray:(NSArray*)items isEqual:(BOOL(^)(id a,id b))equal{
    
    if (items == nil || items.count == 0) {
        return;
    }
    
    if (self.count == 0) {
        [self addObjectsFromArray:items];
        return;
    }
    
    NSMutableArray * addArrays = [[NSMutableArray alloc] init];
    
    BOOL isEqual = FALSE;
    for (id item in items) {
        isEqual = FALSE;
        for (id item2 in self) {
            if (equal(item,item2)) {
                isEqual = TRUE;
                break;
            }
        }
        if (!isEqual) {
            [addArrays addObject:item];
        }
    }
    [self addObjectsFromArray:addArrays];
}

@end