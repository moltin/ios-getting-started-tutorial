//
//  DetailViewController.h
//  StoreTest
//
//  Created by Dylan McKee on 01/11/2015.
//  Copyright © 2015 Moltin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Moltin/Moltin.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


-(IBAction)addToCart:(id)sender;

@end

