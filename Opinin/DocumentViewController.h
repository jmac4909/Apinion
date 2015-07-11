//
//  DocumentViewController.h
//  Apinion
//
//  Created by Jeremy Mackey on 7/10/15.
//  Copyright © 2015 Jeremy Mackey. All rights reserved.
//
#import <Parse/Parse.h>

#import <UIKit/UIKit.h>
@protocol documentViewProtocol

- (void)closeDocumentView:(UIViewController*)sender;

@end
@interface DocumentViewController : UIViewController

@property (strong,nonatomic)UIViewController <documentViewProtocol> *delagate;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *docType;
- (IBAction)donePress:(id)sender;

@end
