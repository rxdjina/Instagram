//
//  LogInViewController.m
//  Instagram
//
//  Created by Rodjina Pierre Louis on 6/29/22.
//

#import "LogInViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface LogInViewController ()

@end


@implementation LogInViewController

@synthesize usernameField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)registerUser {
    // Initialize User Object
    PFUser *newUser = [PFUser user];

    // Set Properties
    NSString *fullName = self.nameField.text;
    newUser.username = [self.usernameField.text lowercaseString];
    newUser.password = self.passwordField.text;
    newUser.email = [self.emailField.text lowercaseString];
    newUser[@"fullName"] = [fullName capitalizedString];

    
    // Call Sign Up Function
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        }
    }];
}

- (void)loginUser {
    NSString *username = [self.usernameField.text lowercaseString];
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError * error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in sucessfully");

            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}

- (IBAction)signUpButton:(id)sender {
    [self registerUser];
}




//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"TimelineViewController"])
//    {
//        UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimelineViewController"];
//
//        [self.navigationController pushViewController:homeVC animated:true];
//    }
//}


@end
