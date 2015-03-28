//
//  editNameViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 2/8/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface editNameViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextFeild;
- (IBAction)saveButtonPress:(id)sender;

@end
