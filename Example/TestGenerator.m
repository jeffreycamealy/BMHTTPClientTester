//
//  TestGenerator.m
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/31/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import "TestGenerator.h"
#import "ServerTest.h"
#import "Server.h"
#import "LoggingHTTPClient.h"
#import "ServerConstants.h"
#import "BMUtilityPack.h"
#import "Prediction.h"
#import "Model.h"
#import "User.h"


@interface TestGenerator () {
    Server *server;
    Model *model;
    User *user;
}
@end


@implementation TestGenerator

#pragma mark - Init Method

- (id)init {
    if (self = [super init]) {
        [self setupServer];
    }
    return self;
}


#pragma mark - Private API

- (void)setupServer {
    LoggingHTTPClient *httpClient = [LoggingHTTPClient.alloc initWithBaseURL:url(BasePath)];
    model = Model.new;
    server = [Server.alloc initWithHTTPClient:httpClient dataModel:model];
}


#pragma mark - Tests

- (NSSet *)generateTestsAndReturnTopLevelTests {
    ServerTest *requestAuthToken =
    [ServerTest testWithName:@"get authtoken"
                    runBlock:^(ServerTest *test)
     {
         [[server requestAuthToken]
          subscribeNext:^(NSDictionary *response) {
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    ServerTest *registerUser =
    [ServerTest testWithName:@"register user"
                previousTest:requestAuthToken
                    runBlock:^(ServerTest *test)
     {
         NSString *randomEmail = str(@"test+%@@gmail.com", BMMath.randomString);
         user = User.new;
         user.firstName = @"Bill";
         user.lastName = @"Gates";
         user.email = randomEmail;
         user.password = @"testPassword";
         [[server registerUser:user]
          subscribeNext:^(NSDictionary *response) {
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    

    [ServerTest testWithName:@"login user"
                previousTest:registerUser
                    runBlock:^(ServerTest *test)
     {
         [[[server requestAuthToken]
           flattenMap:^RACStream *(id value) {
               return [server loginUser:user];
           }] subscribeNext:^(id x) {
               test.status = ServerTestStatusSucceeded;
           } error:^(NSError *error) {
               test.status = ServerTestStatusFailed;
           }];
     }];
    
    
    ServerTest *getPredictions =
    [ServerTest testWithName:@"get predictions"
                previousTest:registerUser
                    runBlock:^(ServerTest *test)
     {
         [[server requestPredictions]
          subscribeNext:^(NSArray *predictions) {
              test.testingData = @{@"templateID": @([predictions[0] templateID])};
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    [ServerTest testWithName:@"make selection"
                previousTest:getPredictions
                    runBlock:^(ServerTest *test)
     {
         [[server makeSelectionForTemplateID:[getPredictions.testingData[@"templateID"] integerValue]
                              selectionIndex:1]
          subscribeNext:^(id x) {
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    ServerTest *searchForFriends =
    [ServerTest testWithName:@"search for friends"
                previousTest:registerUser
                    runBlock:^(ServerTest *test)
     {
         [[server searchFriendsWithKey:@"Tim"]
          subscribeNext:^(NSArray *users) {
              NSUInteger userID = [users.lastObject backendID];
              test.testingData = @{@"userID": @(userID)};
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    ServerTest *addFriend =
    [ServerTest testWithName:@"add friend"
                previousTest:searchForFriends
                    runBlock:^(ServerTest *test)
     {
         NSUInteger userID = [searchForFriends.testingData[@"userID"] integerValue];
         [[server addFriendWithID:userID]
          subscribeNext:^(id x) {
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    [ServerTest testWithName:@"list friends"
                previousTest:addFriend
                    runBlock:^(ServerTest *test)
     {
         [[server listFriends]
          subscribeNext:^(NSArray *users) {
              test.status = users.count ? ServerTestStatusSucceeded : ServerTestStatusFailed;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    [ServerTest testWithName:@"get profile"
                previousTest:registerUser
                    runBlock:^(ServerTest *test)
     {
         [[server getProfile]
          subscribeNext:^(id x) {
              test.status = ServerTestStatusSucceeded;
          } error:^(NSError *error) {
              test.status = ServerTestStatusFailed;
          }];
     }];
    
    
    return [NSSet setWithObject:requestAuthToken];
}


@end

































