//
//  ProfileViewController.m
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/6/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (PFUser.currentUser) {
        NSLog(@"Loaded current user: %@", PFUser.currentUser.username);
        
        self.usernameLabel.text = PFUser.currentUser.username;
        self.nameLabel.text = PFUser.currentUser[@"fullName"];
        
        PFFileObject *image = PFUser.currentUser[@"profilePicture"];
        NSData *imageData = image.getData;
        
        self.profilePhotoLabel.image = [UIImage imageWithData:imageData];
        self.profilePhotoLabel.layer.cornerRadius = self.profilePhotoLabel.frame.size.width / 2;
        self.profilePhotoLabel.clipsToBounds = true;
    }
}

- (IBAction)pressedProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    self.profilePhotoLabel.layer.cornerRadius = self.profilePhotoLabel.frame.size.width / 2;
    self.profilePhotoLabel.clipsToBounds = true;
    
    NSData *imageData = UIImagePNGRepresentation(editedImage);

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    NSString *objectID = PFUser.currentUser.objectId;

    [query getObjectInBackgroundWithId:objectID
                                 block:^(PFObject *parseObject, NSError *error) {
        if (parseObject) {
            NSLog(@"Successfully loaded parse object");
            
            parseObject[@"profilePicture"] = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
            
            [parseObject saveInBackground];
            
        } else {
            NSLog(@"Error loading parse object: %@", error.localizedDescription);
        }
    }];

    self.profilePhotoLabel.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
