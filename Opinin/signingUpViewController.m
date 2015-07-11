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
    
    
 
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 1.0f;
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    self.profileImage.layer.borderColor = color.CGColor;
    
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"Take photo", @"Choose Existing", nil];
    
    
    
    mediaPicker = [[UIImagePickerController alloc] init];
    [mediaPicker setDelegate:self];
    mediaPicker.allowsEditing = YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    userImage =(UIImage*)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.profileImage.image = userImage;
    // Convert to JPEG with 100% quality
    
    NSData* data = UIImageJPEGRepresentation(userImage, 1.0f);
    imageFile = [PFFile fileWithName:@"objectImage.jpg" data:data];
    
        

    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    [metaData setObject:[[PFUser currentUser]objectForKey:@"Object_FirstName"] forKey:@"userName"];


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
  
    if (!self.gradeField.text.length > 0) {
        self.gradeField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.schoolNameField.backgroundColor = [UIColor whiteColor];}
    
    if (!self.passwordField.text.length > 0) {
        self.passwordField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.passwordField.backgroundColor = [UIColor whiteColor];}
 
    if (!self.passwordConfirmField.text.length > 0) {
        self.passwordConfirmField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }else { self.passwordConfirmField.backgroundColor = [UIColor whiteColor];}
    
    if ([self validateEmail:self.emailField.text]) {
    
    
    if (self.firstNameField.text.length > 0 && self.lastNameField.text.length > 0 && self.emailField.text.length > 0 && self.usernameField.text.length > 0 && self.schoolNameField.text.length > 0 && self.passwordField.text.length > 0 && self.passwordConfirmField.text.length > 0 && self.gradeField.text.length > 0) {
        
        if (![self.passwordField.text isEqualToString:self.passwordConfirmField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Your passwords don't match" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
    NSString *Object_FullNameFirst = [NSString stringWithFormat:@"%@%@",self.firstNameField.text,self.lastNameField.text];
    NSString *Object_FullName = [Object_FullNameFirst stringByReplacingOccurrencesOfString:@" " withString:@""];

    PFUser *user = [PFUser user];
    [user setObject:self.firstNameField.text forKey:@"Object_FirstName"];
    [user setObject:self.lastNameField.text forKey:@"Object_LastName"];
    user.email = self.emailField.text;
    user.username = self.usernameField.text;
    [user setObject:self.schoolNameField.text forKey:@"School_Name"];
    user.password = self.passwordField.text;
    [user setObject:self.gradeField.text forKey:@"User_Grade"];
    [user setObject:Object_FullName forKey:@"Object_FullName"];
    [user setObject:imageFile forKey:@"objectImage"];

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self createMetaData];
            [self performSegueWithIdentifier:@"completedSignUp" sender:self];



            

        }else{
            NSLog(@"%@",[error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oh no" message:[NSString stringWithFormat:@"Something fishy just happened"] delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil, nil];
            
            [alert show];
            }
        }];
    
            }
        }
    }else{
        self.emailField.backgroundColor = [UIColor colorWithRed:0.980392 green:0.713726 blue:0.65098 alpha:1];
    }

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:mediaPicker animated:YES completion:^{
            
        }];
    } else if (buttonIndex == 1) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:mediaPicker animated:YES completion:^{
            
        }];}
}

- (IBAction)profileImagePress:(id)sender {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [actionSheet showInView:self.view];
    } else {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:mediaPicker animated:YES completion:^{
            
        }];
    }



}

- (void)closeDocumentView:(UIViewController *)sender{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    
    
    if ([segue.identifier isEqualToString:@"showDoc"]) {
             DocumentViewController *docView = (DocumentViewController *)[segue.destinationViewController topViewController];
            
            docView.delagate = self;
        docView.docType = self.docType;

        NSLog(@"%@",self.docType);
    }
    
}
- (IBAction)termsAndConditionsPress:(id)sender {
    self.docType = @"Term_Conditions";
    [self performSegueWithIdentifier:@"showDoc" sender:self];
}

- (IBAction)privacyButtonPush:(id)sender {
    self.docType = @"PrivacyPolicy";
    [self performSegueWithIdentifier:@"showDoc" sender:self];
}
@end
