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
#import "addTopicViewController.h"
#import "Twitter/Twitter.h"
#import "MessageUI/MessageUI.h"


@interface homeTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,accountViewProtocol,MKMapViewDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,UISearchBarDelegate,createTopicViewProtocol>{
    
    
    CGRect searchScrollViewFrame;

    CGRect f;
    BOOL viewingUsers;
    float latestXTranslation;
    UIView *coverView;
    UIView *searchCoverView;
    UIImageView *searchSeporator;
    UIButton *homeDropButton;
    UIButton *profileDropButton;
    UIButton *favoritesDropButton;
 
    UITapGestureRecognizer *screenTap;
    UITapGestureRecognizer *screenSearchTap;

}
@property (strong, nonatomic) IBOutlet UIButton *TopicButton;
@property (strong, nonatomic) IBOutlet UIImageView *seporateImageView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedTopicsUsers;
@property CLLocationManager *locationManager;
@property NSMutableArray *userDataArray;
@property NSMutableArray *topicDataArray;
@property (strong, nonatomic) IBOutlet UIImageView *twitterBirdButton;
@property (strong, nonatomic) IBOutlet UIImageView *messageButton;

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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

 
@property NSMutableArray *searchTableViewData;
@property NSMutableArray *searchTableViewTopicData;


@property PFObject *alertFound;

@property PFObject *selectedUserData;
- (IBAction)pressTwitterButton:(id)sender;
- (IBAction)pressMessageButton:(id)sender;

- (IBAction)newTopic:(id)sender;

- (IBAction)segmentedValueDidChange:(id)sender;

- (IBAction)pressSearchButton:(id)sender;

@end
