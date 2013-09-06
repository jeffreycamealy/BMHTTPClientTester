//
//  TestRunner.m
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import "TestRunner.h"
#import "ServerTest.h"
#import <libextobjc/EXTRuntimeExtensions.h>
#import "ServerTest.h"
#import "BMServerTestGenerator.h"


@interface TestRunner () {
    NSSet *topLevelTests;
}
@end


@implementation TestRunner

#pragma mark - Public API

- (void)runTestsWithResultsViewer:(id<ServerTestResultsViewer>)resultsViewer {
    [self retreiveTopLevelTests];
    resultsViewer.topLevelTests = topLevelTests;
    for (ServerTest *test in topLevelTests) [test run];
}


#pragma mark - Private API

- (void)retreiveTopLevelTests {
    topLevelTests = NSSet.new;
    unsigned numClasses = 0;
    Class *classes = ext_copyClassListConformingToProtocol(@protocol(BMServerTestGenerator), &numClasses);
    for (int i = 0; i < numClasses; i++) {
        NSLog(@"Class name: %s", class_getName(classes[i]));
        id class = [classes[i] new];
        NSSet *tests = [class generateTestsAndReturnTopLevelTests];
        topLevelTests = [topLevelTests setByAddingObjectsFromSet:tests];
    }
    free(classes);
}

@end

































