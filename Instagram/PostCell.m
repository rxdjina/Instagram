//
//  PostCell.m
//  Pods
//
//  Created by Rodjina Pierre Louis on 7/6/22.
//

#import "PostCell.h"
#import "Parse/Parse.h"
@import Parse;

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setPost:(Post *)post {
    _post = post;
    self.postImage.file = post[@"image"];
    [self.postImage loadInBackground];
}

@end
