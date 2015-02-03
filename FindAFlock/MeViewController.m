//
//  MeViewController.m
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 12/1/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import "MeViewController.h"
#import <Parse/Parse.h>
#import "MeFlightsTableViewController.h"
#import "MeFriendsCollectionViewController.h"
#import "FlightDetailViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIView *myFlightsView;
@property (weak, nonatomic) IBOutlet UIView *myFriendsView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@property NSArray *friendUsers;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSession *fbSession = [PFFacebookUtils session];
    NSString *accessToken = [fbSession accessToken];
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=%@", accessToken]];
    self.profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderWidth = 2.5f;
    self.profilePicture.layer.borderColor = [UIColor colorWithRed:0.733 green:0.878 blue:0.541 alpha:1].CGColor;
    
    MeFlightsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MeFlightsController"];
    [self addChildViewController: controller];
    [self.myFlightsView addSubview:controller.view];
    controller.view.frame = self.myFlightsView.bounds;
    
    MeFriendsCollectionViewController *collectionController = [self.storyboard instantiateViewControllerWithIdentifier:@"MeFriendsController"];
    [self addChildViewController: collectionController];
    [collectionController fetchMyFriends];
    [self.myFriendsView addSubview:collectionController.view];
    collectionController.view.frame = self.myFriendsView.bounds;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
