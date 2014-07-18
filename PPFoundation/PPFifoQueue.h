//
//  PPQueue.h
//  PPMediaKit
//
//  Created by Philip Zhao on 7/13/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPFifoQueue : NSObject <NSCopying>

@property (nonatomic, assign, readonly) NSUInteger count;

- (void)push:(id<NSObject>)obj;
- (id<NSObject>)pop;
- (void)removeAllObjects;

- (id<NSObject>)firstObject;
- (id<NSObject>)lastObject;
- (BOOL)containsObject:(id<NSObject>)obj;

- (NSArray *)array;
@end
