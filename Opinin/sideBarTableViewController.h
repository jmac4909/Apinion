//
//  sideBarTableViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 2/10/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "accountViewController.h"
#import "custonGroupTableViewController.h"
#import "createGroupViewController.h"

@interface sideBarTableViewController : UITableViewController<accountViewProtocol,closeCreateGroupViewProtocol>{
    UIColor *settingColor;
    
}
@property (strong,nonatomic)NSMutableArray *userGroups;
@property (strong,nonatomic)PFObject *selectedGroup;


@end
