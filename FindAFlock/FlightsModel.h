//
//  FlightsModal1.h
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/3/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#ifndef FindAFlock_FlightsModel_h
#define FindAFlock_FlightsModel_h

#import <Parse/Parse.h>

@interface Flight : NSObject

@property NSString *parseID;
@property NSString *location;
@property NSString *type;
@property NSMutableArray *users;

- (void)toggleUserJoins:(UIViewController *)caller;

@end

#endif
