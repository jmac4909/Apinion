//
//  addTopicViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 3/29/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface addTopicViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *topicTitleTextFeild;
@property (strong, nonatomic) IBOutlet UITextView *topicDetailTextView;
@property CLLocationManager *locationManager;

- (IBAction)createTopic:(id)sender;

@end
