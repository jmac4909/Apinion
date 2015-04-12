//
//  custonGroupTableViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/17/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "custonGroupTableViewController.h"
#import "userInfoViewController.h"
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
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
        
        [self.view addGestureRecognizer:tap];
    }

}


-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@",[self.group objectForKey:@"groupName"]];
    
    
    
    if ([self.group objectForKey:@"userIdInGroup"]) {
        
    
    PFQuery *groupUserQuery = [PFUser query];
    [groupUserQuery whereKey:@"objectId" containedIn:[self.group objectForKey:@"userIdInGroup"]];
    
    [groupUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.userInGroup = objects;
        [self.tableView reloadData];
    }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        
    NSString *fullName = [[[userObject objectForKey:@"First_Name"] stringByAppendingString: @" "]stringByAppendingString:[userObject objectForKey:@"Last_Name"]];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showUserPage"]) {
        
        userInfoViewController *userInfoViewControler = segue.destinationViewController;
        userInfoViewControler.selectedUserData = self.selectedUserData;
        
        
    }
    
    
}


- (IBAction)editGroupPress:(id)sender {
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"no no no" message:@"not so fast cowboy" delegate:self cancelButtonTitle:@"I like men *wink wink*" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
