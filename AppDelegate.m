//
//  AppDelegate.m
//  ServerTester
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 bearMountain. All rights reserved.
//

#import "AppDelegate.h"
#import "RequestsTVC.h"
#import "TestRunner.h"


@implementation AppDelegate

#pragma mark - AppDelegate Method

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWindow];
    [self setupRootVC];
    
    return YES;
}


#pragma mark - Private API

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
}

- (void)setupRootVC {
    // View Hierarchy
    RequestsTVC *requestsTVC = RequestsTVC.new;
    UINavigationController *navController = [UINavigationController.alloc initWithRootViewController:requestsTVC];
    self.window.rootViewController = navController;
    
    // Run Tests
    TestRunner *testRunner = TestRunner.new;
    [testRunner runTestsWithResultsViewer:requestsTVC];
}



@end

































