//
//  addTopicViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 3/29/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface addTopicViewController : UIViewController<CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    
    UIImagePickerController *mediaPicker;
    UIImage* userImage;
    UIActionSheet *actionSheet;
    PFFile *imageFile;
    
}
@property (strong, nonatomic) IBOutlet UITextField *topicTitleTextFeild;
@property (strong, nonatomic) IBOutlet UITextView *topicDetailTextView;
@property CLLocationManager *locationManager;

- (IBAction)createTopic:(id)sender;
- (IBAction)cancelPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
- (IBAction)selectUserImage:(id)sender;

@end
