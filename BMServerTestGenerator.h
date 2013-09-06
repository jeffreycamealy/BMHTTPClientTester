//
//  BMServerTestGenerator.h
//  Sporrior
//
//  Created by Jeffrey Camealy on 8/7/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMServerTestGenerator <NSObject>

- (NSSet *)generateTestsAndReturnTopLevelTests;

@end
