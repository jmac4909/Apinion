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


@property (strong,nonatomic)UIViewController <addApinionProtocol> *delagate;
@property (strong,nonatomic)PFObject *selectedUserData;

- (IBAction)cancelButtonPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UITextView *apinionTextView;
@property (strong, nonatomic) IBOutlet UIButton *postApinion;
- (IBAction)postApinionButtonPress:(id)sender;

@end