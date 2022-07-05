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


@interface HomeFeedViewController ()

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];

    appDelegate.window.rootViewController = loginViewController;

    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

@end;
