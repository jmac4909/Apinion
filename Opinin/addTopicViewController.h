//
//  addTopicViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 3/29/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@protocol createTopicViewProtocol

- (void)closeCreateTopicView:(UIViewController*)sender;

@end

@interface addTopicViewController : UIViewController<CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    
    
    UIImagePickerController *mediaPicker;
    UIImage* userImage;
    UIActionSheet *actionSheet;
    PFFile *imageFile;
    
}
@property (strong,nonatomic)UIViewController <createTopicViewProtocol> *delagate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *createTopicButton;

@property (strong, nonatomic) IBOutlet UITextField *topicTitleTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *topicDetailTextView;
@property CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)createTopic:(id)sender;
- (IBAction)cancelPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
- (IBAction)selectUserImage:(id)sender;

@end
