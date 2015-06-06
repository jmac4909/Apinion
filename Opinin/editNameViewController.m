//
//  editNameViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/8/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "editNameViewController.h"

@interface editNameViewController ()

@end

@implementation editNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstNameTextFeild.delegate = self;
    self.lastNameTextFeild.delegate = self;
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.firstNameTextFeild.text = [[PFUser currentUser]objectForKey:@"Object_FirstName"];
    self.lastNameTextFeild.text = [[PFUser currentUser]objectForKey:@"Object_LastName"];
    
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

- (IBAction)saveButtonPress:(id)sender {
    
    
    [[PFUser currentUser]setObject:self.firstNameTextFeild.text forKey:@"Object_FirstName"];
    [[PFUser currentUser]setObject:self.lastNameTextFeild.text forKey:@"Object_LastName"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.firstNameTextFeild resignFirstResponder];
        [self.lastNameTextFeild resignFirstResponder];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"successfully changed your name" delegate:self cancelButtonTitle:@"Yay" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}
@end
