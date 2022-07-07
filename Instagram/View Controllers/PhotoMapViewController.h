//
//  PhotoMapViewController.h
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/4/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoMapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedPhoto;

@end

NS_ASSUME_NONNULL_END
