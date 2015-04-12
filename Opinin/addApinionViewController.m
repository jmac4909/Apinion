//
//  addApinionViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 4/12/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "addApinionViewController.h"

@interface addApinionViewController ()

@end

@implementation addApinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.apinionTextView.delegate = self;
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Whats your Apinion?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *firstName = [[[PFUser currentUser] objectForKey:@"First_Name"]stringByAppendingString:@" "];
    
    NSString *fullName = [firstName stringByAppendingString:[[PFUser currentUser] objectForKey:@"Last_Name"]];
    self.userLabel.text = fullName;
    //Get user Image
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"userPicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *recievedUserImage = [UIImage imageWithData:data];
            if (userImage) {
                self.userImageView.image = userImage;
            }else{
                self.userImageView.image = recievedUserImage;
                
            }
            
            
        }
    }];

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

- (IBAction)cancelButtonPress:(id)sender {
    [self.delagate closeAddApinion:self];
}
- (IBAction)postApinionButtonPress:(id)sender {
    
    
        PFObject *apinion = [PFObject objectWithClassName:@"Apinions"];
        [apinion setObject:self.apinionTextView.text forKey:@"postText"];
        [apinion setObject:self.selectedUserData.objectId forKey:@"selectedUserID"];
        [apinion setObject:[PFUser currentUser].objectId forKey:@"posterID"];
        [apinion setObject:@0 forKey:@"postVotes"];
        self.apinionTextView.text = @"";
    
        [apinion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
    
    
    
    
    
    
               
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannel:[@"A" stringByAppendingString:self.selectedUserData.objectId]];
                    [push setMessage:@"New Apinion about you!"];
    
                    [push sendPushInBackground];
    
    
                }else{
                    NSLog(@"%@",error.userInfo);
                }
            }];
            
    

    
    
}
@end
