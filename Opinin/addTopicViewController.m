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


    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.borderWidth = 1.0f;
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    self.userImageView.layer.borderColor = color.CGColor;
    
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"Take photo", @"Choose Existing", nil];
    
    mediaPicker.navigationBar.tintColor = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];

    
    self.topicTitleTextFeild.delegate = self;
    self.topicDetailTextView.delegate = self;
    
    [self.topicTitleTextFeild addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.createTopicButton.enabled = false;

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    mediaPicker = [[UIImagePickerController alloc] init];
    [mediaPicker setDelegate:self];
    mediaPicker.allowsEditing = YES;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (PFGeoPoint *)getdeviceLocation {
    return [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    userImage =(UIImage*)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.userImageView.image = userImage;
    // Convert to JPEG with 100% quality
    
    NSData* data = UIImageJPEGRepresentation(userImage, 1.0f);
    imageFile = [PFFile fileWithName:@"objectImage.jpg" data:data];
    

}

- (IBAction)selectUserImage:(id)sender {
    
    
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [actionSheet showInView:self.view];
    } else {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:mediaPicker animated:YES completion:^{
            
        }];
    }
    
    
}


- (void)textFieldDidChange:(id)sender{
    UITextField *field = (UITextField*)sender;
    
    if (![[field.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && field.text.length >0) {
        self.createTopicButton.enabled = true;
    }else{
        self.createTopicButton.enabled = false;

    }



}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField.tag == 1) {
        if (newLength <= 25) {
            self.titleLabel.text = [NSString stringWithFormat:@"Title(%lu):  ",25 -(unsigned long)newLength];
        }

         return newLength <= 25;

    }else if (textField.tag == 2){
        if (newLength <=35) {
            self.detailLabel.text = [NSString stringWithFormat:@"Detail(%lu):  ",35 - (unsigned long)newLength];
        }

        return newLength <= 35;

    }
    return false;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:mediaPicker animated:YES completion:^{
            
        }];
    } else if (buttonIndex == 1) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:mediaPicker animated:YES completion:^{
            
        }];}
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
    
    if (self.topicDetailTextView.text.length <= 35 && self.topicTitleTextFeild.text.length > 0 && self.topicTitleTextFeild.text.length <= 25) {

        PFObject *topic = [PFObject objectWithClassName:@"Topics"];
        if (imageFile) {
            [topic setObject:imageFile forKey:@"objectImage"];
            
        }
        NSString *Object_FullNameFirst = [NSString stringWithFormat:@"%@%@",self.topicTitleTextFeild.text,self.topicDetailTextView.text];
        NSString *Object_FullName = [Object_FullNameFirst stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [topic setObject:self.topicTitleTextFeild.text forKey:@"Object_FirstName"];
        [topic setObject:self.topicDetailTextView.text forKey:@"topic_Detail"];
        [topic setObject:[self getdeviceLocation] forKey:@"Created_Position"];
        [topic setObject:Object_FullName forKey:@"Object_FullName"];

        [topic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.delagate closeCreateTopicView:self];
        }];
        
        
    }
}
-(IBAction)cancelPress:(id)sender{
    
    [self.delagate closeCreateTopicView:self];
    
    
}
@end
