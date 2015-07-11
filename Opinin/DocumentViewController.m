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
    
    self.webView.hidden = true;


}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Documentation"];
    [query whereKey:@"type" equalTo:self.docType];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%lu",(unsigned long)objects.count);
        PFFile *docFile = [[objects objectAtIndex:0]objectForKey:@"objectFile"];
        
        [docFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                
                [self.webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
                
                self.webView.hidden = false;
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }];


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
