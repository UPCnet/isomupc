//
//  UPCCommentView.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 12/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASActivityStreams.h"


@interface UPCCommentView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userAndCommentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

- (id)initWithFrame:(CGRect)frame;
- (void)populateWithComment:(ASComment *)comment;

@end
