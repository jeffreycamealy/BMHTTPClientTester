//
//  ServerTest.h
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@class ServerTest;

typedef void (^RunBlock)(ServerTest *test);

typedef enum {
    ServerTestStatusPending = 0,
    ServerTestStatusTesting,
    ServerTestStatusSucceeded,
    ServerTestStatusFailed
} ServerTestStatus;


@interface ServerTest : NSObject

@property NSString *name;
@property (nonatomic) ServerTestStatus status;
@property RACSignal *updateSignal;
@property (strong) RunBlock runBlock;
@property (nonatomic) ServerTest *previousTest;
@property NSMutableSet *dependentTests;
@property (nonatomic) BOOL isADependentTest; // Set Automatically by the Test Runner
@property NSDictionary *parentData;
@property id serverResponse;
@property NSDictionary *testingData;

- (void)run;


+ (id)testWithName:(NSString *)name
          runBlock:(RunBlock)runBlock;

+ (id)testWithName:(NSString *)name
      previousTest:(ServerTest *)previousTest
          runBlock:(RunBlock)runBlock;

@end
