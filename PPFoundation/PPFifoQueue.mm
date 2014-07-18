//
//  PPQueue.m
//  PPMediaKit
//
//  Created by Philip Zhao on 7/13/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPFifoQueue.h"

#include <deque>
#include <iterator>

@interface PPFifoQueue() {
  std::deque<id<NSObject>> *_backend;
}
@end

@implementation PPFifoQueue

- (id)copyWithZone:(NSZone *)zone
{
  PPFifoQueue *queue = [PPFifoQueue new];
  for(auto it = _backend->begin(); it != _backend->end(); ++it) {
    [queue push:*it];
  }
  return queue;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _backend = new std::deque<id<NSObject>>();
  }
  return self;
}

- (void)dealloc
{
  free(_backend);
}

- (NSUInteger)count
{
  return _backend->size();
}

- (void)push:(id<NSObject>)obj
{
  _backend->push_back(obj);
}

- (id<NSObject>)pop
{
  if (_backend->size() == 0) {
    return nil;
  }
  
  id<NSObject> obj = _backend->front();
  _backend->pop_front();
  return obj;
}

- (id<NSObject>)firstObject
{
  if (_backend->size() == 0) {
    return nil;
  }
  return _backend->front();
}

- (id<NSObject>)lastObject
{
  if (_backend->size() == 0) {
    return nil;
  }
  return _backend->back();
}

- (void)removeAllObjects
{
  std::deque<id<NSObject>> empty;
  _backend->swap(empty);
}

- (BOOL)containsObject:(id<NSObject>)obj
{
  for (auto it = _backend->begin(); it != _backend->end(); ++it) {
    if ([obj isEqual:*it]) {
      return YES;
    }
  }
  return NO;
}

- (NSArray *)array
{
  if (self.count == 0) {
    return [NSArray array];
  }
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  for (auto it = _backend->begin(); it != _backend->end(); ++it) {
    [array addObject:*it];
  }
  return [array copy];
}
@end
