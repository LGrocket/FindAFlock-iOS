//
//  DetailViewController.h
//  TestingMasterDetail
//
//  Created by Lucas Rockett Gutterman on 11/17/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightsModel.h"

@interface FlightDetailViewController : UIViewController

@property (strong, nonatomic) Flight* detailItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;

- (void)setNavigationClose:(BOOL)addButton;
- (void)savedToggle;



@end

