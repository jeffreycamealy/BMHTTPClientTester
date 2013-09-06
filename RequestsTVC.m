//
//  RequestsTVC.m
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import "RequestsTVC.h"
#import "HTTPClient.h"
#import "ServerConstants.h"
#import "Server.h"
#import "AFNetworking.h"
#import "BMUtilityPack.h"
#import "ReactiveCocoa.h"
#import "ServerTest.h"
#import "ServerTest+Convenience.h"
#import "TestCell.h"


#define TestCell_ID @"TestCell"

@interface RequestsTVC () {
    NSUInteger numFailed;
    NSMutableArray *allTests;
}
@end


@implementation RequestsTVC

#pragma mark - Init Method

- (id)init {
    if (self = [super init]) {
        [self.tableView registerClass:TestCell.class forCellReuseIdentifier:TestCell_ID];
    }
    return self;
}


#pragma mark - Private API

- (void)updateCompletedStatus {
    if (self.allTestsAreComplete) {
        if (numFailed) {
            self.title = str(@"%i Failures.  %i Total Tests.", numFailed, allTests.count);
        } else {
            self.title = str(@"Success.  %i Total Tests", allTests.count);
        }
    }
}

- (BOOL)allTestsAreComplete {
    NSUInteger numCompleted = 0;
    numFailed = 0;
    for (ServerTest *test in allTests) {
        if (test.isCompleted) numCompleted++;
        if (test.status == ServerTestStatusFailed) numFailed++;
    }
    return numCompleted == allTests.count;
}

#pragma mark - CustomSetters

- (void)setTopLevelTests:(NSSet *)topLevelTests {
    _topLevelTests = topLevelTests;
    
    allTests = NSMutableArray.new;
    for (ServerTest *test in topLevelTests) {
        [self addTestsFromRootTest:test];
    }
    
    [self.tableView reloadData];
    [self updateCompletedStatus];
    
    for (ServerTest *test in allTests) {
        [test.updateSignal subscribeNext:^(id x) {
            [self.tableView reloadData];
            [self updateCompletedStatus];
        }];
    }
}

- (void)addTestsFromRootTest:(ServerTest *)test {
    [allTests addObject:test];
    for (ServerTest *dependentTest in test.dependentTests) {
        [self addTestsFromRootTest:dependentTest];
    }
}


#pragma mark - Tableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allTests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TestCell_ID];
    ServerTest *test = allTests[indexPath.row];
    
    [cell updateForStatus:test.status];
    
    cell.detailTextLabel.text = test.name;
    
    return cell;
}


#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
