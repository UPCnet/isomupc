//
//  UPCSecondViewController.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPCProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;

- (IBAction)logout:(id)sender;

@end
