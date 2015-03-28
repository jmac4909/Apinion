//
//  createGroupViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 3/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@protocol closeCreateGroupViewProtocol

- (void)closeCreateGroupView:(UIViewController*)sender;

@end


@interface createGroupViewController : UIViewController<UITextFieldDelegate>

@property (strong,nonatomic)UIViewController <closeCreateGroupViewProtocol> *delagate;

@property (strong, nonatomic) IBOutlet UIView *bottomAlertView;
@property (strong, nonatomic) IBOutlet UIView *topAlertView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextField *groupNameLabel;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)createButtonAction:(id)sender;


@end
