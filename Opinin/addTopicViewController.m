//
//  addTopicViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 3/29/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "addTopicViewController.h"

@interface addTopicViewController ()

@end

@implementation addTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    [self.locationManager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (PFGeoPoint *)getdeviceLocation {
    return [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createTopic:(id)sender {
    
    if (self.topicDetailTextView.text.length > 0 && self.topicTitleTextFeild.text.length > 0) {
        
        PFObject *topic = [PFObject objectWithClassName:@"Topics"];
        [topic setObject:self.topicTitleTextFeild.text forKey:@"topic_Name"];
        [topic setObject:self.topicDetailTextView.text forKey:@"topic_Detail"];
        [topic setObject:[self getdeviceLocation] forKey:@"Created_Position"];
        [topic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        
        
    }
}
@end
