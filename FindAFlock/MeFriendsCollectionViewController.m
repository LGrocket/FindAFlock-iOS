//
//  MeFriendsCollectionViewController.m
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 12/1/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import "MeFriendsCollectionViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import "MeFriendsCollectionViewCell.h"

@interface MeFriendsCollectionViewController ()

@property NSArray *friendUsers;
@property NSMutableArray *friendIds;

@end

@implementation MeFriendsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)fetchMyFriends {
    [self.friendIds removeAllObjects];
    // Cite: https://parse.com/questions/how-can-i-find-parse-users-that-are-facebook-friends-with-the-current-user
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            self.friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [self.friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:self.friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            [self.collectionView reloadData];
        }
    }];
}

-(void)fetchFlockWithFlightID:(NSString *)flightID {
    // Cite: https://parse.com/questions/how-can-i-find-parse-users-that-are-facebook-friends-with-the-current-user
    // Issue a Facebook Graph API request to get your user's friend list
    PFQuery *query = [PFQuery queryWithClassName:@"Flight"];
    [query getObjectInBackgroundWithId:flightID block:^(PFObject *flight, NSError *error) {
        NSArray *userIDs = flight[@"users"];
        self.friendIds = [NSMutableArray new];
        if ([userIDs count] > 0) {
            for(NSString *userID in userIDs){
                PFQuery *query = [PFUser query];
                [query whereKey:@"username" equalTo:userID];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    [self.friendIds addObject:objects[0][@"fbId"]];
                    [self.collectionView reloadData];
                }];
            }
        } else {
            [self.collectionView reloadData];
        }
        
    }];
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 90, 0, 0);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.friendIds count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeFriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    NSString *facebookFriend = [self.friendIds objectAtIndex:indexPath.row];
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookFriend]]];
    cell.profileView.image = [UIImage imageWithData:imageData];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width / 2;
    cell.profileView.clipsToBounds = YES;
    cell.profileView.layer.borderWidth = 2.5f;
    cell.profileView.layer.borderColor = [UIColor colorWithRed:0.945 green:1 blue:0.996 alpha:1].CGColor;

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
