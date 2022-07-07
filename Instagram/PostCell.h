//
//  PostCell.h
//  Pods
//
//  Created by Rodjina Pierre Louis on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"

@import Parse;

NS_ASSUME_NONNULL_BEGIN


@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet PFImageView  *postImage;
@property (strong, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) User *user;


@end

NS_ASSUME_NONNULL_END
