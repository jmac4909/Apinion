//
//  accountViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 1/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol accountViewProtocol

- (void)closeAccountView:(UIViewController*)sender;

@end

@interface accountViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    UIImagePickerController *mediaPicker;
    UIImage* userImage;
    UIActionSheet *actionSheet;
    
}
@property (strong,nonatomic)UIViewController <accountViewProtocol> *delagate;
@property (strong, nonatomic) IBOutlet UIButton *changeProfileButton;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong,nonatomic) UIColor *userThemeColor;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (strong, nonatomic) IBOutlet UIButton *greenButton;

@property (strong, nonatomic) IBOutlet UIButton *orangeButton;
@property (strong, nonatomic) IBOutlet UIButton *whiteButton;
@property (strong, nonatomic) IBOutlet UIButton *greyButton;
@property (strong, nonatomic) IBOutlet UIButton *yellowButton;
@property (strong, nonatomic) IBOutlet UIButton *blueButton;
@property (strong, nonatomic) IBOutlet UIButton *purpleButton;



- (IBAction)changeToRedTheme:(id)sender;
- (IBAction)changeToYellowTheme:(id)sender;
- (IBAction)changeToTanTheme:(id)sender;
- (IBAction)changeToBlueTheme:(id)sender;
- (IBAction)changeToGreenTheme:(id)sender;
- (IBAction)changeToPurpleTheme:(id)sender;


- (IBAction)logOutPress:(id)sender;
- (IBAction)backButtonPress:(id)sender;
- (IBAction)selectUserImage:(id)sender;
@end
