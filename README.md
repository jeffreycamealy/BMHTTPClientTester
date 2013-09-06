BMHTTPClientTester
==================
`BMHTTPClientTester` is a framework that allows you to run __asyncronous acceptance tests__ on your App's HTTPClient.  
You generate tests that will run against a live server, and the framework will run your tests and display their successes and failures.


![image](https://github.com/jeffreycamealy/BMHTTPClientTester/blob/master/Example/SampleRun.png?raw=true)

## Usage
### New App Target
- Within your XCode project, create a new App Target
- Import all files from the BMHTTPClientTest folder
- Replace the automatically generated AppDelegate with the AppDelegate provided here.

### Create A Test Generator Class
- Create a subclass of `NSObject` - this will be the class where you generate your tests.
- This class must conform to the `BMServerTestGenerator` protocol
- Implement the one required method: `generateTestsAndReturnTopLevelTests`
- In this method you will generate `ServerTest` objects and then return all TopLevelTests - that is, tests that do 
not depend on any previous test.  A sample implementation is provided below.

```
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
    
    ServerTest *loginUser = 
    [ServerTest testWithName:@"login user"
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
    

    return [NSSet setWithObjects:requestAuthToken, loginUser, nil];
}
```

## Roadmap

This framework is still in early development.  It is functioning and is being used in internal projects, thought it 
needs more work to make integration easier and more clear for potential 3rd party usage.
