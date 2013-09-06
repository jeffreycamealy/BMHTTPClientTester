//
//  RequestsTVC.h
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerTestResultsViewer.h"

@interface RequestsTVC : UITableViewController <ServerTestResultsViewer>

@property (nonatomic) NSSet *topLevelTests;

@end
