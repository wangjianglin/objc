//
//  Stack.m
//  LinUtil
//
//  Created by lin on 8/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "Stack.h"


@interface Stack (){
    NSMutableArray* m_array;
}

@end


@implementation Stack



@synthesize count;
- (id)init
{
    if( self=[super init] )
    {
        m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}

- (void)push:(id)anObject
{
    [m_array addObject:anObject];
    count = (int)m_array.count;
}
- (id)pop
{
    id obj = nil;
    if(m_array.count > 0)
    {
        obj = [m_array lastObject];
        [m_array removeLastObject];
        count = (int)m_array.count;
    }
    return obj;
}
- (void)clear
{
    [m_array removeAllObjects];
    count = 0;
}
@end
