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
    UIButton *profileDropButton;
    UIButton *favoritesDropButton;

}
@property (strong,nonatomic) UIColor *userThemeColor;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editGroupButton;


@property (strong, nonatomic) IBOutlet UIImageView *favIcon1;
@property (strong, nonatomic) IBOutlet UIImageView *favIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *favIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *favIcon4;

@property (strong, nonatomic) IBOutlet UILabel *userFavoritesLabel;


@property (strong, nonatomic) IBOutlet UIImageView *underlineImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong,nonatomic)PFObject *group;
@property (strong,nonatomic)NSMutableArray *userInGroup;
@property PFObject *selectedUserData;
@property (strong, nonatomic) IBOutlet UIView *dropDownMenuView;

- (IBAction)editGroupPress:(id)sender;
@end
