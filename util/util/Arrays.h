//
//  Arrays.h
//  LinUtil
//
//  Created by lin on 8/6/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (LinUtil)

-(void)addObjectsFromArray:(NSArray*)items isEqual:(BOOL(^)(id a,id b))equal;

@end
