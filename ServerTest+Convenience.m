

#import "ServerTest+Convenience.h"

@implementation ServerTest (Convenience)

- (BOOL)isCompleted {
    return (self.status == ServerTestStatusSucceeded ||
            self.status == ServerTestStatusFailed);
}

@end
