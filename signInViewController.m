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
        [self performSegueWithIdentifier:@"completedSignIn" sender:self];
            NSString *userIdString = [@"A" stringByAppendingString:[PFUser currentUser].objectId];
            NSArray *subcribtionArray = @[userIdString];
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
            [[PFInstallation currentInstallation] saveEventually];
        }else{
            NSLog(@"%@",[error userInfo]);
        }
    }];
    
    
    
}
@end
