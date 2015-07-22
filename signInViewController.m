//
//  signInViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 1/10/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "signInViewController.h"

@interface signInViewController ()

@end

@implementation signInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
 
    self.termsPrivacyLabel.delegate = self;

    
    //after setting the label text:
    [self.termsPrivacyLabel addLinkToURL:[NSURL URLWithString:@"terms"] withRange:[self.termsPrivacyLabel.text rangeOfString:@"Terms Of Use"]];
    
        [self.termsPrivacyLabel addLinkToURL:[NSURL URLWithString:@"privacy"] withRange:[self.termsPrivacyLabel.text rangeOfString:@"Privacy Policy"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signInPress:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
         NSString *userIdString = [@"A" stringByAppendingString:[PFUser currentUser].objectId];
            NSArray *subcribtionArray = @[userIdString];
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
            [[PFInstallation currentInstallation] saveEventually];
            [self performSegueWithIdentifier:@"completedLogIn" sender:self];
           
        }else{
            NSLog(@"%@",[error userInfo]);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Invalid login credentials " delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    
    
}
- (void)closeDocumentView:(UIViewController *)sender{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    // for handling the URL but we just call our action
 
    if ([[url absoluteString]isEqualToString:@"terms"]) {
         self.docType = @"Term_Conditions";
    }
    if ([[url absoluteString]isEqualToString:@"privacy"]) {
         self.docType = @"PrivacyPolicy";
    }
    [self performSegueWithIdentifier:@"showDoc" sender:self];

 }


- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    
    
    if ([segue.identifier isEqualToString:@"showDoc"]) {
        DocumentViewController *docView = (DocumentViewController *)[segue.destinationViewController topViewController];
        
        docView.delagate = self;
        docView.docType = self.docType;
        
        NSLog(@"%@",self.docType);
    }
    
}

@end
