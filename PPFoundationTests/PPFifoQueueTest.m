//
//  PPQueueTest.m
//  PPMediaKit
//
//  Created by Philip Zhao on 7/13/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPFifoQueue.h"

@interface PPFifoQueueTest : XCTestCase

@end

@implementation PPFifoQueueTest
- (void)testEnqueue
{
  PPFifoQueue *queue = [PPFifoQueue new];
  [queue push:@(10)];
  [queue push:@(12)];
  XCTAssert(queue.count == 2, @"Queue must have 2 element");
}

- (void)testDequeue
{
  PPFifoQueue *queue = [PPFifoQueue new];
  [queue push:@(10)];
  [queue push:@(12)];
  id<NSObject> obj = [queue pop];
  XCTAssert(queue.count == 1, @"Queue must have 1 element");
  XCTAssert([obj isEqual:@(10)], @"Object must equal");

  obj = [queue pop];
  XCTAssert(queue.count == 0, @"Queue must have 0 element");
  XCTAssert([obj isEqual:@(12)], @"Object must equal");
}

- (void)testOverDequeue
{
  PPFifoQueue *queue = [PPFifoQueue new];
  [queue push:@(10)];
  [queue push:@(12)];
  [queue pop];
  [queue pop];
  id<NSObject> obj = [queue pop];
  XCTAssert(obj == nil, @"Objett should be nil");
}

- (void)testQueueFront
{
  PPFifoQueue *queue = [PPFifoQueue new];
  XCTAssert([queue firstObject] == nil, @"Object should be nil");
  [queue push:@"Hello"];
  [queue push:@"World"];
  XCTAssert([@"Hello" isEqual:[queue firstObject]], @"Object should be Hello");
}

- (void)testQueueBack
{
  PPFifoQueue *queue = [PPFifoQueue new];
  XCTAssert([queue lastObject] == nil, @"Object should be nil");
  [queue push:@"Hello"];
  [queue push:@"World"];
  XCTAssert([@"World" isEqual:[queue lastObject]], @"Object should be World");
}

- (void)testRemoveAllObjects
{
  PPFifoQueue *queue = [PPFifoQueue new];
  [queue push:@"Hello"];
  [queue push:@"World"];
  [queue removeAllObjects];
  XCTAssertTrue(queue.count == 0, @"Queue should be empty");
  XCTAssert(queue.firstObject == nil, @"First element should be nil");
  [queue removeAllObjects];
  XCTAssertTrue(queue.count == 0, @"Queue should be empty");
  [queue push:@"Bye"];
  XCTAssertTrue(queue.count == 1, @"Queue should have 1 element");
  XCTAssertTrue([[queue pop] isEqual:@"Bye"], @"Return result should be the same");
}

- (void)testContainment
{
  PPFifoQueue *queue = [PPFifoQueue new];
  [queue push:@"Hello"];
  [queue push:@(10)];
  XCTAssertTrue([queue containsObject:@"Hello"], @"Queue should contain Hello");
  XCTAssertTrue([queue containsObject:@(10)], @"Queue should contain 10");
  XCTAssertFalse([queue containsObject:@"HelloW"], @"Queue should not contain HelloW");
}

- (void)testCopying
{
  PPFifoQueue *original = [PPFifoQueue new];
  [original push:@"Hello"];
  [original push:@"World"];
  [original push:@(1)];
  
  PPFifoQueue *copyOne = [original copy];
  original = nil;
  XCTAssert(copyOne.count == 3, @"Count should be 2");
  XCTAssert([[copyOne pop] isEqual:@"Hello"], @"Should be Hello");
  XCTAssert([[copyOne pop] isEqual:@"World"], @"Should be World");
  XCTAssert([[copyOne pop] isEqual:@(1)], @"Should be 1");
}

- (void)testConvertToArray
{
  PPFifoQueue *queue = [PPFifoQueue new];
  [queue push:@"AA"];
  [queue push:@"BB"];
  [queue push:@"CC"];
  NSArray *array = [queue array];
  queue = nil;
  XCTAssert(array.count == 3, @"3 element in array");
  XCTAssert([array[0] isEqualToString:@"AA"], @"First element should be AA");
  XCTAssert([array[1] isEqualToString:@"BB"], @"First element should be BB");
  XCTAssert([array[2] isEqualToString:@"CC"], @"First element should be CC");
}
@end
