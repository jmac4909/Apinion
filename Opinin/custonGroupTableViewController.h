//
//  custonGroupTableViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 2/17/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "accountViewController.h"

@interface custonGroupTableViewController : UITableViewController<accountViewProtocol>{
    
    UIView *coverView;
    UITapGestureRecognizer *screenTap;
    UIButton *homeDropButton;
    UIButton *popularDropButton;
    UIButton *favoritesDropButton;

}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong,nonatomic)PFObject *group;
@property (strong,nonatomic)NSArray *userInGroup;
@property PFObject *selectedUserData;
@property (strong, nonatomic) IBOutlet UIView *dropDownMenuView;

- (IBAction)editGroupPress:(id)sender;
@end
