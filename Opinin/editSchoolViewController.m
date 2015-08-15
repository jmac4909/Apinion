//
//  editSchoolViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/8/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "editSchoolViewController.h"

@interface editSchoolViewController ()

@end

@implementation editSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.schoolTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.schoolTextField.text = [[PFUser currentUser]objectForKey:@"School_Name"];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
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
    
    
    [[PFUser currentUser]setObject:self.schoolTextField.text forKey:@"School_Name"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.schoolTextField resignFirstResponder];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"successfully changed your school / occupation" delegate:self cancelButtonTitle:@"Yay" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
    
    
    
}
@end
