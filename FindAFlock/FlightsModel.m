//
//  FlightsModel.m
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/3/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightsModel.h"
#import "FlightDetailViewController.h"


@interface Flight ()

@end

@implementation Flight

- (void)toggleUserJoins:(FlightDetailViewController *)caller {
    PFQuery *query = [PFQuery queryWithClassName:@"Flight"];
    [query getObjectInBackgroundWithId:self.parseID block:^(PFObject *flight, NSError *error) {
        if ([[flight objectForKey:@"users"] containsObject:[PFUser currentUser].username]) {
            [flight removeObject:[PFUser currentUser].username forKey:@"users"];
        }
        else {
            [flight addObject:[PFUser currentUser].username forKey:@"users"];
        }
        [flight saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            [caller savedToggle];
        }];
    }];
}

@end