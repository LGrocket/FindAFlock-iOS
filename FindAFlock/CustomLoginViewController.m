//
//  CustomLoginViewController.m
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/4/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import "CustomLoginViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface CustomLoginViewController ()

@end

@implementation CustomLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.576 green:0.816 blue:0.976 alpha:1];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"findaflock-logo"]];
    logo.frame = CGRectMake(0, 0, 235, 235);
    self.logInView.logo = logo; // logo can be any UIView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    if (user) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Store the current user's Facebook ID on the user
                [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"fbId"];
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
