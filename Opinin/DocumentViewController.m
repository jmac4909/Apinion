//
//  DocumentViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 7/10/15.
//  Copyright © 2015 Jeremy Mackey. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];

    self.navigationController.navigationBar.tintColor = color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.docType isEqualToString:@"Term_Conditions"]) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://apiniondocs.weebly.com"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 9];
        [self.webView loadRequest: request];
    }else if ([self.docType isEqualToString:@"PrivacyPolicy"]){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://apiniondocs.weebly.com/privacy-policy.html"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 9];
        [self.webView loadRequest: request];
        
    }


}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    

 


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)donePress:(id)sender {
    [self.delagate closeDocumentView:self];
}
@end
