//
//  FriendFlightsTableViewCell.h
//  FindAFlock
//
//  Created by Lucas Rockett Gutterman on 11/4/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendFlightsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
