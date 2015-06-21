//
//  custonGroupTableViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/17/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "custonGroupTableViewController.h"
#import "userInfoViewController.h"

static CGFloat MKMapOriginHight = 175.f;


@interface custonGroupTableViewController ()

@end

@implementation custonGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];

    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navBarImage.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"VastShadow-Regular" size:30],
      NSFontAttributeName,
      color,NSForegroundColorAttributeName, nil]];
    
    
    
    homeDropButton = [[UIButton alloc]init];
    [homeDropButton addTarget:self action:@selector(homeButtonPress) forControlEvents:UIControlEventTouchUpInside];
    homeDropButton.userInteractionEnabled = true;
    
    favoritesDropButton = [[UIButton alloc]init];
    [favoritesDropButton addTarget:self action:@selector(favoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    favoritesDropButton.userInteractionEnabled = true;
    
    popularDropButton = [[UIButton alloc]init];
    [popularDropButton addTarget:self action:@selector(popularButtonPress) forControlEvents:UIControlEventTouchUpInside];
    popularDropButton.userInteractionEnabled = true;

    
    
    screenTap = [[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(tapScreen:)];
 
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    
    coverView.backgroundColor = [UIColor blackColor];
    [coverView setAlpha:0.4];
    self.dropDownMenuView.hidden = true;


}
- (IBAction)tapScreen:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    
    CGRect homeFrame = [self.dropDownMenuView convertRect:homeDropButton.frame toView:self.view];
    
    
    
    if (CGRectContainsPoint(homeFrame, tapPoint)) {
        [self homeButtonPress];
        return;
    }
    CGRect popularFrame = [self.dropDownMenuView convertRect:popularDropButton.frame toView:self.view];
    if (CGRectContainsPoint(popularFrame, tapPoint)) {
        [self popularButtonPress];
        return;
    }
    CGRect favoriteFrame = [self.dropDownMenuView convertRect:favoritesDropButton.frame toView:self.view];
    if (CGRectContainsPoint(favoriteFrame, tapPoint)) {
        [self favoriteButtonPress];
        return;
    }
}

-(void)viewWillAppear:(BOOL)animated{

    //Red color
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    
    
    //Gets the color the navigationBar should be
    
    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageRed.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
 
        
        
        color = [UIColor whiteColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageYellow.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
 
        
        
        //Red color
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageBlue.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
 
        
        
        self.tableView.separatorColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
        color = [UIColor whiteColor];
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageTan.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        
        
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageGreen.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
 
        
        
        
        self.tableView.separatorColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];
        
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImagePurple.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
 
        
        
        
        self.tableView.separatorColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
        
        
    }
    
    else{
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navBarImageYellow.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
 
        
        
        color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
    }
    

    
//    if ([self.group objectForKey:@"userIdInGroup"]) {
//        
//    
//    PFQuery *groupUserQuery = [PFUser query];
//    [groupUserQuery whereKey:@"objectId" containedIn:[self.group objectForKey:@"userIdInGroup"]];
//    
//    [groupUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        self.userInGroup = objects;
//        [self.tableView reloadData];
//    }];
//    }
    
    [self.navigationController.navigationBar insertSubview:self.dropDownMenuView atIndex:0];
    self.dropDownMenuView.hidden = true;
    
    [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - (MKMapOriginHight), self.tableView.frame.size.width, MKMapOriginHight- (MKMapOriginHight/3))];

    
    [homeDropButton setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, (self.dropDownMenuView.frame.size.height/3))];
    [homeDropButton setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
    [homeDropButton setTitle:@"  Home" forState:UIControlStateNormal];
    [self.dropDownMenuView addSubview:homeDropButton];
    [homeDropButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [homeDropButton setImage:[UIImage imageNamed:@"homeIcon"] forState:UIControlStateNormal];
    
    
    
    [popularDropButton setFrame:CGRectMake(0, homeDropButton.frame.size.height*2, self.tableView.frame.size.width, (self.dropDownMenuView.frame.size.height/3))];
    
    [popularDropButton setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
    [popularDropButton setTitle:@"  Popular" forState:UIControlStateNormal];
    [popularDropButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [popularDropButton setImage:[UIImage imageNamed:@"profileIcon"] forState:UIControlStateNormal];
    
    [self.dropDownMenuView addSubview:popularDropButton];
    
    
    [favoritesDropButton setFrame:CGRectMake(0, homeDropButton.frame.size.height, self.tableView.frame.size.width, (self.dropDownMenuView.frame.size.height/3))];
    
    
    [favoritesDropButton setBackgroundColor:[UIColor whiteColor]];
    [favoritesDropButton setTitle:@"  Favorites" forState:UIControlStateNormal];
    [favoritesDropButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [favoritesDropButton setImage:[UIImage imageNamed:@"FavoriteStar"] forState:UIControlStateNormal];
    
    [self.dropDownMenuView addSubview:favoritesDropButton];
    
    self.dropDownMenuView.userInteractionEnabled = true;

    
}

- (IBAction)pressDropDownButton:(id)sender {
    [self dropMenu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else{
        
        
        //Red
        returnColor  = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
    }
    return returnColor;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if ([[self.group objectForKey:@"userIdInGroup"] count] > 0) {
        return [[self.group objectForKey:@"userIdInGroup"] count];
    }else{
    return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...

    PFObject *userObject = [self.userInGroup objectAtIndex:indexPath.row];
    if (userObject) {
        
        
    NSString *fullName = [[[userObject objectForKey:@"Object_FirstName"] stringByAppendingString: @" "]stringByAppendingString:[userObject objectForKey:@"Object_LastName"]];
    cell.textLabel.text = fullName;
    cell.detailTextLabel.text = [userObject objectForKey:@"School_Name"];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedUserData = [self.userInGroup objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showUserPage" sender:self];
    
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
-(void)dropMenu{
    if (self.dropDownMenuView.hidden == true) {
        
         
        
        self.dropDownMenuView.hidden = false;
        [self.view addGestureRecognizer:screenTap];
        
        [UIView animateWithDuration:.3 animations:^{
            
            [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.tableView.frame.size.width, (MKMapOriginHight - (MKMapOriginHight/3)))];
            
            [self.navigationController.navigationBar insertSubview:coverView belowSubview:self.dropDownMenuView];
            
            
        } completion:^(BOOL finished) {
            
            
            self.tableView.scrollEnabled = false;
            self.tableView.allowsSelection = NO;
             
        }];
        
        
    }else{
        
        
        
        [UIView animateWithDuration:.3 animations:^{
            
            [self.dropDownMenuView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - MKMapOriginHight , self.tableView.frame.size.width, (MKMapOriginHight - (MKMapOriginHight/3)))];
            [coverView setAlpha:0.0];
            
        } completion:^(BOOL finished) {
            self.dropDownMenuView.hidden = true;
            self.tableView.scrollEnabled = true;
            
            self.tableView.allowsSelection = YES;
            
            [coverView removeFromSuperview];
            [coverView setAlpha:0.4];
             
            [self.view removeGestureRecognizer:screenTap];
            
        }];
        
        
    }
}
#pragma mark
-(void)homeButtonPress{
    NSLog(@"Home");
    [self performSegueWithIdentifier:@"showHome2" sender:self];
}
-(void)popularButtonPress{
    NSLog(@"Popular");
    [self performSegueWithIdentifier:@"showSettings2" sender:self];
}
-(void)favoriteButtonPress{
    NSLog(@"Favorite");
    [self performSegueWithIdentifier:@"showFavorite2" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    self.dropDownMenuView.hidden = true;
    self.tableView.scrollEnabled = true;
    
    self.tableView.allowsSelection = YES;
    
    [coverView removeFromSuperview];
    [coverView setAlpha:0.4];
    
    [self.view removeGestureRecognizer:screenTap];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showUserPage"]) {
        
        userInfoViewController *userInfoViewControler = segue.destinationViewController;
        userInfoViewControler.selectedUserData = self.selectedUserData;
        userInfoViewControler.userThemeColor = [self getUserColor];

        
    }
    
    if ([segue.identifier isEqualToString:@"showSettings2"]) {
        
        accountViewController *accountView = (accountViewController *)[segue.destinationViewController topViewController];
        
        accountView.delagate = self;

        
        
        
    }

}
- (void)closeAccountView:(UIViewController*)sender;
{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)editGroupPress:(id)sender {
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"no no no" message:@"not so fast cowboy" delegate:self cancelButtonTitle:@"I like men *wink wink*" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
