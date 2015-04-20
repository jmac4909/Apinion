//
//  sideBarTableViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/10/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "sideBarTableViewController.h"
#import "SWRevealViewController.h"
@interface sideBarTableViewController ()

@end

@implementation sideBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
       self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
    [groupQuery whereKey:@"creatorId" equalTo:[PFUser currentUser].objectId];
    [groupQuery orderByAscending:@"createdAt"];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.userGroups = [[NSMutableArray alloc]initWithArray:objects];
        [self.tableView reloadData];
    }];
    
    
    if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Red"]) {
        
        //Red
        settingColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Yellow"]) {
        
        
        //Red
        settingColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Blue"]) {
        //Blue
        settingColor = [UIColor colorWithRed:48/255.0f green:58/255.0f blue:118/255.0f alpha:1.0f];
        
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Tan"]) {
        
        //Red
        settingColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Green"]) {
        
        settingColor = [UIColor colorWithRed:34/255.0f green:56/255.0f blue:9/255.0f alpha:1.0f];

        
    }
    else if ([[[PFUser currentUser]objectForKey:@"userTheme"]isEqualToString:@"Purple"]) {
        
        settingColor = [UIColor colorWithRed:46/255.0f green:3/255.0f blue:75/255.0f alpha:1.0f];
        
        
    }
    else{
        
        
        //Red
        settingColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
        
        
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)openSettings{
    [self performSegueWithIdentifier:@"openSettings" sender:self];
}
- (void)closeAccountView:(UIViewController*)sender;
{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.userGroups.count + 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    //Settings
    if (indexPath.row == 0) {
        [self openSettings];
    }
    //Home
    else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"showHome" sender:self];
    }
    //popular
    else if (indexPath.row == 2) {
        
    }
    //Create group
    else if (indexPath.row == 3) {
        [self createGroup];
    }else{
        self.selectedGroup = [self.userGroups objectAtIndex:indexPath.row - 4];

        [self performSegueWithIdentifier:@"showCustomGroup" sender:self];
        
    }
    
    
    //custom group

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    UIButton *settingsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, cell.frame.size.height/2 - 10, 20, 20)];
    
    [settingsButton setFrame:CGRectMake(cell.frame.size.width * 2/3 + settingsButton.frame.size.width/2, cell.frame.size.height/2 - 10, 20, 20)];
    
    [settingsButton setImage:[UIImage imageNamed:@"settingsGear"] forState:UIControlStateNormal];
    
    settingsButton.tintColor = settingColor;
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:settingsButton];
        
        
    }else if(indexPath.row == 1){
        
        
        cell.textLabel.text = @"Home";
        cell.detailTextLabel.text = @"";
        
        [cell.imageView setImage:[UIImage imageNamed:@"homeIcon"]];
        
    }else if(indexPath.row == 2) {
        cell.textLabel.text = @"Popular";
        cell.detailTextLabel.text = @"";
        
  
        
        [cell.imageView setImage:[UIImage imageNamed:@"popularMedal"]];
        
    }
    
    
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"Create Group";
    

        [cell.imageView setImage:[UIImage imageNamed:@"addGroup"]];
        cell.detailTextLabel.text = @"";

    }else{
        
    cell.textLabel.text = [[self.userGroups objectAtIndex:indexPath.row - 4]objectForKey:@"groupName"];
        
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu user(s) in group",(unsigned long)[[[self.userGroups objectAtIndex:indexPath.row - 4]objectForKey:@"userIdInGroup"] count]];

    }
    
    
    return cell;
}

-(void)createGroup{
    
    // Create a new item

    [self performSegueWithIdentifier:@"showCreateGroup" sender:self];
    
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
- (void)closeCreateGroupView:(UIViewController *)sender{
    [sender dismissViewControllerAnimated:YES completion:^{
        PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
        [groupQuery whereKey:@"creatorId" equalTo:[PFUser currentUser].objectId];
        [groupQuery orderByAscending:@"createdAt"];
        [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.userGroups = [[NSMutableArray alloc]initWithArray:objects];
            [self.tableView reloadData];
        }];    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showCreateGroup"]) {
        createGroupViewController *createGroupVC = (createGroupViewController *)segue.destinationViewController;
        createGroupVC.delagate = self;
        [createGroupVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];

    }
    if ([segue.identifier isEqualToString:@"openSettings"]) {
        
        accountViewController *accountView = (accountViewController *)[segue.destinationViewController topViewController];
        
        accountView.delagate = self;
        
        
    }
    if ([segue.identifier isEqualToString:@"showCustomGroup"]) {
        custonGroupTableViewController *groupTable = (custonGroupTableViewController *)[segue.destinationViewController topViewController];

        groupTable.group = self.selectedGroup;
    }

}


@end
