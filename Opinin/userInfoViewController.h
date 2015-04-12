//
//  userInfoViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 1/12/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "userInfoTableViewCell.h"
#import "ShyNavigationBar.h"
#import "addApinionViewController.h"
@interface userInfoViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,addApinionProtocol>{
    
    NSMutableArray *selectedCellIArray;
    NSIndexPath *selectedCellIndexPath;
    NSString *newPostVotesNum;
    UILabel *charaterLabel;
    UITextView *cellTextView;
    UIActionSheet *addActionSheet;
    float latestXTranslation;
    float defaultDetailViewCenterX;
    

}
@property PFObject *selectedUserData;
@property PFObject *alertFound;
@property (strong,nonatomic) UIColor *userThemeColor;
@property (strong,nonatomic) UIColor *userSecondaryThemeColor;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;


@property (strong, nonatomic) IBOutlet UIImageView *underlineImageView;

@property (strong, nonatomic) IBOutlet UIView *tableViewDetailView;
@property NSArray *selectedUserPosts;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (strong, nonatomic) IBOutlet UITextView *aponionTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIButton *upVoteButton;
@property (strong,nonatomic) UIButton *downVoteButton;
@property (strong,nonatomic) UILabel *postVotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedUserSchoolLabel;

@property (strong, nonatomic) IBOutlet UILabel *selectedUserBananaLabel;

@property (strong,nonatomic)NSMutableArray *userGroups;


- (IBAction)backButtonPress:(id)sender;
- (IBAction)addUserToGroup:(id)sender;

@end
