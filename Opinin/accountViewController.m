//
//  accountViewController.m
//  Apinion
//
//  Created by Jeremy Mackey on 1/11/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "accountViewController.h"

@interface accountViewController ()

@end

@implementation accountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.borderWidth = 3.0f;
    UIColor * color = [UIColor colorWithRed:143/255.0f green:0/255.0f blue:43/255.0f alpha:1.0f];
    self.userImageView.layer.borderColor = color.CGColor;
    
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"Take photo", @"Choose Existing", nil];
    
    

    mediaPicker = [[UIImagePickerController alloc] init];
    [mediaPicker setDelegate:self];
    mediaPicker.allowsEditing = YES;
    
    //Get user Image
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"objectImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *recievedUserImage = [UIImage imageWithData:data];
            userImage = recievedUserImage;
            self.userImageView.image = recievedUserImage;
        }
    }];

}

-(void)viewWillAppear:(BOOL)animated{


    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
    //Get user Image
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"objectImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *recievedUserImage = [UIImage imageWithData:data];
            if (userImage) {
                self.userImageView.image = userImage;
            }else{
                self.userImageView.image = recievedUserImage;

            }

        
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)changeToRedTheme:(id)sender {
    [[PFUser currentUser]setObject:@"Red" forKey:@"userTheme"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
}

- (IBAction)changeToYellowTheme:(id)sender {
    [[PFUser currentUser]setObject:@"Yellow" forKey:@"userTheme"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];

}

- (IBAction)changeToTanTheme:(id)sender {
    [[PFUser currentUser]setObject:@"Tan" forKey:@"userTheme"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];

}

- (IBAction)changeToBlueTheme:(id)sender {
    [[PFUser currentUser]setObject:@"Blue" forKey:@"userTheme"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];

}

- (IBAction)changeToGreenTheme:(id)sender {
    [[PFUser currentUser]setObject:@"Green" forKey:@"userTheme"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
}

- (IBAction)changeToPurpleTheme:(id)sender {
    [[PFUser currentUser]setObject:@"Purple" forKey:@"userTheme"];
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
}

- (IBAction)logOutPress:(id)sender {
    
    NSArray *subcribtionArray = @[ ];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] setObject:subcribtionArray forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];
    [PFUser logOut];

    [self performSegueWithIdentifier:@"logedOut" sender:self];
}

- (IBAction)backButtonPress:(id)sender {

    [self.delagate closeAccountView:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    userImage =(UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.userImageView.image = userImage;
    // Convert to JPEG with 100% quality

    NSData* data = UIImageJPEGRepresentation(userImage, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:@"objectImage.jpg" data:data];
    [[PFUser currentUser]setObject:imageFile forKey:@"objectImage"];
    
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
        
         
    }];

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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"editName" sender:self];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"editEmail" sender:self];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"editSchool" sender:self];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    

    
    if (indexPath.row == 0) {
        NSString *Name = [[[PFUser currentUser]objectForKey:@"Object_FirstName"]stringByAppendingString:@" "];
        NSString *userFullName = [Name stringByAppendingString:[[PFUser currentUser]objectForKey:@"Object_LastName"]];
        cell.textLabel.text = userFullName;
        
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = [PFUser currentUser].email;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = [[PFUser currentUser]objectForKey:@"School_Name"];
    }
    if (indexPath.row == 3) {
        NSString *gradeString = @"Grade: ";
        cell.textLabel.text = [gradeString stringByAppendingString:[[PFUser currentUser]objectForKey:@"User_Grade"]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    return cell;
    
}






@end
