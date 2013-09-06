//
//  TestCell.m
//  Sporrior
//
//  Created by Jeffrey Camealy on 7/25/13.
//  Copyright (c) 2013 orainteractive. All rights reserved.
//

#import "TestCell.h"

@interface TestCell () {
    UIActivityIndicatorView *activityIndicatorView;
    UIView *statusColorView;
    ServerTestStatus status;
}
@end


@implementation TestCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupActivityIndicatorView];
        [self setupStatusColorView];
    }
    return self;
}


- (void)updateForStatus:(ServerTestStatus)aStatus {
    status = aStatus;
    [self updateActivityIndicatorView];
    [self updateStatusColorView];
    [self updateStatusString];
}


#pragma mark - Private API

- (void)setupActivityIndicatorView {
    activityIndicatorView = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    self.accessoryView = activityIndicatorView;
}

- (void)setupStatusColorView {
    statusColorView = [UIView.alloc initWithFrame:CGRectMake(275, 0, 45, self.frame.size.height)];
    [self addSubview:statusColorView];
}

- (void)updateActivityIndicatorView {
    if (status == ServerTestStatusTesting) {
        [activityIndicatorView startAnimating];
    } else {
        [activityIndicatorView stopAnimating];
    }
}

- (void)updateStatusColorView {
    switch (status) {
        case ServerTestStatusTesting:
            statusColorView.backgroundColor = UIColor.yellowColor;
            break;
            
        case ServerTestStatusSucceeded:
            statusColorView.backgroundColor = UIColor.greenColor;
            break;
            
        case ServerTestStatusFailed:
            statusColorView.backgroundColor = UIColor.redColor;
            break;
            
        default:
            break;
    }
}

- (void)updateStatusString {
    NSArray *statusStrings = @[@"pending", @"testing", @"succeeded", @"failed"];
    self.textLabel.text = statusStrings[status];
}

@end
