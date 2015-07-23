//
//  signInViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 1/10/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TTTAttributedLabel.h"
#import "DocumentViewController.h"

@interface signInViewController : UIViewController<TTTAttributedLabelDelegate,documentViewProtocol>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *termsPrivacyLabel;
@property (strong, nonatomic)  NSString *docType;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signInPress:(id)sender;

@end
