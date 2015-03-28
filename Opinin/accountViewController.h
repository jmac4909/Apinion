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

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;


@property (strong, nonatomic) IBOutlet UITableView *tableView;


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
