//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/4/22.
//

#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LogInViewController.h"
#import "SceneDelegate.h"
#import "PostCell.h"
#import "DateTools.h"


@interface HomeFeedViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.dataSource = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self loadPosts];
    
    [self.refreshControl endRefreshing];
    
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];

    appDelegate.window.rootViewController = loginViewController;

    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

- (void)loadPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error loading posts: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

// Cells and Cell customization
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.arrayOfPosts[indexPath.row];
    PFUser *user = post.author;
    
    
    cell.userNameLabel.text = user.username;
//    cell.captionLabel.text = post.caption;
    
    // Caption
    NSString *fullCaption = [NSString stringWithFormat:@"%@ %@", user.username, post.caption];
    NSMutableAttributedString *formattedCaption = [[NSMutableAttributedString alloc] initWithString:fullCaption];
    NSString *boldString = user.username;
    NSRange captionRange = [fullCaption rangeOfString:boldString];
    [formattedCaption addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:captionRange];
    [cell.captionLabel setAttributedText: formattedCaption];
    
    // Likes Count
    cell.likesCountLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
    
    // Comments
    if (post.commentCount.intValue > 3) {
        cell.commentsCountLabel.text = [NSString stringWithFormat:@"View all %@ comments", post.commentCount];
    } else {
        cell.commentsCountLabel.text = @"";
    }
    
    // Date Label
    cell.timeLabel.text = [post.createdAt timeAgoSinceNow];
    
    // Post Image
    PFFileObject *postImage = post.image;
    NSData *postImageData = postImage.getData;
    cell.postImage.image = nil;
    cell.postImage.image = [UIImage imageWithData:postImageData];
    
    // Author Image
    PFFileObject *authorImage = user[@"profilePicture"];
    NSData *authorImageData = authorImage.getData;
    
    cell.userProfilePicture.image = [UIImage imageWithData:authorImageData];
    cell.userProfilePicture.layer.cornerRadius = cell.userProfilePicture.frame.size.width / 2;
    cell.userProfilePicture.clipsToBounds = true;
    
    return cell;
}

@end
