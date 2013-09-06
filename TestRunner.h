//
//  TestRunner.h
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerTestResultsViewer.h"

@interface TestRunner : NSObject

- (void)runTestsWithResultsViewer:(id<ServerTestResultsViewer>)resultsViewer;

@end
