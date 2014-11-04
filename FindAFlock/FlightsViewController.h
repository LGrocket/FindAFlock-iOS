//
//  FirstViewController.h
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/1/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsFlightsContentViewController.h"


@interface FlightsViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

@end

