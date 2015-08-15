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
    self.coverVie.userInteractionEnabled = NO;
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.borderWidth = 1.0f;
    
    

    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Whats your Apinion?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidChange:(nonnull UITextView *)textView{
    if (![[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![textView.text isEqualToString:@"Whats your Apinion?"] && textView.text.length >0) {
        self.postApinionButton.enabled = true;
        
    }else{
        self.postApinionButton.enabled = false;

    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{



    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.userImageView.layer.borderColor = self.userThemeColor.CGColor;
    self.postApinionButton.tintColor = self.userThemeColor;
    [self.seporatorImageView setBackgroundColor:self.userThemeColor];
    
    NSString *firstName = [[[PFUser currentUser] objectForKey:@"Object_FirstName"]stringByAppendingString:@" "];
    
    NSString *fullName = [firstName stringByAppendingString:[[PFUser currentUser] objectForKey:@"Object_LastName"]];
    self.userLabel.text = fullName;
    [self.userImageView setFrame:CGRectMake(self.userImageView.frame.origin.x, self.userImageView.frame.origin.y, self.userImageView.frame.size.width, self.userImageView.frame.size.height)];
    //Get user Image
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"objectImage"];
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

    self.navigationItem.leftBarButtonItem.tintColor = self.userThemeColor;
    self.postApinionButton.enabled = false;

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PFUser currentUser] fetch];

    if ([PFUser currentUser] == Nil) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    }
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
    
    
    NSString *postString = [self.apinionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        PFObject *apinion = [PFObject objectWithClassName:@"Apinions"];
        [apinion setObject:postString forKey:@"postText"];
        [apinion setObject:self.selectedUserData.objectId forKey:@"selectedUserID"];
        [apinion setObject:[PFUser currentUser].objectId forKey:@"posterID"];
        [apinion setObject:@0 forKey:@"postVotes"];
        [apinion setObject:[PFUser currentUser] forKey:@"userPosterObject"];
        self.apinionTextView.text = @"";
    
        if (self.hideNameSwitch.on) {
            [apinion setObject:@"" forKey:@"displayName"];
        }else{
            NSString *displayname = [NSString stringWithFormat:@"- %@ %@",[[PFUser currentUser]objectForKey:@"Object_FirstName"],[[PFUser currentUser]objectForKey:@"Object_LastName"]];
            [apinion setObject:displayname forKey:@"displayName"];
        }
    
        if ([self isUserBanned]) {
            [apinion setObject:@"True" forKey:@"Hidden"];
        }
    
         [apinion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {

                [self.selectedUserData fetch];
                NSNumber *count = [self.selectedUserData objectForKey:@"ApinionCount"];
                int countInt = [count intValue] + 1;
                count = [[NSNumber alloc]initWithInt:countInt];
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.selectedUserData.objectId,@"objectId",count,@"currentCount", nil];
                [PFCloud callFunction:@"addApinionCount" withParameters:params];
                
                

                PFPush *push = [[PFPush alloc] init];
                [push setChannel:[@"A" stringByAppendingString:self.selectedUserData.objectId]];
                [push setMessage:@"New Apinion about you!"];
                
                [push sendPushInBackground];
                
                [self.delagate closeAddApinion:self];
                


                

    
            }else{
                    NSLog(@"%@",error.userInfo);
            }
            }];
    

    


    
}

- (BOOL)isUserBanned{
    if ([[[PFUser currentUser]objectForKey:@"Banned"]isEqualToString:@"True"]) {
        return true;
    }
    return false;
}

- (IBAction)hideNameValeChanged:(id)sender {
    if (self.hideNameSwitch.on) {
        self.coverVie.alpha = 0.6;


    }else{
        self.coverVie.alpha = 0.0;


    }
}
 

@end
