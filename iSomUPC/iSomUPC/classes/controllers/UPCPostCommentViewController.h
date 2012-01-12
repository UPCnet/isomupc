//
//  UPCPostActivityViewController.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"
#import "ASActivityStreams.h"


@interface UPCPostCommentViewController : UIViewController <UITextViewDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (id)initWithActivity:(ASActivity *)activity;

- (IBAction)cancelPosting:(id)sender;
- (IBAction)post:(id)sender;

@end
