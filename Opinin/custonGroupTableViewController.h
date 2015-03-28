//
//  custonGroupTableViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 2/17/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
@interface custonGroupTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong,nonatomic)PFObject *group;
@property (strong,nonatomic)NSArray *userInGroup;
@property PFObject *selectedUserData;

- (IBAction)editGroupPress:(id)sender;
@end
