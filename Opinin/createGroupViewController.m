//
//  createGroupViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 3/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "createGroupViewController.h"

@interface createGroupViewController ()

@end

@implementation createGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    self.topAlertView.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    self.bottomAlertView.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    self.groupNameLabel.delegate = self;
    

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    self.bgView.hidden = NO;

    [self.groupNameLabel becomeFirstResponder];
    
    
    
    self.bottomAlertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.bottomAlertView.hidden = NO;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.bottomAlertView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dissmissPopUp {
    [self.groupNameLabel resignFirstResponder];
    self.bgView.hidden = YES;
    self.bottomAlertView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomAlertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        self.groupNameLabel.text = @"";
        self.bottomAlertView.hidden = YES;
        [self.delagate closeCreateGroupView:self];

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

- (IBAction)cancelButtonAction:(id)sender {
    
    [self dissmissPopUp];
    
}

- (IBAction)createButtonAction:(id)sender {
    
    if (self.groupNameLabel.text.length > 0) {
        
    
        PFObject *group = [PFObject objectWithClassName:@"Groups"];
        [group setObject:[PFUser currentUser].objectId forKey:@"creatorId"];
        [group setObject:self.groupNameLabel.text forKey:@"groupName"];
        [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dissmissPopUp];
        }];
        
        
    }

}
@end
