//
//  UPCPostActivityViewController.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"


@interface UPCPostActivityViewController : UIViewController <UITextViewDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *postActivityButton;

- (IBAction)cancelActivityPosting:(id)sender;
- (IBAction)postActivity:(id)sender;

@end
