//
//  editGradeViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 2/8/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface editGradeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *gradeTextField;
- (IBAction)saveButtonPress:(id)sender;
@end
