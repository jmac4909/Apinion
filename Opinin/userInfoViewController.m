//
//  userInfoViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 1/12/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "userInfoViewController.h"

@interface userInfoViewController ()

@end

@implementation userInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
         
//    //Red
//    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
//    //Blue
//    color = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
    // Do any additional setup after loading the view.


    [self.view bringSubviewToFront:self.toolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
   
    
    
    NSString *userIdString = [@"A" stringByAppendingString:[PFUser currentUser].objectId];
    NSArray *subcribtionArray = @[userIdString];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];

    self.tableView.delegate = self;

    
    
    selectedCellIArray = [[NSMutableArray alloc]init];


 
    
    self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2;
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 2.0f;

    
    self.userPhotoImageView.layer.borderColor = self.userThemeColor.CGColor;
    
 
    self.reportButton.layer.borderWidth = 1.0f;
    self.reportButton.layer.borderColor = self.userThemeColor.CGColor;
    

    UIPanGestureRecognizer* swipeLeftGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    [self.tableViewDetailView addGestureRecognizer:swipeLeftGestureRecognizer];
    
    
    
    
  
    self.underlineImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.tableViewDetailView.frame.size.height - self.userPhotoImageView.layer.borderWidth, self.tableViewDetailView.frame.size.width - self.userPhotoImageView.frame.size.width/2, 2)];
    
    [self.underlineImageVIew setBackgroundColor:self.userThemeColor];
    [self.tableView insertSubview:self.underlineImageVIew aboveSubview:self.tableViewDetailView];
    
    
    
    
    
    UIButton *addApinionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addApinionButton setImage:[UIImage imageNamed:@"postImage"] forState:UIControlStateNormal];
    
    addApinionButton.tintColor = self.userThemeColor;
    [addApinionButton setFrame:CGRectMake(self.tableViewDetailView.frame.size.width/3  , self.tableViewDetailView.frame.size.height/2 - 14 , 28, 28)];
    
    [self.tableView insertSubview:addApinionButton belowSubview:self.tableViewDetailView];
    
    [addApinionButton addTarget:self action:@selector(addApinion) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    addToGroupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addToGroupButton setImage:[UIImage imageNamed:@"addToGroup"] forState:UIControlStateNormal];
    addToGroupButton.tintColor = self.userThemeColor;

    [addToGroupButton setFrame:CGRectMake(self.tableView.frame.size.width/2 , self.tableViewDetailView.frame.size.height/2 - 14 , 28, 28)];
    
    
    [self.tableView insertSubview:addToGroupButton belowSubview:self.tableViewDetailView];
    [addToGroupButton addTarget:self action:@selector(addUserToGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    defaultDetailViewCenterX = self.tableViewDetailView.center.x;
    defaultDetailViewCenterY = 0 + self.tableViewDetailView.frame.size.height/2;

    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    reportButton.tintColor = self.userThemeColor;
    reportButton.layer.cornerRadius = 14;
    
    reportButton.layer.borderWidth = 1.0f;
    reportButton.layer.borderColor = self.userThemeColor.CGColor;
    [reportButton setFrame:CGRectMake(self.tableViewDetailView.frame.size.width/2 + (addToGroupButton.frame.origin.x - addApinionButton.frame.origin.x)  , self.tableViewDetailView.frame.size.height/2 - 14 , 28, 28)];
    [reportButton setTitle:@"!" forState:UIControlStateNormal];
    [self.tableView insertSubview:reportButton belowSubview:self.tableViewDetailView];
    
    [reportButton addTarget:self action:@selector(reportObject) forControlEvents:UIControlEventTouchUpInside];
    
    
    customCellTextView = [[UITextView alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
 

  
    self.navigationItem.backBarButtonItem = self.backButton;
    
    addActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Add", nil];
    removeActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Remove", nil];
    addActionSheet.delegate = self;
    removeActionSheet.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.backButton.tintColor = self.userThemeColor;
    self.selectedUserNameLabel.textColor = self.userThemeColor;
    self.selectedUserSchoolLabel.textColor = self.userSecondaryThemeColor;
    self.tableView.separatorColor = self.userThemeColor;
    
    removeActionSheet.title = [NSString stringWithFormat:@"Remove \"%@\" from your favorites?",[self.selectedUserData objectForKey:@"Object_FirstName"]];
    addActionSheet.title = [NSString stringWithFormat:@"Add \"%@\" to your favorites?",[self.selectedUserData objectForKey:@"Object_FirstName"]];
    


    
    if ([[[PFUser currentUser]objectForKey:@"userFavotitesID"]containsObject:[NSString stringWithFormat:@"%@",self.selectedUserData.objectId]]) {
        
          [addToGroupButton setImage:[UIImage imageNamed:@"removeFromGroup"] forState:UIControlStateNormal];
        
        
        
    }else{
        
        [addToGroupButton setImage:[UIImage imageNamed:@"addToGroup"] forState:UIControlStateNormal];
        
        }
 
    
    
 
            
            
    
            
 
    
    
    //Get user Image
    PFFile *imageFile = [self.selectedUserData objectForKey:@"objectImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *userImage = [UIImage imageWithData:data];
            self.userPhotoImageView.image = userImage;
            
        }
    }];
    NSString *selectedUserName = [[self.selectedUserData objectForKey:@"Object_FirstName"]stringByAppendingString:@" "];
    if ([self.selectedUserData objectForKey:@"Object_LastName"]!=nil) {
            self.selectedUserNameLabel.text = [selectedUserName stringByAppendingString:[self.selectedUserData objectForKey:@"Object_LastName"]];
    }else{
        self.selectedUserNameLabel.text = selectedUserName;
        
    }
    
    if ([self.selectedUserData objectForKey:@"School_Name"] != nil) {
         self.selectedUserSchoolLabel.text = [self.selectedUserData objectForKey:@"School_Name"];
    }else{
         self.selectedUserSchoolLabel.text = [self.selectedUserData objectForKey:@"topic_Detail"];
    }
   
    

}
- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.navigationController.shyNavigationBar setToShyHeight:YES];
 
 
}





- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
 
    [self.navigationController.shyNavigationBar adjustForSequeInto:animated scrollView:self.tableView];
    



    


    
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

//    self.aponionTextField.placeholder = [NSString stringWithFormat:@"Wanna share your Apinion on %@?",[self.selectedUserData objectForKey:@"Object_FirstName"]];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Apinions"];
    [postQuery whereKey:@"selectedUserID" containsString:self.selectedUserData.objectId];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.selectedUserPosts = objects;

        
        [self.tableView reloadData];
    }];

    // add one view to user
    PFQuery *getSelectedUser = [PFQuery queryWithClassName:@"userMetaData"];
    [getSelectedUser whereKey:@"userId" containsString:self.selectedUserData.objectId];
    [getSelectedUser getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.selectedUserMetaData = object;
        NSNumber *userView = [self.selectedUserMetaData objectForKey:@"userViews"];
        int viewCount = [userView intValue] + 1;
        userView = [[NSNumber alloc]initWithInt:viewCount];
        [self.selectedUserMetaData setObject:userView forKey:@"userViews"];
        [self.selectedUserMetaData saveInBackground];
        
    }];
        
    NSNumber *number = [[PFUser currentUser]objectForKey:@"hasSeenUserTutorial"];

    if (number.intValue!=1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Welcome" message:@"If you would like to add your own Apinion to just swipe across the \"Profile Bar\" on the top of the screen" delegate:self cancelButtonTitle:@"Will Do" otherButtonTitles:nil, nil];
        [alert show];
        [[PFUser currentUser]setObject:[NSNumber numberWithInt:1] forKey:@"hasSeenUserTutorial"];
        [[PFUser currentUser]saveInBackground];
        
        
    }



}

-(NSString*)retrivePostTime:(NSString*)postDate{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *userPostDate = [df dateFromString:postDate];
    
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:userPostDate];
    
    NSTimeInterval theTimeInterval = distanceBetweenDates;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth ago",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd ago",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh ago",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm ago",(long)[conversionInfo minute]];
    }else if ([conversionInfo second]>0){
        returnDate = [NSString stringWithFormat:@"%lds ago",(long)[conversionInfo second]];
    }else{
        returnDate = @"Just now";
    }
    return returnDate;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.navigationController.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, (self.toolbar.frame.origin.y - 100.0), self.toolbar.frame.size.width, self.toolbar.frame.size.height);

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 140;
}


-(void)textViewDidChangeSelection:(UITextView *)textView{
   unsigned long int characterInt = 140 - textView.text.length;
    
    charaterLabel.text = [NSString stringWithFormat:@"%lu",characterInt];
    
}
- (void)textViewDidChange:(UITextView *)textView
{

    

    float newHeight = textView.contentSize.height;
    if(newHeight < self.toolbar.frame.size.height){
    }
    else if (newHeight < self.view.frame.size.height){
        float offset = (newHeight - self.toolbar.frame.size.height);
        
        [self.toolbar setFrame:CGRectMake(self.toolbar.frame.origin.x,  self.toolbar.frame.origin.y - offset, self.toolbar.frame.size.width, newHeight)];
        [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, newHeight - 14)];
    }

    
    
}



-(void)keyboardFrameWillChange:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    
    CGRect kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.toolbar setFrame:CGRectMake(0, kKeyBoardFrame.origin.y-self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
    
    [self.view sendSubviewToBack:self.tableView];
    
    [selectedCellIArray removeObject:selectedCellIndexPath];
}





- (IBAction)backButtonPress:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
        [self.navigationController popViewControllerAnimated:YES];

}

- (void)showAlert: (PFObject *)alertObject {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[self.alertFound objectForKey:@"alertTitle"] message:[self.alertFound objectForKey:@"infoText"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)addApinion {
    [self performSegueWithIdentifier:@"showAddApinion" sender:self];
}
-(void)reportObject{
    PFObject *object;
    if ([[self.selectedUserData parseClassName]isEqualToString:@"_User"]) {
         object = self.selectedUserMetaData;
    }else{
        object = self.selectedUserData;
    }
   
    if (![[[PFUser currentUser]objectForKey:@"HaveReported"]containsObject:object.objectId]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Report" message:@"Are you sure you want to report this User/Topic?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Report", nil];
        alert.tag = 89;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reported" message:@"You have already reported this. Thank you for making Apinion a better place!" delegate:self cancelButtonTitle:@":)" otherButtonTitles:nil, nil];
        [alert show];
        
    }

    
}

#pragma mark - Touches events

- (void)handleSwipeLeftFrom:(UIPanGestureRecognizer*)recognizer {

    
//    CGPoint location = [recognizer locationInView:self.view];
//    CGPoint translation = [recognizer translationInView:self.tableViewDetailView];
//    
////
////    self.tableViewDetailView.center = CGPointMake(location.x, self.tableViewDetailView.center.y);
//    [self.tableViewDetailView setFrame:CGRectMake(self.tableViewDetailView.center.x+translation.x, self.tableViewDetailView.frame.origin.y, self.tableViewDetailView.frame.size.width, self.tableViewDetailView.frame.size.height)];
//    
////    CGPoint translation = [recognizer translationInView:recognizer.view];
////    
////    recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y);
////    
////    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
//
//    
    

    
    
 CGPoint translation = [recognizer translationInView:self.view];
    
    if (translation.x < 0 || self.tableViewDetailView.frame.origin.x < 0) {
        
        if (latestXTranslation == 0) {
            latestXTranslation = translation.x;

        }
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

    }
 

    if (recognizer.state == UIGestureRecognizerStateEnded) {

        float centerX = self.tableViewDetailView.frame.size.width/4.5;
        
        if (latestXTranslation < 0) {
//            NSLog(@" < 0");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            //was - 75
            [self.tableViewDetailView setCenter:CGPointMake( -centerX,defaultDetailViewCenterY )];
            [UIView commitAnimations];
            latestXTranslation = 0;
//            NSLog(@"Frame x:%f Y:%f",self.tableViewDetailView.frame.origin.x,self.tableViewDetailView.frame.origin.y);
//            
//      
            
             [UIView animateWithDuration:0.2 animations:^{
                
                
                
                [self.underlineImageVIew setFrame:CGRectMake(0, self.tableViewDetailView.frame.size.height - self.userPhotoImageView.layer.borderWidth, self.tableViewDetailView.frame.size.width, 2)];
                
                 
            }];
        }else{
//            NSLog(@"> 0");
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            //was 187.5
        [self.tableViewDetailView setCenter:CGPointMake( defaultDetailViewCenterX,defaultDetailViewCenterY )];
        [UIView commitAnimations];
            latestXTranslation = 0;
//            NSLog(@"Frame x:%f Y:%f",self.tableViewDetailView.frame.origin.x,self.tableViewDetailView.frame.origin.y);
//            
            
             [UIView animateWithDuration:0.2 animations:^{
                
                
                
                [self.underlineImageVIew setFrame:CGRectMake(0, self.tableViewDetailView.frame.size.height - self.userPhotoImageView.layer.borderWidth, self.tableViewDetailView.frame.size.width - self.userPhotoImageView.frame.size.width/2, 2)];
                
                
            }];
        }
    }

}



#pragma mark - Scroll View Delagates


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1) {
        
    
    [self.navigationController.shyNavigationBar scrollViewDidScroll:scrollView];
    
        
        if (defaultDetailViewCenterX != self.tableViewDetailView.frame.origin.x) {
            [UIView animateWithDuration:0.2 animations:^{
                
                
                
                [self.underlineImageVIew setFrame:CGRectMake(0, self.tableViewDetailView.frame.size.height - self.userPhotoImageView.layer.borderWidth, self.tableViewDetailView.frame.size.width - self.userPhotoImageView.frame.size.width/2, 2)];
                
                
            }];

        }
    }
}


- (void)closeAddApinion:(UIViewController*)sender{

    [self.navigationController.shyNavigationBar setToFullHeight:YES];
    [UIView animateWithDuration:0.2 animations:^{
        
        
        
        [self.underlineImageVIew setFrame:CGRectMake(0, self.tableViewDetailView.frame.size.height - self.userPhotoImageView.layer.borderWidth, self.tableViewDetailView.frame.size.width - self.userPhotoImageView.frame.size.width/2, 2)];
        
        
    }];
    [self dismissViewControllerAnimated:true completion:^{
 
    }];
}

#pragma mark - Table view functions

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [UIView animateWithDuration:0.2 animations:^{
         
         
         
         [self.underlineImageVIew setFrame:CGRectMake(0, self.tableViewDetailView.frame.size.height - self.userPhotoImageView.layer.borderWidth, self.tableViewDetailView.frame.size.width - self.userPhotoImageView.frame.size.width/2, 2)];
         
         
     }];
    if (![selectedCellIArray containsObject:indexPath]) {
       
        [selectedCellIArray removeAllObjects];
        [selectedCellIArray addObject:indexPath];
        [self.tableView reloadData];
        selectedCellIndexPath = indexPath;

    }else{
                [selectedCellIArray removeAllObjects];


        [self.tableView reloadData];
        [tableView scrollToRowAtIndexPath:selectedCellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return self.selectedUserPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    userInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UITextView *txtView in cell.contentView.subviews)
    {
        if([txtView isKindOfClass:[UITextView class]])
        {
            [txtView removeFromSuperview];
        }        
    }

    
    UITextView *cellTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, cell.contentView.frame.size.width * 0.746667, cell.contentView.frame.size.height)];

       NSString *postString = [[self.selectedUserPosts objectAtIndex:indexPath.row]objectForKey:@"postText"];


        userCellWidth = cellTextView.frame.size.width;

    


    cellTextView.editable=NO;
    cellTextView.font = [UIFont systemFontOfSize:13.5];
    cellTextView.textColor=[UIColor blackColor];
    cellTextView.userInteractionEnabled = NO;
    cellTextView.text = postString;
    cellTextView.scrollEnabled = NO;
    [cellTextView layoutSubviews];
    [cell.contentView addSubview:cellTextView];
//    [cellTextView layoutIfNeeded]; //added
    
    [cell.displayNameLabel setFont:[UIFont systemFontOfSize:12]];
    
    cell.displayNameLabel.text =[[self.selectedUserPosts objectAtIndex:indexPath.row]objectForKey:@"displayName"];
    [cell.displayNameLabel layoutSubviews];
    
 

    NSDate *date = [[self.selectedUserPosts objectAtIndex:indexPath.row] createdAt];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"]; // Date formater
    NSString *dateString = [dateformate stringFromDate:date]; // Convert date to string

    cell.detailTextLabel.text = [self retrivePostTime:dateString];
    cell.detailTextLabel.textColor = self.userThemeColor;
    

    CGFloat fixedWidth = customCellTextView.frame.size.width;
    CGSize newSize = [customCellTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = customCellTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);


    if ([selectedCellIArray containsObject:indexPath]) {
        
        [cell addSubview:self.reportButton];


    [self.reportButton setFrame:CGRectMake(cell.frame.size.width - cell.displayNameLabel.frame.size.width - 45, cell.frame.size.height - 30, 30, 30)];
        
        
 
        
    }
        
    
    
    if (newFrame.size.height < 90) {
        cell.dotsImage.hidden = YES;

    }else{
       
       cell.dotsImage.hidden = NO;
  
       

    }

    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    userInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    [customCellTextView setFrame:CGRectMake(15, 0, cell.contentView.frame.size.width * 0.746667, cell.frame.size.height)];
    if (userCellWidth) {
        [customCellTextView setFrame:CGRectMake(15, 0, userCellWidth, cell.frame.size.height)];

    }

    
    NSString *postString = [[self.selectedUserPosts objectAtIndex:indexPath.row]objectForKey:@"postText"];
    
    
    customCellTextView.editable=NO;
    customCellTextView.font = [UIFont systemFontOfSize:13.5];
    customCellTextView.textColor=[UIColor blackColor];
    customCellTextView.userInteractionEnabled = NO;
    customCellTextView.text = postString;
    customCellTextView.scrollEnabled = NO;
    [cell.contentView addSubview:customCellTextView];


    
    
    
    if ([selectedCellIArray containsObject:indexPath]) {

        

        

        if (  [customCellTextView sizeThatFits:CGSizeMake(customCellTextView.frame.size.width , CGFLOAT_MAX)].height < 90) {
            return 90 + 34;
        }else{
            return   [customCellTextView sizeThatFits:CGSizeMake(customCellTextView.frame.size.width, CGFLOAT_MAX)].height + customCellTextView.font.pointSize + 34;
        }
        
    }else{
        [customCellTextView setFrame:CGRectMake(15, 0, customCellTextView.frame.size.width, cell.frame.size.height)];
        
        
    }
    
    return 90;
    
    
}
#pragma mark - Post options

- (IBAction)reportButtonPress:(id)sender {

        PFObject *post = [self.selectedUserPosts objectAtIndex:selectedCellIndexPath.row];
        if (![[[PFUser currentUser]objectForKey:@"HaveReported"]containsObject:post.objectId]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Report Post" message:@"Are you sure you want to report this post?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Report", nil];
            alert.tag = 9;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reported" message:@"You have already reported this post. Thank you for making Apinion a better place!" delegate:self cancelButtonTitle:@":)" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    
        


    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (alertView.tag == 9) {
        
        
        if (buttonIndex == 0)
            
        {
            //Cancel
            
            
        }else
        {
           
            PFObject *post = [self.selectedUserPosts objectAtIndex:selectedCellIndexPath.row];
            NSNumber *reports = [post objectForKey:@"Reports"];
            NSNumber *newReport = [NSNumber numberWithInt:reports.intValue + 1];
            [post setObject:newReport forKey:@"Reports"];
            [[PFUser currentUser]addObject:post.objectId forKey:@"HaveReported"];
            [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [post saveInBackground];
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Reported post...Thank you for making Apinion a better place" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert2 show];
                
            }];
        
        }
    }

    
    if (alertView.tag == 89) {
        
        
        if (buttonIndex == 0)
            
        {
            //Cancel
             
        }else
        {
            PFObject *object;
            if ([[self.selectedUserData parseClassName]isEqualToString:@"_User"]) {
                object = self.selectedUserMetaData;
            }else{
                object = self.selectedUserData;
            }
             NSNumber *reports = [object objectForKey:@"Reports"];
            NSNumber *newReport = [NSNumber numberWithInt:reports.intValue + 1];
            [object setObject:newReport forKey:@"Reports"];
            [[PFUser currentUser]addObject:object.objectId forKey:@"HaveReported"];
            [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [object saveInBackground];
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Reported User/Topic...Thank you for making Apinion a better place" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert2 show];
                
            }];
            
        }
    }


}
- (void)refreshPosts {
    
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
    

    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Apinions"];
    [postQuery whereKey:@"selectedUserID" containsString:self.selectedUserData.objectId];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.selectedUserPosts = objects;
        [self.tableView reloadData];
    
    }];
    

}


#pragma mark - Adding selected user to group
-(void)addUserToGroup:(id)sender{
    
    
    
    
    if ([[[PFUser currentUser]objectForKey:@"userFavotitesID"]containsObject:[NSString stringWithFormat:@"%@",self.selectedUserData.objectId]]) {
        
        [removeActionSheet showInView:self.view];

        
        
    }else{
        
        [addActionSheet showInView:self.view];

        
        
    }

    
    

    
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
 
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     if (buttonIndex == 0) {
        //add to favorites

   
        if ([[[PFUser currentUser]objectForKey:@"userFavotitesID"]containsObject:[NSString stringWithFormat:@"%@",self.selectedUserData.objectId]]) {
            
            [[PFUser currentUser]removeObject:self.selectedUserData.objectId forKey:@"userFavotitesID"];
            
            [addToGroupButton setImage:[UIImage imageNamed:@"addToGroup"] forState:UIControlStateNormal];
            
            
        }else{
            
            [[PFUser currentUser]addObject:self.selectedUserData.objectId forKey:@"userFavotitesID"];
            
            [addToGroupButton setImage:[UIImage imageNamed:@"removeFromGroup"] forState:UIControlStateNormal];
            
                    }
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@",error.userInfo);
            }
            
        }];

        
    }

        
    
    else {
        //User canceled add
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];

 
        }
    
        

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    
    if ([segue.identifier isEqualToString:@"showAddApinion"]) {
        
        addApinionViewController *addApinionView = (addApinionViewController *)[segue.destinationViewController topViewController];
        addApinionView.selectedUserData = self.selectedUserData;
        addApinionView.delagate = self;
        addApinionView.userThemeColor = self.userThemeColor;
//        [self.navigationController.shyNavigationBar prepareForSegueAway:YES];

    }

}
@end
