//
//  editEmailViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/8/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "editEmailViewController.h"

@interface editEmailViewController ()

@end

@implementation editEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.emailTextFeild.text = [PFUser currentUser].email;

    if ((BOOL)[[PFUser currentUser] objectForKey:@"emailVerified"] == true) {
        self.emailStatusTextFeild.text = @"Verified";
        self.emailStatusTextFeild.textColor = [UIColor greenColor];
    }else{
        self.emailStatusTextFeild.text = @"Not Verified";
        self.emailStatusTextFeild.textColor = [UIColor redColor];

    }
    
    
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (IBAction)saveButtonPress:(id)sender{
    if ([self validateEmail:self.emailTextFeild.text]) {
        [PFUser currentUser].email = self.emailTextFeild.text;
        [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.emailTextFeild resignFirstResponder];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"successfully changed your email" delegate:self cancelButtonTitle:@"Yay" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Not a valid email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
