//
//  UPCCommentView.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 12/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCCommentView.h"


@implementation UPCCommentView

@synthesize commentLabel;
@synthesize userAndDateLabel;

- (id)initWithFrame:(CGRect)frame
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"UPCCommentView" owner:nil options:nil];
    self = [objects lastObject];
    self.frame = frame;
    return self;
}

- (void)populateWithComment:(ASComment *)comment
{
    self.commentLabel.text = comment.content;
    if (comment.published != nil)
        self.userAndDateLabel.text = [NSString stringWithFormat:@"%@ %@", ((ASPerson *)comment.author).displayName, comment.published];
    else
        self.userAndDateLabel.text = [NSString stringWithFormat:@"%@", ((ASPerson *)comment.author).displayName];
}

- (void)layoutSubviews
{
    self.commentLabel.frame = CGRectMake(20, 20, self.bounds.size.width - 20, 21);
    [self.commentLabel sizeToFit];
    self.userAndDateLabel.frame = CGRectMake(20, self.commentLabel.frame.origin.y + self.commentLabel.frame.size.height + 8, self.bounds.size.width - 40, self.userAndDateLabel.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize commentLabelSize = [self.commentLabel sizeThatFits:size];
    return CGSizeMake(size.width, self.commentLabel.frame.origin.y + commentLabelSize.height + 8 + self.userAndDateLabel.frame.size.height + 10);
}

@end
