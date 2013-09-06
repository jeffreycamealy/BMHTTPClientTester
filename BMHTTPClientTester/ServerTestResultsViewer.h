//
//  ServerTestResultsViewer.h
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerTestResultsViewer <NSObject>

@property (nonatomic) NSSet *topLevelTests;

@end
