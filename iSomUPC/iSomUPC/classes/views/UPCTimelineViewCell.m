//
//  UPCTimelineViewCell.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 23/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCTimelineViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+HumanReadableInterval.h"


@implementation UPCTimelineViewCell

@synthesize avatarImageView;
@synthesize displayNameLabel;
@synthesize activityLabel;
@synthesize relativeDateLabel;
@synthesize numberOfCommentsLabel;

- (void)populate:(ASActivity *)activity
{
    id userDisplayName = ((ASPerson *)activity.actor).displayName;
    NSString *avatarURL = [NSString stringWithFormat:@"http://max.beta.upcnet.es/people/%@/avatar", userDisplayName];

    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"user"]];
    self.displayNameLabel.text = userDisplayName;
    self.activityLabel.text = [activity.verb isEqualToString:@"post"] ? ((ASNote *)activity.object).content : ((ASPerson *)activity.object).displayName;
    self.relativeDateLabel.text = [activity.published humanReadableIntervalFrom:[NSDate date]];
    self.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%u", [activity.replies count]];
}


@end
