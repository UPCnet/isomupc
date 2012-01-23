//
//  UPCTimelineViewCell.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 23/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASActivityStreams.h"


@interface UPCTimelineViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (strong, nonatomic) IBOutlet UILabel *relativeDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

- (void)populate:(ASActivity *)activity;

@end
