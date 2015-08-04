//
//  homeTableViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 1/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "homeTableViewController.h"
#import "userInfoViewController.h"
#import "custonGroupTableViewController.h"

static CGFloat MKMapOriginHight = 175.f;


@interface homeTableViewController ()

@end

@implementation homeTableViewController
- (PFGeoPoint *)getdeviceLocation {
    return [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([PFUser currentUser] == Nil) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    }else{
        viewingUsers = true;
        
        self.userLocationMap.frame = CGRectMake(0, MKMapOriginHight, self.tableView.frame.size.width, MKMapOriginHight);
        [self.tableView insertSubview:self.userLocationMap belowSubview:self.dataView];
        self.tableView.contentInset = UIEdgeInsetsMake(MKMapOriginHight, 0, 0, 0);
        
        f = self.userLocationMap.frame;
        
      
        
    self.tableView.delegate = self;
    self.userLocationMap.delegate = self;

        
                 
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];

        }
    [self.locationManager startUpdatingLocation];
    
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
        
    self.refreshControl.tintColor = [UIColor colorWithRed:0.561 green:0 blue:0.169 alpha:1];
        
        
        
        
    
    



    
    NSString *userIdString = [@"A" stringByAppendingString:[PFUser currentUser].objectId];
    NSArray *subcribtionArray = @[userIdString];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];

    
    
    [[PFUser currentUser] setObject:[self getdeviceLocation] forKey:@"Last_Position"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        PFQuery *getPeople = [PFUser query];
        [getPeople whereKey:@"Last_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
        [getPeople findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Object_FirstName" ascending:YES];
             
                
                self.userDataArray= [NSMutableArray arrayWithArray:objects];
                   [self.userDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [self.tableView reloadData];
            }else{
                NSLog(@"%@",[error userInfo]);
            }
        }];
        }else{
            NSLog(@"%@",[error userInfo]);
        }
    }];




        //View Topics
        PFQuery *getTopic = [PFQuery queryWithClassName:@"Topics"];
        [getTopic whereKey:@"Created_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
        [getTopic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Object_FirstName" ascending:YES];
                
                
                self.topicDataArray= [NSMutableArray arrayWithArray:objects];
                [self.topicDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }else{
                NSLog(@"%@",[error userInfo]);
            }
        }];

    }
    
    self.scrollView.contentSize = CGSizeMake(750, 40);

    [self.addTopicView setFrame:CGRectMake(self.dataView.frame.size.width, 0, self.dataView.frame.size.width, self.dataView.frame.size.height)];
    
    
    [self.scrollView addSubview:self.addTopicView];

    [self.scrollViewImageView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    self.scrollViewImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollViewImageView];
    
    [self.view sendSubviewToBack:self.scrollViewImageView];
    
 

     self.dropDownMenuView.userInteractionEnabled = true;
    homeDropButton = [[UIButton alloc]init];
    [homeDropButton addTarget:self action:@selector(homeButtonPress) forControlEvents:UIControlEventTouchUpInside];
    homeDropButton.userInteractionEnabled = true;
    
    favoritesDropButton = [[UIButton alloc]init];
    [favoritesDropButton addTarget:self action:@selector(favoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    favoritesDropButton.userInteractionEnabled = true;

    profileDropButton = [[UIButton alloc]init];
    [profileDropButton addTarget:self action:@selector(profileButtonPress) forControlEvents:UIControlEventTouchUpInside];
    profileDropButton.userInteractionEnabled = true;
    

  
     self.dropDownMenuView.userInteractionEnabled = YES;

    self.tableView.canCancelContentTouches = YES;
    
     screenTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(tapScreen:)];

    screenSearchTap = [[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(tapSearchScreen:)];
    [screenTap setCancelsTouchesInView:NO];
    [screenSearchTap setCancelsTouchesInView:NO];
    

    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    
    coverView.backgroundColor = [UIColor blackColor];
    [coverView setAlpha:0.4];
    
    searchCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    
    searchCoverView.backgroundColor = [UIColor blackColor];
    [searchCoverView setAlpha:0.4];
    
        [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - self.searchBar.frame.size.height, self.tableView.frame.size.width,self.searchBar.frame.size.height)];
    self.searchBar.hidden = true;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.userInteractionEnabled = true;
    self.searchBar.delegate = self;
    
    self.searchTableView.delegate = self;
    
    CGRect searchFrame = [self.navigationController.navigationBar convertRect:self.searchBar.frame toView:self.view];
    
 
    [self.searchTableView setFrame:CGRectMake(0,-self.userLocationMap.frame.size.height + 46, searchFrame.size.width, self.tableView.frame.size.height + -self.userLocationMap.frame.size.height + 46 + [UIApplication sharedApplication].statusBarFrame.size.height)];
    
 

    searchSeporator = [[UIImageView alloc]initWithFrame:CGRectMake(0,-self.userLocationMap.frame.size.height + 44 , self.searchTableView.frame.size.width, 2)];
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];

    [txfSearchField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self.tableView touchesShouldCancelInContentView:self.searchTableView];
    searchScrollViewFrame = self.searchTableView.frame;
    
    
    
    
}

- (void)tapSearchScreen:(id)sender {
 
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
     txfSearchField.clearButtonMode =UITextFieldViewModeNever;
     CGPoint tapPoint = [sender locationInView:self.view];
    
    CGRect searchFrame = [self.navigationController.navigationBar convertRect:self.searchBar.frame toView:self.view];
 
 
 

    if (CGRectContainsPoint(searchFrame, tapPoint)) {
         [self.searchBar becomeFirstResponder];
        
 
        
        return;
    }}

- (void)tapScreen:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    
    CGRect homeFrame = [self.dropDownMenuView convertRect:homeDropButton.frame toView:self.view];
    

    
    if (CGRectContainsPoint(homeFrame, tapPoint)) {
        [self homeButtonPress];
         return;
    }
    CGRect profileFrame = [self.dropDownMenuView convertRect:profileDropButton.frame toView:self.view];
    if (CGRectContainsPoint(profileFrame, tapPoint)) {
        [self profileButtonPress];
        return;
    }
    CGRect favoriteFrame = [self.dropDownMenuView convertRect:favoritesDropButton.frame toView:self.view];
    if (CGRectContainsPoint(favoriteFrame, tapPoint)) {
        [self favoriteButtonPress];
        return;
    }
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [mapView setRegion:mapRegion animated: YES];
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f",[self getdeviceLocation].latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %f",[self getdeviceLocation].longitude];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      //Red color
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    
    
    //Gets the color the navigationBar should be

    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageRed.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageRed"]];
       [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageRed"]];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageRed"]];
        
        
        color = [UIColor whiteColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageYellow.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        
        
        //Red color
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageBlue.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageBlue"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageBlue"]];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageBlue"]];
        
        
           self.tableView.separatorColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
        color = [UIColor whiteColor];
        
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];

        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageTan.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageTan"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageTan"]];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageTan"]];
        
    

        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBirdBlue"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messagesIconGreen"]];
        
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
           self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageGreen.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageGreen"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageGreen"]];
        color = [UIColor whiteColor];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageGreen"]];
        
        
        
        self.tableView.separatorColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];
        
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImagePurple.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImagePurple"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImagePurple"]];
        color = [UIColor whiteColor];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImagePurple"]];
        
        
        
        self.tableView.separatorColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];
        
    }   else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Grey"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageGrey.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageGrey"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageGrey"]];
        color = [UIColor whiteColor];
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageGrey"]];
        
        
        
        self.tableView.separatorColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];
        
    }

    else{
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageYellow.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        
        
        
        [self.scrollViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        
        
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        [self.twitterBirdButton setImage:[UIImage imageNamed:@"twitterBird"]];
        [self.messageButton setImage:[UIImage imageNamed:@"messageIcon"]];
        
    }
    
    self.searchBar.tintColor = [self getUserColor];
    self.searchButton.tintColor = [self getUserColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Copperplate-Bold" size:30],
      NSFontAttributeName,
      color,NSForegroundColorAttributeName, nil]];
    //In "User"/"Topic" view
    self.userCountLabel.textColor = color;
    self.latitudeLabel.textColor = color;
    self.longitudeLabel.textColor = color;
    self.sidebarButton.tintColor = color;
    self.segmentedTopicsUsers.tintColor = [self getSegmentedColor];
     //In Add Topic view
    [self.TopicButton setTitleColor:color forState:UIControlStateNormal];
    self.seporateImageView.backgroundColor = color;
    
    
    
    [self.navigationController.shyNavigationBar setToFullHeight:true];
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f",[self getdeviceLocation].latitude];
     self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %f",[self getdeviceLocation].longitude];
    

    self.userLocationMap.frame = f;
    
    
    
    [searchSeporator setBackgroundColor:[self getUserColor]];
    
    self.userLocationMap.tintColor = [self getUserColor];
    [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - (MKMapOriginHight), self.tableView.frame.size.width, MKMapOriginHight - (MKMapOriginHight /6))];

    
    self.navigationController.navigationBar.userInteractionEnabled = true;
    [self.navigationController.navigationBar insertSubview:self.dropDownMenuView atIndex:0];
       [self.navigationController.navigationBar insertSubview:self.searchBar atIndex:0];
    self.dropDownMenuView.hidden = true;
    
    
    [homeDropButton setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, (self.dropDownMenuView.frame.size.height/3))];
    [homeDropButton setBackgroundColor:[UIColor whiteColor]];
    [homeDropButton setTitle:@"  Home" forState:UIControlStateNormal];
    [self.dropDownMenuView addSubview:homeDropButton];
    
    [homeDropButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [homeDropButton setImage:[UIImage imageNamed:@"homeIcon"] forState:UIControlStateNormal];

  
    
    
    [profileDropButton setFrame:CGRectMake(0, homeDropButton.frame.size.height*2, self.tableView.frame.size.width, (self.dropDownMenuView.frame.size.height/3))];
    
    [profileDropButton setBackgroundColor:[UIColor whiteColor]];
    [profileDropButton setTitle:@"    Profile" forState:UIControlStateNormal];
    [profileDropButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [profileDropButton setImage:[UIImage imageNamed:@"profileIcon"] forState:UIControlStateNormal];
    
    [self.dropDownMenuView addSubview:profileDropButton];
    
    
    
    [favoritesDropButton setFrame:CGRectMake(0, homeDropButton.frame.size.height, self.tableView.frame.size.width, (self.dropDownMenuView.frame.size.height/3))];
    
    
    [favoritesDropButton setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
    [favoritesDropButton setTitle:@"  Favorites" forState:UIControlStateNormal];
    [favoritesDropButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [favoritesDropButton setImage:[UIImage imageNamed:@"FavoriteStar"] forState:UIControlStateNormal];
    
    [self.dropDownMenuView addSubview:favoritesDropButton];
    
    
    
    self.dropDownMenuView.userInteractionEnabled = true;

    [self.searchTableView reloadData];
    [searchCoverView setAlpha:0.4];
    [coverView setAlpha:0.4];


    if (self.searchBar.hidden == false) {
        self.tableView.scrollEnabled = false;
        self.tableView.allowsSelection = NO;
        self.userLocationMap.userInteractionEnabled = NO;
        self.scrollView.scrollEnabled = false;

    }
 

}


- (UIColor *)getUserColor{
    UIColor *returnColor = [UIColor colorWithRed:103/255.0f green:5/255.0f blue:3/255.0f alpha:1.0f];
    
    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        
        returnColor = [UIColor colorWithRed:103/255.0f green:5/255.0f blue:3/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        
        
        //Red
        returnColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        //Blue
        returnColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        
        //Red
        returnColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
        
        //Green
        returnColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        
        //Green
        returnColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Grey"]) {
        
        //Grey
        returnColor = [UIColor blackColor];
        
    }
    else{
        
        
        //Red
        returnColor  = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
    }
    return returnColor;

}
- (UIColor *)getSegmentedColor{
    UIColor *returnColor = [UIColor colorWithRed:103/255.0f green:5/255.0f blue:3/255.0f alpha:1.0f];
    
    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        
        returnColor = [UIColor colorWithRed:121/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        
        
        //Red
        returnColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        //Blue
        returnColor = [UIColor colorWithRed:39/255.0f green:55/255.0f blue:120/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        
        //Red
        returnColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
        
        //Green
        returnColor = [UIColor colorWithRed:0/255.0f green:53/255.0f blue:0/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        
        //Green
        returnColor = [UIColor colorWithRed:50/255.0f green:0/255.0f blue:75/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Grey"]) {
        
        //Grey
        returnColor = [UIColor blackColor];
        
    }
    else{
        
        
        //Red
        returnColor  = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
    }
    return returnColor;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    
    if ([PFUser currentUser] == Nil) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    }else{
        
    [self.navigationController.shyNavigationBar setToFullHeight:true];
    //gets any alerts
    PFQuery *alertQuery = [PFQuery queryWithClassName:@"Alerts"];
    [alertQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (int x = 0; x <= objects.count; x ++) {
        
            self.alertFound = [objects objectAtIndex:x];

        if (![[self.alertFound objectForKey:@"userIdHaveSeen"] containsObject:[PFUser currentUser].objectId]) {
            
            [self showAlert:self.alertFound];
            
            [self.alertFound addObject:[PFUser currentUser].objectId forKey:@"userIdHaveSeen"];
            [self.alertFound saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
            }];
        }
        
    }
     
    }
    ];

    

        
        //set current application version
        [[PFUser currentUser]setObject:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] forKey:@"currentAppVersion"];
        

        //Gets nearby users
        [[PFUser currentUser] setObject:[self getdeviceLocation] forKey:@"Last_Position"];
    
        PFQuery *findMetadata = [PFQuery queryWithClassName:@"userMetaData"];

        [findMetadata whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
        [findMetadata getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [object setObject:[self getdeviceLocation] forKey:@"Last_Position"];
            [object saveInBackground];
        }];
    
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                
                PFQuery *getPeople = [PFUser query];
                [getPeople whereKey:@"Last_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
                [getPeople findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        
                        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Object_FirstName" ascending:YES];
                        
                        
                        self.userDataArray= [NSMutableArray arrayWithArray:objects];
                        [self.userDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                        
                        
                        
                        if (viewingUsers == true) {
                            self.userCountLabel.text = [NSString stringWithFormat:@"%lu users nearby",(unsigned long)self.userDataArray.count];
                            self.tableViewData = self.userDataArray;
                            [self.tableView reloadData];

                        }
                        }else{
                        NSLog(@"%@",[error userInfo]);
                        }
                }];
                    //Not looking at users

                    //View Topics
                    PFQuery *getTopic = [PFQuery queryWithClassName:@"Topics"];
                    [getTopic whereKey:@"Created_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
                    [getTopic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            
                            NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Object_FirstName" ascending:YES];
                            
                            
                            self.topicDataArray= [NSMutableArray arrayWithArray:objects];
                            [self.topicDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                            if (viewingUsers == false) {
                                self.userCountLabel.text = [NSString stringWithFormat:@"%lu topics nearby",(unsigned long)self.topicDataArray.count];
                                self.tableViewData = self.topicDataArray;
                                [self.tableView reloadData];

                            }
                        }else{
                            NSLog(@"%@",[error userInfo]);
                        }
                    }];

            
        }
        }];
        
    
         NSNumber *number = [[PFUser currentUser]objectForKey:@"hasSeenHomeTutorial"];
        
        if (number.intValue != 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Welcome" message:@"Thanks for instaling Apinion, if you would like to add your own topic to your area just swipe across the \"Users Nearby\" bar" delegate:self cancelButtonTitle:@"Will Do" otherButtonTitles:nil, nil];
            [alert show];
            [[PFUser currentUser]setObject:[NSNumber numberWithInt:1] forKey:@"hasSeenHomeTutorial"];
            [[PFUser currentUser]saveInBackground];
            
            
        }



    }

}

- (void)viewWillLayoutSubviews{
    [self.segmentedTopicsUsers setFrame:CGRectMake(self.segmentedTopicsUsers.frame.origin.x, 0, self.segmentedTopicsUsers.frame.size.width, self.dataView.frame.size.height)];
    
    [self.segmentedTopicsUsers setTitleTextAttributes:@{
                                           NSForegroundColorAttributeName:[UIColor whiteColor]}
                                forState:UIControlStateSelected];
    
    

}
#pragma mark - Scroll View Delagates



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (yOffset < -MKMapOriginHight) {

        
        CGFloat statusBarOffset = [[UIApplication sharedApplication] statusBarFrame].size.height;
        if (statusBarOffset <= 20) {

            f = self.userLocationMap.frame;
            f.origin.y = yOffset + self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
            f.size.height =  -yOffset - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
            self.userLocationMap.frame = f;
        }else{

            
            f = self.userLocationMap.frame;
            f.origin.y = yOffset + self.navigationController.navigationBar.frame.size.height + 0;
            f.size.height =  -yOffset - self.navigationController.navigationBar.frame.size.height - 0;
            self.userLocationMap.frame = f;
            
        }
        
        
    }

    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTableView {
    if (viewingUsers == true) {
        
        self.segmentedTopicsUsers.enabled = false;
        [[PFUser currentUser] setObject:[self getdeviceLocation] forKey:@"Last_Position"];
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFQuery *getPeople = [PFUser query];
                [getPeople whereKey:@"Last_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
                [getPeople findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        
                        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Object_FirstName" ascending:YES];
                        
                        
                        self.userDataArray= [NSMutableArray arrayWithArray:objects];
                        [self.userDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                        
                        
                        
                        self.tableViewData= [NSMutableArray arrayWithArray:self.userDataArray];
                        
                      

                        [self.refreshControl endRefreshing];
                        self.segmentedTopicsUsers.enabled = true;
                        self.userCountLabel.text = [NSString stringWithFormat:@"%lu users nearby",(unsigned long)objects.count];
                        [self.tableView reloadData];

                    }else{
                        NSLog(@"%@",[error userInfo]);
                    }
                }];
            }else{
                NSLog(@"%@",[error userInfo]);
                [self.refreshControl endRefreshing];
            }
        }];

    }else if (viewingUsers == false){
        
        self.segmentedTopicsUsers.enabled = false;

        //View Topics
        PFQuery *getTopic = [PFQuery queryWithClassName:@"Topics"];
        [getTopic whereKey:@"Created_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
        [getTopic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Object_FirstName" ascending:YES];
                
                
                self.topicDataArray= [NSMutableArray arrayWithArray:objects];
                [self.topicDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                self.tableViewData = self.topicDataArray;
                [self.tableView reloadData];

                [self.refreshControl endRefreshing];
                
                
                self.userCountLabel.text = [NSString stringWithFormat:@"%lu topics nearby",(unsigned long)self.topicDataArray.count];

                
                self.segmentedTopicsUsers.enabled = true;

            }
        }];
        

        
        
    }

    
}



- (void)showAlert: (PFObject *)alertObject {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[self.alertFound objectForKey:@"alertTitle"] message:[self.alertFound objectForKey:@"infoText"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}
#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    if (tableView.tag == 1) {
        return nil;
    }
    if (tableView.tag == 2) {
        if (section == 0) {
            return @"Users";
            
        }else if (section == 1){
            return @"Topics";
        }
    }
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 80;
    }
    if (tableView.tag == 2) {
        return 44;
    }
         return 80;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (tableView.tag == 1) {
        return 1;
    }
    if (tableView.tag == 2) {
        if (self.searchBar.text.length == 0) {
            return 0;
        }else{
            return 2;
        }
        
        
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView.tag == 1) {
        return self.tableViewData.count;
    }
    if (tableView.tag == 2) {
        if (section == 0) {
            return self.searchTableViewData.count;

        }else if (section == 1){
            return self.searchTableViewTopicData.count;
        }
    }
    return self.tableViewData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (tableView.tag == 1) {
     
    
    
    cell.backgroundColor = [UIColor whiteColor];
        
         
        
 
    if (viewingUsers == true) {
        NSString *fullName = [[[[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"Object_FirstName"] stringByAppendingString: @" "]stringByAppendingString:[[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"Object_LastName"]];
        cell.textLabel.text = fullName;
        
        cell.detailTextLabel.text = [[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"School_Name"];
    }else{
        
        cell.textLabel.text = [[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"Object_FirstName"];
        cell.detailTextLabel.text = [[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"topic_Detail"];
    }
    


    

        
    cell.detailTextLabel.textColor = [self getUserColor];
    

    return cell;
    
    }
    
    
    if (tableView.tag == 2) {
        if (indexPath.section == 0) {
            if (self.searchBar.text.length > 0) {
                
                
                     NSString *fullName = [[[[self.searchTableViewData objectAtIndex:indexPath.row]objectForKey:@"Object_FirstName"] stringByAppendingString: @" "]stringByAppendingString:[[self.searchTableViewData objectAtIndex:indexPath.row]objectForKey:@"Object_LastName"]];
                    cell.textLabel.text = fullName;
                    
                    cell.detailTextLabel.text = [[self.searchTableViewData objectAtIndex:indexPath.row]objectForKey:@"School_Name"];
                
                
                cell.detailTextLabel.textColor = [self getUserColor];
                
                return cell;
                
            }
        }else if (indexPath.section == 1){
            
            
            
            if (self.searchBar.text.length > 0) {
                
                
                
                    cell.textLabel.text = [[self.searchTableViewTopicData objectAtIndex:indexPath.row]objectForKey:@"Object_FirstName"];
                    cell.detailTextLabel.text = [[self.searchTableViewTopicData objectAtIndex:indexPath.row]objectForKey:@"topic_Detail"];
                
                
                cell.detailTextLabel.textColor = [self getUserColor];
                
                return cell;
                
            }
        }

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (tableView.tag == 1) {
     
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (viewingUsers == true) {
        
    
    self.selectedUserData = [self.tableViewData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showUserPage" sender:self];
        
    }else if (viewingUsers == false){
        self.selectedUserData = [self.topicDataArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showUserPage" sender:self];

    }
    }
    
    
    if (tableView.tag == 2) {
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section == 0) {
            
            
            self.selectedUserData = [self.searchTableViewData objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"showUserPage" sender:self];
 
            
        }else if (indexPath.section == 1){
            self.selectedUserData = [self.searchTableViewTopicData objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"showUserPage" sender:self];
            
        }
        
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return 0.0;
        
    }
    return  20.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:14]];
//    [label setTextColor:[UIColor whiteColor]];
//    NSString *string;
//
//    if (section == 0) {
//        string = @"Users";
//    }else if (section == 1){
//        string = @"Topics";
//    }
//    /* Section header is in 0th index... */
//    [label setText:string];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    return view;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    //Top image view
    UIImageView *topImageView= [[ UIImageView alloc]initWithFrame:CGRectMake(0,0, label.frame.size.width, 1)];
    [topImageView setBackgroundColor:[self getUserColor]];
    //underline Image view
    UIImageView *underlineImageView= [[ UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, label.frame.size.width, 1)];
    [underlineImageView setBackgroundColor:[self getUserColor]];
    
    NSString *string;
        if (section == 0) {
            string = @"Users";
        }else if (section == 1){
            string = @"Topics";
        }
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view addSubview:topImageView];

    [view addSubview:underlineImageView];

    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;

    
    
    
}



- (void)closeAccountView:(UIViewController*)sender;
{
     [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)closeCreateTopicView:(UIViewController*)sender{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.dropDownMenuView removeFromSuperview];
    [self.searchBar removeFromSuperview];

    self.dropDownMenuView.hidden = true;
    self.tableView.scrollEnabled = true;
    self.userLocationMap.userInteractionEnabled = YES;
    
    self.tableView.allowsSelection = YES;
    self.segmentedTopicsUsers.enabled = YES;
    
    [coverView removeFromSuperview];
    [coverView setAlpha:0.4];
    self.scrollView.scrollEnabled = true;
    
    [self.view removeGestureRecognizer:screenTap];
 

     // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFavorite"]) {
        
    }
    if ([segue.identifier isEqualToString:@"showUserPage"]) {
        
        userInfoViewController *userInfoViewControler = segue.destinationViewController;
        userInfoViewControler.selectedUserData = self.selectedUserData;
        
        userInfoViewControler.userThemeColor = [self getUserColor];

    
    }
    if ([segue.identifier isEqualToString:@"showSettings1"]) {
        
        accountViewController *accountView = (accountViewController *)[segue.destinationViewController topViewController];
        
        accountView.delagate = self;
 
        accountView.userThemeColor = [self getUserColor];
        
        
    }
    if ([segue.identifier isEqualToString:@"showFavorite"]) {
        custonGroupTableViewController *customGroupView = (custonGroupTableViewController *)[segue.destinationViewController topViewController];
        
        customGroupView.userThemeColor = [self getUserColor];
        
        
        

    }
    if ([segue.identifier isEqualToString:@"showAddTopicView"]) {
        
        addTopicViewController *addTopicView = (addTopicViewController *)[segue.destinationViewController topViewController];
        
        addTopicView.delagate = self;

        
        
    }
}
#pragma mark

-(void)homeButtonPress{
    [self performSegueWithIdentifier:@"showHome1" sender:self];
}
-(void)profileButtonPress{
    [self performSegueWithIdentifier:@"showSettings1" sender:self];

    
}
-(void)favoriteButtonPress{
    [self performSegueWithIdentifier:@"showFavorite" sender:self];
    
}
#pragma mark

-(void)dropSearch{
    if (self.dropDownMenuView.hidden == false) {
        [self hideDrop];
    }
    
    if (self.searchBar.hidden == true) {
        
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        
        [self.view addGestureRecognizer:screenSearchTap];
        
        self.searchBar.hidden = false;
        
        [UIView animateWithDuration:.3 animations:^{
            
            [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.tableView.frame.size.width,self.searchBar.frame.size.height)];
            
            
            [self.navigationController.navigationBar insertSubview:searchCoverView belowSubview:self.searchBar];
            self.segmentedTopicsUsers.enabled = NO;
            
            [searchCoverView setAlpha:0.4];
        } completion:^(BOOL finished) {
            self.tableView.scrollEnabled = false;
            self.tableView.allowsSelection = NO;
            self.userLocationMap.userInteractionEnabled = NO;
            self.scrollView.scrollEnabled = false;
            [searchCoverView setAlpha:0.4];
            
            
        }];
        
        
    }else{
        
        
        
        [UIView animateWithDuration:.3 animations:^{
            
            [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - self.searchBar.frame.size.height, self.tableView.frame.size.width,self.searchBar.frame.size.height)];
            
            
            [searchCoverView setAlpha:0.0];
            [self.searchBar setAlpha:0.0];
            [self.searchTableView setAlpha:0.0];
            [searchSeporator setAlpha:0.0];
            
        } completion:^(BOOL finished) {
            [self.searchTableView removeFromSuperview];
            [searchSeporator removeFromSuperview];
            [self.searchBar setAlpha:1.0];
            [self.searchTableView setAlpha:1.0];
            [searchSeporator setAlpha:1.0];
            [self.searchTableViewData removeAllObjects];
            [self.searchTableViewTopicData removeAllObjects];
            [self.searchTableView reloadData];
            self.searchBar.text = @"";
            [self.searchBar resignFirstResponder];
            
            self.searchBar.hidden = true;
            self.tableView.scrollEnabled = true;
            self.userLocationMap.userInteractionEnabled = YES;
            
            self.tableView.allowsSelection = YES;
            self.segmentedTopicsUsers.enabled = YES;
            
            [searchCoverView removeFromSuperview];
            [searchCoverView setAlpha:0.4];
            self.scrollView.scrollEnabled = true;
            
            self.scrollView.scrollEnabled = true;
            
            [self.view removeGestureRecognizer:screenSearchTap];
            
        }];
        
        
    }

    
}
-(void)dropMenu{
    
    if (self.searchBar.hidden == false) {
        [self hideSearch];
    }
     if (self.dropDownMenuView.hidden == true) {
         

         
         
         self.dropDownMenuView.hidden = false;
         [self.view addGestureRecognizer:screenTap];

    [UIView animateWithDuration:.3 animations:^{
        
        [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.tableView.frame.size.width, (MKMapOriginHight - (MKMapOriginHight/6)))];
        
        [self.navigationController.navigationBar insertSubview:coverView belowSubview:self.dropDownMenuView];

        [coverView setAlpha:0.4];

        self.segmentedTopicsUsers.enabled = NO;

    } completion:^(BOOL finished) {
  

        self.tableView.scrollEnabled = false;
        self.tableView.allowsSelection = NO;
        self.userLocationMap.userInteractionEnabled = NO;
        self.scrollView.scrollEnabled = false;
        [coverView setAlpha:0.4];


    }];
    
        
    }else{
        
  
 
        [UIView animateWithDuration:.3 animations:^{
            
            [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - self.userLocationMap.frame.size.height , self.tableView.frame.size.width, (MKMapOriginHight - (MKMapOriginHight/3)))];
            [coverView setAlpha:0.0];
            
        } completion:^(BOOL finished) {
            self.dropDownMenuView.hidden = true;
            self.tableView.scrollEnabled = true;
            self.userLocationMap.userInteractionEnabled = YES;

            self.tableView.allowsSelection = YES;
            self.segmentedTopicsUsers.enabled = YES;

            [coverView removeFromSuperview];
            [coverView setAlpha:0.4];
            self.scrollView.scrollEnabled = true;

            [self.view removeGestureRecognizer:screenTap];

         }];

        
    }
}
- (IBAction)pressDropDownButton:(id)sender {
    [searchCoverView removeFromSuperview];

    [self dropMenu];

}

- (IBAction)pressTwitterButton:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitter = [[SLComposeViewController alloc]init];
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitter setInitialText:@"Share your Apinion with me using \"Apinion\" on the App Store! @ApinionOfficial"];
         
        [self presentViewController:twitter animated:YES completion:^{
            
        }];

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Looks like Twitter is not avalible on your device. Please check your settings and try again :)" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}

- (IBAction)pressMessageButton:(id)sender {
    
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc]init];
    message.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        message.body = @"Share your Apinion with me using \"Apinion\" on the App Store";
        [self presentViewController:message animated:YES completion:^{
            
        }];
        
    }
}

- (IBAction)newTopic:(id)sender {
    
    [self performSegueWithIdentifier:@"showAddTopicView" sender:self];
    
}

- (IBAction)segmentedValueDidChange:(id)sender {
    NSInteger selectedSegment = self.segmentedTopicsUsers.selectedSegmentIndex;

    
    if (selectedSegment == 0) {
        viewingUsers = true;
        self.tableViewData = self.userDataArray;
        [self.tableView reloadData];
        
        self.userCountLabel.text = [NSString stringWithFormat:@"%lu users nearby",(unsigned long)self.userDataArray.count];
        //View Users
            }
    else if (selectedSegment == 1){
        viewingUsers = false;
        self.tableViewData = self.topicDataArray;
        
        [self.tableView reloadData];
       self.userCountLabel.text = [NSString stringWithFormat:@"%lu topics nearby",(unsigned long)self.topicDataArray.count];
        
        
        
    }

}
#pragma mark - Search Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchCoverView removeFromSuperview];
    self.tableView.scrollEnabled = false;
    self.tableView.allowsSelection = NO;
    [self.view insertSubview:self.searchTableView aboveSubview:searchCoverView];
    [self.view insertSubview:searchSeporator aboveSubview:self.searchTableView];
    
    

}

- (void)textFieldDidChange:(id)sender{
    NSString *searchText = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
 
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Object_FullName beginswith[c] %@", searchText];
    self.searchTableViewData = [NSMutableArray arrayWithArray:[self.userDataArray filteredArrayUsingPredicate:resultPredicate]];
    
    NSPredicate *userNameresultPredicate = [NSPredicate predicateWithFormat:@"username beginswith[c] %@", searchText];
    NSMutableArray *userNameArray = [NSMutableArray arrayWithArray:[self.userDataArray filteredArrayUsingPredicate:userNameresultPredicate]];
    
    NSPredicate *lastNameresultPredicate = [NSPredicate predicateWithFormat:@"Object_LastName beginswith[c] %@", searchText];
    NSMutableArray *lastNameArray = [NSMutableArray arrayWithArray:[self.userDataArray filteredArrayUsingPredicate:lastNameresultPredicate]];
    
    for (id object in userNameArray) {
        if (![self.searchTableViewData containsObject:object]) {
            [self.searchTableViewData addObject:object];
        }
    }
    for (id object in lastNameArray) {
        if (![self.searchTableViewData containsObject:object]) {
            [self.searchTableViewData addObject:object];
        }
    }
    
    
    NSPredicate *resultTopicPredicate = [NSPredicate predicateWithFormat:@"Object_FullName beginswith[c] %@", searchText];
    self.searchTableViewTopicData = [NSMutableArray arrayWithArray:[self.topicDataArray filteredArrayUsingPredicate:resultTopicPredicate]];
    
    NSPredicate *userNameTopicResultPredicate = [NSPredicate predicateWithFormat:@"username beginswith[c] %@", searchText];
    NSMutableArray *userNameTopicArray = [NSMutableArray arrayWithArray:[self.topicDataArray filteredArrayUsingPredicate:userNameTopicResultPredicate]];
    
    NSPredicate *lastNameTopicResultPredicate = [NSPredicate predicateWithFormat:@"Object_LastName beginswith[c] %@", searchText];
    NSMutableArray *lastNameTopicArray = [NSMutableArray arrayWithArray:[self.topicDataArray filteredArrayUsingPredicate:lastNameTopicResultPredicate]];
    
    for (id object in userNameTopicArray) {
        if (![self.searchTableViewTopicData containsObject:object]) {
            [self.searchTableViewTopicData addObject:object];
        }
    }
    for (id object in lastNameTopicArray) {
        if (![self.searchTableViewTopicData containsObject:object]) {
            [self.searchTableViewTopicData addObject:object];
        }
    }
    
    
    [self.searchTableView reloadData];



}


   
- (IBAction)pressSearchButton:(id)sender {
    [coverView removeFromSuperview];

    [self dropSearch];
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    
}
- (void)messageComposeViewController:(nonnull MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)hideSearch{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - self.searchBar.frame.size.height, self.tableView.frame.size.width,self.searchBar.frame.size.height)];
        
        
        [searchCoverView setAlpha:0.0];
        [self.searchBar setAlpha:0.0];
        [self.searchTableView setAlpha:0.0];
        [searchSeporator setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        [self.searchTableView removeFromSuperview];
        [searchSeporator removeFromSuperview];
        [self.searchBar setAlpha:1.0];
        [self.searchTableView setAlpha:1.0];
        [searchSeporator setAlpha:1.0];
        [self.searchTableViewData removeAllObjects];
        [self.searchTableViewTopicData removeAllObjects];
        [self.searchTableView reloadData];
        self.searchBar.text = @"";
        [self.searchBar resignFirstResponder];
        
        self.searchBar.hidden = true;
        
        
        [searchCoverView removeFromSuperview];
        [searchCoverView setAlpha:0.4];
        
        [self.view removeGestureRecognizer:screenSearchTap];

        
    }];

    
}
-(void)hideDrop{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - self.userLocationMap.frame.size.height , self.tableView.frame.size.width, (MKMapOriginHight - (MKMapOriginHight/3)))];
        [coverView setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        self.dropDownMenuView.hidden = true;
        [coverView removeFromSuperview];
        [coverView setAlpha:0.4];
        [self.view removeGestureRecognizer:screenTap];

    }];
    
    

    
}
@end
