//
//  TestCell.h
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerTest.h"

@interface TestCell : UITableViewCell

- (void)updateForStatus:(ServerTestStatus)aStatus;

@end
