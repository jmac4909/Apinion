//
//  homeTableViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 1/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "accountViewController.h"
#import <MapKit/MapKit.h>

@interface homeTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,accountViewProtocol,MKMapViewDelegate,UIScrollViewDelegate>{
    
    CGRect f;
    BOOL viewingUsers;
    float latestXTranslation;
    UIView *coverView;
    UIButton *homeDropButton;
    UIButton *profileDropButton;
    UIButton *favoritesDropButton;
    UITapGestureRecognizer *screenTap;
}
@property (strong, nonatomic) IBOutlet UIButton *TopicButton;
@property (strong, nonatomic) IBOutlet UIImageView *seporateImageView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedTopicsUsers;
@property CLLocationManager *locationManager;
@property NSMutableArray *userDataArray;
@property NSMutableArray *topicDataArray;

@property NSMutableArray *tableViewData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong,nonatomic) IBOutlet MKMapView *userLocationMap;
@property (strong, nonatomic) IBOutlet UILabel *userCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) IBOutlet UIView *addTopicView;
@property (strong, nonatomic) IBOutlet UIImageView *addTopicImageView;
@property (strong, nonatomic) IBOutlet UIImageView *dataViewImageView;
@property (strong, nonatomic) IBOutlet UIImageView *scrollViewImageView;
@property (strong, nonatomic) IBOutlet UIView *dropDownMenuView;

           
@property PFObject *alertFound;

@property PFObject *selectedUserData;
- (IBAction)pressTwitterButton:(id)sender;
- (IBAction)pressMessageButton:(id)sender;

- (IBAction)newTopic:(id)sender;

- (IBAction)segmentedValueDidChange:(id)sender;

- (IBAction)bananaButtonPress:(id)sender;

@end
