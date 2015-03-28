//
//  signingUpViewController.m
//  Opinin
//
//  Created by Jeremy Mackey on 1/10/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "signingUpViewController.h"

@interface signingUpViewController ()

@end

@implementation signingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    self.usernameField.delegate = self;
    self.schoolNameField.delegate = self;
    self.passwordField.delegate = self;
    self.passwordConfirmField.delegate = self;
    
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.view.frame.size.height/3);
    
    
 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)createMetaData{
    NSString *userIdString = [@"A" stringByAppendingString:[PFUser currentUser].objectId];
    NSArray *subcribtionArray = @[userIdString];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];

    PFObject *metaData = [PFObject objectWithClassName:@"userMetaData"];
    [metaData setObject:@0 forKey:@"userViews"];
    [metaData setObject:[PFUser currentUser] forKey:@"user"];
    [metaData setObject:[PFUser currentUser].objectId forKey:@"userId"];
    [metaData setObject:[[PFUser currentUser]objectForKey:@"First_Name"] forKey:@"userName"];


    [metaData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Eroor %@",error.userInfo);
    }];
    
}
- (IBAction)signUpPress:(id)sender {
    if (!self.firstNameField.text.length > 0) {
        self.firstNameField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.firstNameField.backgroundColor = [UIColor whiteColor];}
   
    if (!self.lastNameField.text.length > 0) {
        self.lastNameField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.lastNameField.backgroundColor = [UIColor whiteColor];}
   
    if (!self.emailField.text.length > 0) {
        self.emailField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.emailField.backgroundColor = [UIColor whiteColor];}
   
    if (!self.usernameField.text.length > 0) {
        self.usernameField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.usernameField.backgroundColor = [UIColor whiteColor];}
  
    if (!self.schoolNameField.text.length > 0) {
        self.schoolNameField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.schoolNameField.backgroundColor = [UIColor whiteColor];}
  
    if (!self.passwordField.text.length > 0) {
        self.passwordField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.passwordField.backgroundColor = [UIColor whiteColor];}
 
    if (!self.passwordConfirmField.text.length > 0) {
        self.passwordConfirmField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.passwordConfirmField.backgroundColor = [UIColor whiteColor];}
    
    if ([self validateEmail:self.emailField.text]) {
    
    
    if (self.firstNameField.text.length > 0 && self.lastNameField.text.length > 0 && self.emailField.text.length > 0 && self.usernameField.text.length > 0 && self.schoolNameField.text.length > 0 && self.passwordField.text.length > 0 && self.passwordConfirmField.text.length > 0) {
        
        if (![self.passwordField.text isEqualToString:self.passwordConfirmField.text]) {
            NSLog(@"differnt passwords");
        }else{
    
    PFUser *user = [PFUser user];
    [user setObject:self.firstNameField.text forKey:@"First_Name"];
    [user setObject:self.lastNameField.text forKey:@"Last_Name"];
    user.email = self.emailField.text;
    user.username = self.usernameField.text;
    [user setObject:self.schoolNameField.text forKey:@"School_Name"];
    user.password = self.passwordField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self createMetaData];
            [self performSegueWithIdentifier:@"completedSignUp" sender:self];



            

        }else{
            NSLog(@"%@",[error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oh no" message:[NSString stringWithFormat:@"%@",[error userInfo]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            }
        }];
    
            }
        }
    }else{
        self.emailField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }

}
@end
