//
//  UPCCommentView.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 12/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCCommentView.h"
#import "UIImageView+WebCache.h"


@implementation UPCCommentView

@synthesize avatarImageView;
@synthesize userAndCommentLabel;
@synthesize dateLabel;

- (id)initWithFrame:(CGRect)frame
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"UPCCommentView" owner:nil options:nil];
    self = [objects lastObject];
    self.frame = frame;
    return self;
}

- (void)populateWithComment:(ASComment *)comment
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) 
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    id userDisplayName = ((ASPerson *)comment.author).displayName;
    NSString *avatarURL = [NSString stringWithFormat:@"http://max.beta.upcnet.es/people/%@/avatar", userDisplayName];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"user"]];
    self.userAndCommentLabel.text = [NSString stringWithFormat:@"%@ - %@", userDisplayName, comment.content];
    self.dateLabel.text = (comment.published != nil) ? [dateFormatter stringFromDate:comment.published] : @"data desconeguda";
}

- (void)layoutSubviews
{
    self.userAndCommentLabel.frame = CGRectMake(self.userAndCommentLabel.frame.origin.x, self.userAndCommentLabel.frame.origin.y, self.frame.size.width - self.avatarImageView.frame.size.width - 48, 21);
    [self.userAndCommentLabel sizeToFit];
    self.dateLabel.frame = CGRectMake(self.dateLabel.frame.origin.x, self.userAndCommentLabel.frame.origin.y + self.userAndCommentLabel.frame.size.height + 8, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize commentLabelAvailableSize = CGSizeMake(size.width - self.avatarImageView.frame.size.width - 48, size.height);
    CGSize commentLabelSize = [self.userAndCommentLabel sizeThatFits:commentLabelAvailableSize];
    return CGSizeMake(size.width, self.userAndCommentLabel.frame.origin.y + commentLabelSize.height + 8 + self.dateLabel.frame.size.height + 10);
}

@end
