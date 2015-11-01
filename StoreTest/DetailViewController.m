//
//  DetailViewController.m
//  StoreTest
//
//  Created by Dylan McKee on 01/11/2015.
//  Copyright © 2015 Moltin. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        // Set the item title from the detailItem dictionary's 'title' key
        self.titleLabel.text = [self.detailItem valueForKey:@"title"];
        
        // Set the formatted price with tax by looking at the key path in the detailItem dictionary
        self.priceLabel.text = [self.detailItem valueForKeyPath:@"price.data.formatted.with_tax"];
        
        // Set the item description from the detailItem dictionary's 'description' key
        self.descriptionLabel.text = [self.detailItem valueForKey:@"description"];
    }
}

-(IBAction)addToCart:(id)sender {
    // Get the current product's ID string from the detailItem product info dictionary...
    NSString *productId = [self.detailItem valueForKey:@"id"];
    
    [[[Moltin sharedInstance] cart] insertItemWithId:productId quantity:1 andModifiersOrNil:nil success:^(NSDictionary *response) {
        // Added to cart!
        // We'll show a UIAlertController to tell the user what we've done...
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Added to cart!" message:@"Added item ot cart!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okayButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    } failure:^(NSDictionary *response, NSError *error) {
        // Something went wrong...
        NSLog(@"Could not add to cart - error = %@", error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
