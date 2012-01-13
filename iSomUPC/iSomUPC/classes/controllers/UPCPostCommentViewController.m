//
//  UPCPostActivityViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCPostCommentViewController.h"
#import "UPCMaxConnector.h"
#import "UPCRestKitConfigurator.h"
#import "UPCPostCommentViewNotifications.h"


#pragma mark - Class extension

@interface UPCPostCommentViewController ()
@property (strong, nonatomic) ASActivity *activity;
@end


#pragma mark - Class implementation

@implementation UPCPostCommentViewController

#pragma mark - Synthesized properties

@synthesize postButton = _postButton;
@synthesize textView = _textView;
@synthesize activity = _activity;

#pragma mark - Init and dealloc

- (id)initWithActivity:(ASActivity *)activity;
{
    self = [super initWithNibName:@"UPCPostCommentView" bundle:nil];
    if (self != nil) 
    {
        self.activity = activity;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.textView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.postButton = nil;
    self.textView = nil;
}

#pragma mark - UITextView delegate - Enable / disable post activity button

- (void)textViewDidChange:(UITextView *)textView
{
    self.postButton.enabled = [textView.text length] > 0;
}

#pragma mark - Event management

- (IBAction)cancelPosting:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_POSTING_CANCELLED object:self];
}

- (IBAction)post:(id)sender
{
    ASPerson *user = [[ASPerson alloc] init];
    user.displayName = [[UPCMaxConnector sharedMaxConnector] authenticatedUser];
    ASComment *comment = [[ASComment alloc] init];
    comment.content = self.textView.text;
    ASActivity *activity = [[ASActivity alloc] init];
    activity.verb = @"post";
    activity.actor = user;
    activity.object = comment;
    
    UPCRestKitConfigurator *configurator = [UPCRestKitConfigurator sharedConfigurator];
    NSString *commentsPath = [NSString stringWithFormat:@"/activities/%@/comments", self.activity.id];
    RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:activity mapping:configurator.postCommentActivitySerialization];
    [configurator.manager.client post:commentsPath params:[serializer serializationForMIMEType:RKMIMETypeJSON error:nil] delegate:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_POSTING_REQUESTED object:self];
}

#pragma mark - Object loader delegate: hanlde result of post operation

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_POSTING_SUCCEEDED object:self];
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_POSTING_FAILED object:self];
}

@end
