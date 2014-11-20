//
//  NewFlightsTableViewController.m
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/3/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import "NewFlightsTableViewController.h"
#import "FriendsFlightsContentController.h"
#import <Parse/Parse.h>

@interface NewFlightsTableViewController ()

@property NSIndexPath *lastSelected;
@property NSString *flightType;
@property int privacy;
@property (nonatomic, strong) PFGeoPoint *userLocation;

@end

@implementation NewFlightsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Flight Types Section
    if (indexPath.section == 0) {
        if (self.lastSelected != indexPath) {
            [[tableView cellForRowAtIndexPath:self.lastSelected] setSelected:false animated:true];
            [[tableView cellForRowAtIndexPath:self.lastSelected] setAccessoryType:UITableViewCellAccessoryNone];
            
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            
            self.lastSelected = indexPath;
        }
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:false animated:true];
        
    }
    //Final Soar Section
    if (indexPath.section == 2) {
        if ( [[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"Friends"] )
            self.privacy = 1;
        else
            self.privacy = 0;
        
        //Do input validation here
        
        PFObject *newFlight = [PFObject objectWithClassName:@"Flight"];
        NSString *ftype;
        switch (self.lastSelected.row) {
            case 0:
                ftype = @"Food";
                break;
                
            case 1:
                ftype = @"Drinks";
                break;

            default:
                ftype = @"Anything";
                break;
        }
        newFlight[@"type"] = ftype;
        newFlight[@"privacy"] = (self.privacy) ? @"friends" : @"locals";
        UITextField *locationField = (UITextField *)[tableView viewWithTag:1].subviews[0];
        newFlight[@"location"] = locationField.text;
        
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                NSLog(@"User Location determined");
                newFlight[@"createdGeoLocation"] = geoPoint;
                [newFlight saveInBackground];
            }
            else {
                NSLog(error);
            }
            
        }];

        [self.navigationController popViewControllerAnimated:true];
    }

}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cell;
}*/


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
    
    [[segue destinationViewController] fetchData];
}

@end
