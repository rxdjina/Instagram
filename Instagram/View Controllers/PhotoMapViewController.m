//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by Rodjina Pierre Louis on 7/4/22.
//

#import "PhotoMapViewController.h"
#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "Post.h"

@interface PhotoMapViewController ()

@property (strong, nonatomic) NSString *userInput;
@property (strong, nonatomic) IBOutlet UITextView *captionTextView;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UITextViewTextDidChangeNotification) {
        self.captionTextView.delegate = self;
    }
}

- (IBAction)didTapNewPost:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera unavailable, switching to photo library...");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)addPhotoFromLibraryButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    self.selectedPhoto.image = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)pressedShare:(id)sender {
    [Post postUserImage:self.selectedPhoto.image withCaption:self.userInput withCompletion:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Sucessfully uploaded post");
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.captionTextView.text = @"";
    self.captionTextView.textColor = [UIColor blackColor];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.captionTextView.text.length == 0) {
        self.captionTextView.textColor = [UIColor lightGrayColor];
        self.captionTextView.text = @"Write a caption...";
        [self.captionTextView resignFirstResponder];
    }
    
    self.userInput = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.captionTextView.text.length == 0) {
        self.captionTextView.textColor = [UIColor lightGrayColor];
        self.captionTextView.text = @"Sample Text";
        [self.captionTextView resignFirstResponder];
    }
}

@end
