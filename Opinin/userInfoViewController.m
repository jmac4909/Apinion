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
    
    self.aponionTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
    addActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles: nil];
    
    addActionSheet.title = [NSString stringWithFormat:@"Add %@ to which group?",[self.selectedUserData objectForKey:@"First_Name"]];
    
    
    NSString *userIdString = [@"A" stringByAppendingString:[PFUser currentUser].objectId];
    NSArray *subcribtionArray = @[userIdString];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];

    self.tableView.delegate = self;

    self.upVoteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.upVoteButton setImage:[UIImage imageNamed:@"upVotePost"] forState:UIControlStateNormal];
    
    self.downVoteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.downVoteButton setImage:[UIImage imageNamed:@"downVotePost"] forState:UIControlStateNormal];
    
    self.postVotesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];

    

    
    selectedCellIArray = [[NSMutableArray alloc]init];


 
    
    self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width / 2;
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 3.0f;

    
    self.userPhotoImageView.layer.borderColor = self.userThemeColor.CGColor;
    [self.underlineImageView setBackgroundColor: self.userThemeColor];
    

    
    UIPanGestureRecognizer* swipeLeftGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    

    [self.tableViewDetailView addGestureRecognizer:swipeLeftGestureRecognizer];
    
  
    UIButton *addApinionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addApinionButton setFrame:CGRectMake(self.tableView.frame.size.width/2, 40, 50, 50)];
    [self.tableView insertSubview:addApinionButton belowSubview:self.tableViewDetailView];
    [addApinionButton addTarget:self action:@selector(addApinion) forControlEvents:UIControlEventTouchUpInside];
    
    defaultDetailViewCenterX = self.tableViewDetailView.center.x;
    defaultDetailViewCenterY = 0 + self.tableViewDetailView.frame.size.height/2;

    
    customCellTextView = [[UITextView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    self.addButton.tintColor = self.userThemeColor;
    self.backButton.tintColor = self.userThemeColor;
    self.selectedUserNameLabel.textColor = self.userThemeColor;
    self.selectedUserSchoolLabel.textColor = self.userSecondaryThemeColor;
    self.tableView.separatorColor = self.userThemeColor;
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
    [groupQuery whereKey:@"creatorId" equalTo:[PFUser currentUser].objectId];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.userGroups = [[NSMutableArray alloc]initWithArray:objects];
        
        for (int x = 0; x <= objects.count; x++) {
            
            [addActionSheet addButtonWithTitle:[[self.userGroups objectAtIndex:x]objectForKey:@"groupName"]];
        }
        
    }];

    
    
    //Get user Image
    PFFile *imageFile = [self.selectedUserData objectForKey:@"userPicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *userImage = [UIImage imageWithData:data];
            self.userPhotoImageView.image = userImage;
            
        }
    }];
    NSString *selectedUserName = [[self.selectedUserData objectForKey:@"First_Name"]stringByAppendingString:@" "];
    
    self.selectedUserNameLabel.text = [selectedUserName stringByAppendingString:[self.selectedUserData objectForKey:@"Last_Name"]];
    self.selectedUserSchoolLabel.text = [self.selectedUserData objectForKey:@"School_Name"];
    self.selectedUserBananaLabel.text = [self.selectedUserData objectForKey:@""];
    
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

//    self.aponionTextField.placeholder = [NSString stringWithFormat:@"Wanna share your Apinion on %@?",[self.selectedUserData objectForKey:@"First_Name"]];
    
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
        NSNumber *userView = [object objectForKey:@"userViews"];
        int viewCount = [userView intValue] + 1;
        userView = [[NSNumber alloc]initWithInt:viewCount];
        [object setObject:userView forKey:@"userViews"];
        [object saveInBackground];
        
    }];
        
 




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
    
    [self.upVoteButton removeFromSuperview];
    [self.downVoteButton removeFromSuperview];
    [self.postVotesLabel removeFromSuperview];
    [selectedCellIArray removeObject:selectedCellIndexPath];
}



- (IBAction)backButtonPress:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showAlert: (PFObject *)alertObject {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[self.alertFound objectForKey:@"alertTitle"] message:[self.alertFound objectForKey:@"infoText"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)addApinion {
    [self performSegueWithIdentifier:@"showAddApinion" sender:self];
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
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            //was - 75
            [self.tableViewDetailView setCenter:CGPointMake( -centerX,defaultDetailViewCenterY )];
            [UIView commitAnimations];
            latestXTranslation = 0;
        }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            //was 187.5
        [self.tableViewDetailView setCenter:CGPointMake( defaultDetailViewCenterX,defaultDetailViewCenterY )];
        [UIView commitAnimations];
            latestXTranslation = 0;
        }
    }

}



#pragma mark - Scroll View Delagates


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1) {
        
    
    [self.navigationController.shyNavigationBar scrollViewDidScroll:scrollView];
    }
}


- (void)closeAddApinion:(UIViewController*)sender{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma mark - Table view functions


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![selectedCellIArray containsObject:indexPath]) {
       
        [selectedCellIArray removeAllObjects];
        [selectedCellIArray addObject:indexPath];
        [self.tableView reloadData];
        selectedCellIndexPath = indexPath;
        [tableView scrollToRowAtIndexPath:selectedCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

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
            return 90;
        }else{
            return   [customCellTextView sizeThatFits:CGSizeMake(customCellTextView.frame.size.width, CGFLOAT_MAX)].height + customCellTextView.font.pointSize;
        }
        
    }else{
        [customCellTextView setFrame:CGRectMake(15, 0, customCellTextView.frame.size.width, cell.frame.size.height)];
        
        
    }
    
    return 90;
    
    
}
#pragma mark - Post options

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

-(void)upVotePost{
    

    PFObject *post = [self.selectedUserPosts objectAtIndex:selectedCellIndexPath.row];
    NSArray *usersWhoPosted = [post objectForKey:@"userIdWhoVoted"];
    
    if ([usersWhoPosted containsObject:[PFUser currentUser].objectId]) {
        
        // already voted
        
    }else{
        [self.upVoteButton setImage:[UIImage imageNamed:@"upPostSelected"] forState:UIControlStateNormal];

        [[PFUser currentUser]addObject:post.objectId forKey:@"upVotedPosts"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
        [post addObject:[PFUser currentUser].objectId forKey:@"userIdWhoVoted"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
        NSNumber *postVotes = [post objectForKey:@"postVotes"];
        int postCount = [postVotes intValue] + 1;
        
        
        postVotes = [[NSNumber alloc]initWithInt:postCount];
        
        if (postVotes > 0) {
            newPostVotesNum = [NSString stringWithFormat:@"+ %@",[postVotes stringValue]];
            self.postVotesLabel.textColor = [UIColor greenColor];
        }else{
            self.postVotesLabel.textColor = [UIColor redColor];

            newPostVotesNum = [NSString stringWithFormat:@"- %@",[postVotes stringValue]];
        }
        self.postVotesLabel.text = newPostVotesNum;
        [post setObject:postVotes forKey:@"postVotes"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

  
        }];

    
    }
}
-(void)downVotePost{

    PFObject *post = [self.selectedUserPosts objectAtIndex:selectedCellIndexPath.row];
    NSArray *usersWhoPosted = [post objectForKey:@"userIdWhoVoted"];

    if ([usersWhoPosted containsObject:[PFUser currentUser].objectId]) {
        
        // already voted
        
    }else{
        [self.downVoteButton setImage:[UIImage imageNamed:@"downVoteSelected"] forState:UIControlStateNormal];

        [[PFUser currentUser]addObject:post.objectId forKey:@"downVotedPosts"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
        [post addObject:[PFUser currentUser].objectId forKey:@"userIdWhoVoted"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
        NSNumber *postVotes = [post objectForKey:@"postVotes"];
        int postCount = [postVotes intValue] - 1;
        
        
        postVotes = [[NSNumber alloc]initWithInt:postCount];
        
        if (postCount > 0) {
            newPostVotesNum = [NSString stringWithFormat:@"+ %@",[postVotes stringValue]];
            self.postVotesLabel.textColor = [UIColor greenColor];
        }else if (postCount < 0){
            self.postVotesLabel.textColor = [UIColor redColor];

            newPostVotesNum = [NSString stringWithFormat:@" %@",[postVotes stringValue]];
        }
        self.postVotesLabel.text = newPostVotesNum;
        [post setObject:postVotes forKey:@"postVotes"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            
        }];
        
        
    }
}
#pragma mark - Adding selected user to group
-(void)addUserToGroup:(id)sender{
    
    
    [addActionSheet showInView:self.view];

    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //User canceled add
    if (buttonIndex == 0) {
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        
    }
    else if (![[[self.userGroups objectAtIndex:buttonIndex - 1]objectForKey:@"userIdInGroup"]containsObject:self.selectedUserData.objectId]) {
        
        
        [[self.userGroups objectAtIndex:buttonIndex - 1] addObject:self.selectedUserData.objectId forKey:@"userIdInGroup"];
        //Index 0 is cancel
        [[self.userGroups objectAtIndex:buttonIndex - 1] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    
    if ([segue.identifier isEqualToString:@"showAddApinion"]) {
        
        addApinionViewController *addApinionView = (addApinionViewController *)[segue.destinationViewController topViewController];
        addApinionView.selectedUserData = self.selectedUserData;
        addApinionView.delagate = self;
        
//        [self.navigationController.shyNavigationBar prepareForSegueAway:YES];

    }

}
@end
