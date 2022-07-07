//
//  SignUpViewController.m
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/4/22.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "User.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize usernameField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *username = self.usernameField.text;
//    NSString *password = self.passwordField.text;
}


- (void)registerUser {
    // Initialize User Object
    PFUser *newUser = [PFUser user];

    // Set Properties
    newUser.username = self.user.sharedInstance.username;
    newUser.password = self.user.sharedInstance.password;

//    newUser.username = @"John";
//    newUser.password = @"Apple";
    
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

- (IBAction)signUpButton:(id)sender {
    [self registerUser];
}

- (IBAction)emailToNameButton:(id)sender {
    NSLog(@"%@", self.emailField.text);
//    self.user.email = self.emailField.text;
//    self.user.sharedInstance.email = self.emailField.text;
    [self performSegueWithIdentifier: @"emailToNameSegue" sender: self];
}

- (IBAction)nameToPasswordButton:(id)sender {
    self.user.sharedInstance.firstName = self.nameField.text;
}

- (IBAction)passwordToUsernameButton:(id)sender {
    self.user.sharedInstance.password = self.passwordField.text;
}

- (IBAction)usernameToSignUpButton:(id)sender {
    self.user.sharedInstance.username = self.usernameField.text;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier  isEqual: @"emailToName"]) {
//        NSString *dataToPass = self.emailField.text;
//        SignUpViewController *fullNameVC = [segue destinationViewController];
//        detailVC.emailField.text = dataToPass;
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(![segue.identifier isEqual: @"signUpSegue"]) {
        SignUpViewController *nextViewController = (SignUpViewController *)segue.destinationViewController;
        nextViewController.user = self.user;
    }
}

@end
