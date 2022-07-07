//
//  ProfileViewController.m
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/6/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"


@interface ProfileViewController ()

@property (nonatomic, strong) NSArray *arrayOfPersonalPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    if (PFUser.currentUser) {
        NSLog(@"Loaded current user: %@", PFUser.currentUser.username);
        
        self.usernameLabel.text = PFUser.currentUser.username;
        self.nameLabel.text = PFUser.currentUser[@"fullName"];
        
        PFFileObject *image = PFUser.currentUser[@"profilePicture"];
        NSData *imageData = image.getData;
    
        self.profilePhotoLabel.image = [UIImage imageWithData:imageData];
        self.profilePhotoLabel.layer.cornerRadius = self.profilePhotoLabel.frame.size.width / 2;
        self.profilePhotoLabel.clipsToBounds = true;
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
        [self.collectionView insertSubview:self.refreshControl atIndex:0];
        
        [self loadPosts];
        
        self.postCountLabel.text = [NSString stringWithFormat:@"%lu", self.arrayOfPersonalPosts.count];
        
        [self.refreshControl endRefreshing];
    }
}

- (void)loadPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByAscending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:PFUser.currentUser];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.arrayOfPersonalPosts = posts;
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"Error loading posts: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPersonalPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    int numberOfCellInRow = 3;
    CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
    
    Post *post = self.arrayOfPersonalPosts[indexPath.row];
    PFUser *user = post.author;
    
    PFFileObject *postImage = post.image;
    NSData *postImageData = postImage.getData;
    
    //
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth)];

    UIImage *image = [UIImage imageWithData:postImageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    imageView.frame = catView.bounds;

    [catView addSubview:imageView];

    [cell.contentView addSubview:catView];

    return cell;
}
@end
