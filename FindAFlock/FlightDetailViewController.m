//
//  DetailViewController.m
//  TestingMasterDetail
//
//  Created by Lucas Rockett Gutterman on 11/17/14.
//  Copyright (c) 2014 Lucas Gutterman. All rights reserved.
//

#import "FlightDetailViewController.h"
#import "FlightsModel.h"
#import <Parse/Parse.h>
#import "MeFriendsCollectionViewController.h"

@interface FlightDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *soarButton;
@property (weak, nonatomic) IBOutlet UIView *friendCollectionView;
@property BOOL *addButton;

@property MeFriendsCollectionViewController *controller;


@end

@implementation FlightDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Flight*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

-(void)savedToggle {
    [self.controller fetchFlockWithFlightID:self.detailItem.parseID];
}

- (void)setNavigationClose:(BOOL)addButton {
    if (addButton) {
        self.addButton = YES;
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        if ([self.detailItem.type.lowercaseString isEqual:@"food"])
            [self.typeIcon setImage:[UIImage imageNamed:@"restaurant-25"]];
        else if ([self.detailItem.type.lowercaseString isEqual:@"drinks"])
            [self.typeIcon setImage:[UIImage imageNamed:@"beer_glass-25"]];
        else
            [self.typeIcon setImage:[UIImage imageNamed:@"conference-25"]];
        
        self.typeLabel.text = self.detailItem.type;
        self.locationLabel.text = self.detailItem.location;
        PFQuery *query = [PFQuery queryWithClassName:@"Flight"];
        [query getObjectInBackgroundWithId:self.detailItem.parseID block:^(PFObject *flight, NSError *error) {
            if ([[flight objectForKey:@"users"] containsObject:[PFUser currentUser].username]) {
                self.soarButton.selected = YES;
            }
            else {
                self.soarButton.selected = NO;
            }
        }];

        if (self.addButton) {
            [self.closeButton setHidden:false];
        }
    }
}

- (IBAction)didPressSoar {
    [self.detailItem toggleUserJoins:self];
    self.soarButton.selected = !self.soarButton.selected;
    
}
- (IBAction)didPressClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self.soarButton setTitle:@"Leave" forState:UIControlStateSelected];
    
    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MeFriendsController"];
    [self addChildViewController: self.controller];
    [self.controller fetchFlockWithFlightID:self.detailItem.parseID];
    [self.friendCollectionView addSubview:self.controller.view];
    self.controller.view.frame = self.friendCollectionView.bounds;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
