//
//  UPCLoginController.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UPCLoginController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;

@end
