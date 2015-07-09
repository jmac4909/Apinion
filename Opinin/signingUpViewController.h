//
//  signingUpViewController.h
//  Opinin
//
//  Created by Jeremy Mackey on 1/10/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface signingUpViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    UIImagePickerController *mediaPicker;
    UIImage* userImage;
    UIActionSheet *actionSheet;
    PFFile *imageFile;
}
//Scroll view
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


//TextFeild imput
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *schoolNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (strong, nonatomic) IBOutlet UITextField *gradeField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

- (IBAction)profileImagePress:(id)sender;



//Buttons
- (IBAction)signUpPress:(id)sender;

@end
