//
//  FriendsFlightsContentController.m
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/3/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import "FriendsFlightsContentController.h"
#import "FlightsModel.h"
#import "FlightTableViewCell.h"
#import <Parse/Parse.h>
#import "CustomLoginViewController.h"
#import "FlightDetailViewController.h"

@interface FriendsFlightsContentController ()

@property NSMutableArray* friendsFlights;
@property UIViewController* nFlightView;

@end

@implementation FriendsFlightsContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Parse Login Screen
    CustomLoginViewController *logInController = [CustomLoginViewController new];
    logInController.fields = PFLogInFieldsFacebook;
    logInController.delegate = logInController;
    [self presentViewController:logInController animated:YES completion:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self fetchData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear {
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewFlight:(id)sender {
    UIViewController *newFlights = [self.storyboard instantiateViewControllerWithIdentifier:@"newFlightsView"];
    [self.navigationController pushViewController:newFlights animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.friendsFlights count];
}

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"Flight"];
    [query whereKey:@"privacy" equalTo:@"friends"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.friendsFlights = [NSMutableArray new];
            NSLog(@"Successfully retrieved %lu flights.", (unsigned long)objects.count);
            for (PFObject *object in objects) {
                Flight *currFlight = [Flight new];
                currFlight.location = object[@"location"];
                currFlight.type = object[@"type"];
                currFlight.parseID = object.objectId;
                [self.friendsFlights addObject:currFlight];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"Reloaded data");
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendFlights" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FlightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"FriendFlights"];
    }
    
    Flight *flight = [self.friendsFlights objectAtIndex:indexPath.row];
    cell.typeLabel.text = flight.type;
    if ([flight.type.lowercaseString isEqual:@"food"])
        [cell.typeIcon setImage:[UIImage imageNamed:@"restaurant-25"]];
    else if ([flight.type.lowercaseString isEqual:@"drinks"])
        [cell.typeIcon setImage:[UIImage imageNamed:@"beer_glass-25"]];
    else
        [cell.typeIcon setImage:[UIImage imageNamed:@"conference-25"]];
    
    cell.locationLabel.text = flight.location;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Flight *selectedFlight = self.friendsFlights[indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedFlight];
    }
}

@end