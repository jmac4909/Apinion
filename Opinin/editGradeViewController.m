//
//  editGradeViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/8/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "editGradeViewController.h"

@interface editGradeViewController ()

@end

@implementation editGradeViewController

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
    self.gradeTextField.text = [[PFUser currentUser]objectForKey:@"User_Grade"];
}


- (IBAction)saveButtonPress:(id)sender{
    
    [[PFUser currentUser]setObject:self.gradeTextField.text forKey:@"User_Grade"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.gradeTextField resignFirstResponder];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"successfully changed your grade" delegate:self cancelButtonTitle:@"Yay" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
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
