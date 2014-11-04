	//
//  FriendsFlightsContentViewController.h
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/1/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsFlightsContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;

@end
