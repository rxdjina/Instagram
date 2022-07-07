//
//  SignUpViewController.h
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/4/22.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
