//
//  ServerTest.m
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import "ServerTest.h"

@interface ServerTest () {
    RACSubject *_updateSignal;
}
@end


@implementation ServerTest

#pragma mark - Init Method

- (id)init {
    if (self = [super init]) {
        _updateSignal = RACSubject.new;
    }
    return self;
}

+ (id)testWithName:(NSString *)name
          runBlock:(RunBlock)runBlock
{
    return [self testWithName:name previousTest:nil runBlock:runBlock];
}

+ (id)testWithName:(NSString *)name
      previousTest:(ServerTest *)previousTest
          runBlock:(RunBlock)runBlock
{
    ServerTest *test = ServerTest.new;
    test.name = name;
    test.dependentTests = NSMutableSet.new;
    test.previousTest = previousTest;
    test.runBlock = runBlock;
    return test;
}


#pragma mark - Public API

- (void)run {
    self.status = ServerTestStatusTesting;
    [self runDependentTestsOnSuccess];
    self.runBlock(self);
}


#pragma mark - Private API

- (void)runDependentTestsOnSuccess {
    [[RACAble(self.status)
      filter:^BOOL(NSNumber *status) {
          return status.integerValue == ServerTestStatusSucceeded;
      }] subscribeNext:^(id x) {
          for (ServerTest *test in self.dependentTests) {
              [test run];
          }
      }];
}

- (void)setStatus:(ServerTestStatus)status {
    _status = status;
    [_updateSignal sendNext:self];
}

- (void)setPreviousTest:(ServerTest *)previousTest {
    _previousTest = previousTest;
    [previousTest.dependentTests addObject:self];
}


@end
