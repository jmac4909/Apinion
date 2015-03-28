//
//  homeTableViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 1/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "homeTableViewController.h"
#import "userInfoViewController.h"
#import "accountViewController.h"


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

        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [self.sidebarButton setTarget: self.revealViewController];
            [self.sidebarButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
            
            [self.view addGestureRecognizer:tap];
        }
        
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
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"First_Name" ascending:YES];
             
                
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
                
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Topic_Name" ascending:YES];
                
                
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
    NSLog(@"X: %f Y: %f",self.dataView
          .frame.origin.x,self.dataView.frame.origin.y);

    [self.addTopicView setFrame:CGRectMake(self.dataView.frame.size.width, 0, self.dataView.frame.size.width, self.dataView.frame.size.height)];
    
    
    [self.scrollView addSubview:self.addTopicView];

    

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
    
    
    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageRed.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageRed"]];
       [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageRed"]];
        
        color = [UIColor whiteColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageYellow.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        //Red color
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageBlue.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageBlue"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageBlue"]];
           self.tableView.separatorColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
        color = [UIColor whiteColor];
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageTan.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageTan"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageTan"]];
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
        
        self.tableView.separatorColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];
        
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImagePurple.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImagePurple"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImagePurple"]];
        color = [UIColor whiteColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
        
        
    }

    else{
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageYellow.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [self.dataViewImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        [self.addTopicImageView setImage:[UIImage imageNamed:@"dataViewBackgroundImageYellow"]];
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"VastShadow-Regular" size:30],
      NSFontAttributeName,
      color,NSForegroundColorAttributeName, nil]];
    //In "User"/"Topic" view
    self.userCountLabel.textColor = color;
    self.latitudeLabel.textColor = color;
    self.longitudeLabel.textColor = color;
    self.sidebarButton.tintColor = color;
    self.segmentedTopicsUsers.tintColor = color;
    //In Add Topic view
    [self.TopicButton setTitleColor:color forState:UIControlStateNormal];
    self.seporateImageView.backgroundColor = color;
    
    
    
    [self.navigationController.shyNavigationBar setToFullHeight:true];
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f",[self getdeviceLocation].latitude];
     self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %f",[self getdeviceLocation].longitude];
    

    self.userLocationMap.frame = f;
    
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
  
    
    
    if ([PFUser currentUser] == Nil) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    }else{

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
                        
                        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"First_Name" ascending:YES];
                        
                        
                        self.userDataArray= [NSMutableArray arrayWithArray:objects];
                        [self.userDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                        
                        self.userCountLabel.text = [NSString stringWithFormat:@"%lu users nearby",(unsigned long)self.userDataArray.count];
                        
                        if (viewingUsers == true) {
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
                            
                            NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Topic_Name" ascending:YES];
                            
                            
                            self.topicDataArray= [NSMutableArray arrayWithArray:objects];
                            [self.topicDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                            if (viewingUsers == false) {
                                self.tableViewData = self.topicDataArray;
                                [self.tableView reloadData];

                            }
                        }else{
                            NSLog(@"%@",[error userInfo]);
                        }
                    }];

            
        }
        }];
        
    
    



    }

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
        [[PFUser currentUser] setObject:[self getdeviceLocation] forKey:@"Last_Position"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFQuery *getPeople = [PFUser query];
                [getPeople whereKey:@"Last_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
                [getPeople findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        
                        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"First_Name" ascending:YES];
                        
                        
                        self.tableViewData= [NSMutableArray arrayWithArray:objects];
                        [self.tableViewData sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                        [self.refreshControl endRefreshing];
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
        
        
        //View Topics
        PFQuery *getTopic = [PFQuery queryWithClassName:@"Topics"];
        [getTopic whereKey:@"Created_Position" nearGeoPoint:[self getdeviceLocation] withinMiles:10.0];
        [getTopic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"Topic_Name" ascending:YES];
                
                
                self.topicDataArray= [NSMutableArray arrayWithArray:objects];
                [self.topicDataArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                self.tableViewData = self.topicDataArray;
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
                    
                
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
 
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 80;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return self.tableViewData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
 
    if (viewingUsers == true) {
        NSString *fullName = [[[[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"First_Name"] stringByAppendingString: @" "]stringByAppendingString:[[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"Last_Name"]];
        cell.textLabel.text = fullName;
        
        cell.detailTextLabel.text = [[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"School_Name"];
    }else{
        
        cell.textLabel.text = [[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"topic_Name"];
        cell.detailTextLabel.text = [[self.tableViewData objectAtIndex:indexPath.row]objectForKey:@"topic_Detail"];
    }
    


        
  
        
    


    
#warning Make this a one time check, it would be faster and more efficient
    
    

    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        NSLog(@"Here");

        //Red
        cell.detailTextLabel.textColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        
        
        //Red
        cell.detailTextLabel.textColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        

        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        //Blue
        cell.detailTextLabel.textColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        
        //Red
        cell.detailTextLabel.textColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
        
    }
    else{
        
        
        //Red
        cell.detailTextLabel.textColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
       
        
        
    }

    
    
    


    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedUserData = [self.tableViewData objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showUserPage" sender:self];
    
}

- (void)closeAccountView:(UIViewController*)sender;
{
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showUserPage"]) {
        
        userInfoViewController *userInfoViewControler = segue.destinationViewController;
        userInfoViewControler.selectedUserData = self.selectedUserData;
        
        if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
           
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:103/255.0f green:5/255.0f blue:3/255.0f alpha:1.0f];
            
        }
        else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
            
            
            //Red
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
            
        }
        else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
            //Blue
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
            
        }
        else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
            
            //Red
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
            
        }
        else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
            
            //Green
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];
            
        }
        else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
            
            //Green
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
            
        }
        else{

            
            //Red
            userInfoViewControler.userThemeColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
            
            
        }

    
    }
    if ([segue.identifier isEqualToString:@"openSettings"]) {
        
        accountViewController *accountView = (accountViewController *)[segue.destinationViewController topViewController];
        
        accountView.delagate = self;
        
        
    }
}



- (IBAction)segmentedValueDidChange:(id)sender {
    NSInteger selectedSegment = self.segmentedTopicsUsers.selectedSegmentIndex;

    
    if (selectedSegment == 0) {
        NSLog(@"Segmented 0");
        viewingUsers = true;
        self.tableViewData = self.userDataArray;
        [self.tableView reloadData];
        //View Users
            }
    else if (selectedSegment == 1){
        NSLog(@"Segmented 1");
        viewingUsers = false;

        self.tableViewData = self.topicDataArray;
        [self.tableView reloadData];
       
        
        
        
    }

}

- (IBAction)bananaButtonPress:(id)sender {

    

}
@end
