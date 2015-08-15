//
//  addApinionViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 4/12/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@protocol addApinionProtocol

- (void)closeAddApinion:(UIViewController*)sender;

@end


@interface addApinionViewController : UIViewController<UITextViewDelegate>{
    UIImage *userImage;
 
}


@property (strong, nonatomic) IBOutlet UIView *coverVie;
@property (strong,nonatomic)UIViewController <addApinionProtocol> *delagate;
@property (strong,nonatomic)PFObject *selectedUserData;
@property (strong,nonatomic) UIColor *userThemeColor;

- (IBAction)cancelButtonPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIImageView *seporatorImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postApinionButton;

@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UITextView *apinionTextView;
- (IBAction)postApinionButtonPress:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *hideNameSwitch;
- (IBAction)hideNameValeChanged:(id)sender;
 
@end
