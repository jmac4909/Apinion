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
#import "UIScrollView+EmptyDataSet.h"
 
@interface userInfoViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,addApinionProtocol,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    NSMutableArray *selectedCellIArray;
    NSIndexPath *selectedCellIndexPath;
    NSString *newPostVotesNum;
    UILabel *charaterLabel;

    UITextView *customCellTextView;
    UIButton *addToGroupButton;
    
    UIActionSheet *addActionSheet;
    UIActionSheet *removeActionSheet;

    float latestXTranslation;
    float defaultDetailViewCenterX;
    float defaultDetailViewCenterY;

    float userCellWidth;
    BOOL isData;
    

}
@property PFObject *selectedUserMetaData;

@property PFObject *selectedUserData;
 @property (strong,nonatomic) UIColor *userThemeColor;
@property (strong,nonatomic) UIColor *userSecondaryThemeColor;

@property(strong,nonatomic) userInfoTableViewCell *customUserInfoCell;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (strong, nonatomic) IBOutlet UILabel *apinionCountLabel;

@property (strong,nonatomic)UIImageView *underlineImageVIew;
@property(strong,nonatomic)UIToolbar *toolbar;

@property (strong, nonatomic) IBOutlet UIView *tableViewDetailView;
@property NSArray *selectedUserPosts;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *selectedUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedUserSchoolLabel;
@property (strong, nonatomic) UILabel *noImageLabel;


@property (strong, nonatomic) IBOutlet UIButton *reportButton;

- (IBAction)reportButtonPress:(id)sender;

- (IBAction)backButtonPress:(id)sender;
- (IBAction)addUserToGroup:(id)sender;



@end
