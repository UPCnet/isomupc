//
//  UPCActivityViewController.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASActivityStreams.h"


@interface UPCActivityViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityContentLabel;

- (id)initWithActivity:(ASActivity *)activity;

@end
