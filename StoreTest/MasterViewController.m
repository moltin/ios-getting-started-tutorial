//
//  MasterViewController.m
//  StoreTest
//
//  Created by Dylan McKee on 01/11/2015.
//  Copyright © 2015 Moltin. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <Moltin/Moltin.h>

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[Moltin sharedInstance] setPublicId:@"umRG34nxZVGIuCSPfYf8biBSvtABgTR8GMUtflyE"];
    
    [[[Moltin sharedInstance] product] listingWithParameters:nil success:^(NSDictionary *response) {
        // The array of products is at the "result" key
        self.objects = [response objectForKey:@"result"];
        
        // Reload the table view that'll be used to display the products...
        [self.tableView reloadData];
        
    } failure:^(NSDictionary *response, NSError *error) {
        // Something went wrong!
        NSLog(@"error = %@", error);
    }];
    
    UIBarButtonItem *checkoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Checkout!" style:UIBarButtonItemStylePlain target:self action:@selector(checkout)];
    self.navigationItem.rightBarButtonItem = checkoutItem;
    
}

-(void)checkout {
    // Perform the checkout (with hardcoded user data for tutorial sake)
    // Define the order parameters (hardcoded in this example)
    
    // You'll likely always want to hardcode 'gateway' so that it matches your store's payment gateway slug.
    NSDictionary *orderParameters = @{
                                      @"customer" : @{ @"first_name" : @"Jon",
                                                       @"first_name" : @"Doe",
                                                       @"email" : @"jon.doe@gmail.com"
                                                       },
                                      @"shipping" : @"free-shipping",
                                      @"gateway"  : @"dummy",
                                      @"bill_to"  : @{ @"first_name" : @"Jon",
                                                       @"last_name" :  @"Doe",
                                                       @"address_1" :  @"123 Sunny Street",
                                                       @"address_2" :  @"Sunnycreek",
                                                       @"city" :       @"Sunnyvale",
                                                       @"county" :     @"California",
                                                       @"country" :    @"US",
                                                       @"postcode" :   @"CA94040",
                                                       @"phone" :      @"6507123124"
                                                       },
                                      @"ship_to"  : @"bill_to"
                                      };
    
    [[Moltin sharedInstance].cart orderWithParameters:orderParameters
                                              success:^(NSDictionary *response) {
        // Checkout order succeeded! Let's go on to payment too...
        // Extract the Order ID so that it can be used in payment too...
        NSString *orderId = [response valueForKeyPath:@"result.id"];
                              
        // These payment parameters would contain the card details entered by the user in the checkout UI flow...
        NSDictionary *paymentParameters = @{ @"data" : @{
                                             @"number"       : @"4242424242424242",
                                             @"expiry_month" : @"02",
                                             @"expiry_year"  : @"2017",
                                             @"cvv"          : @"123"
                                             }
                                            };
                                                  
        [[Moltin sharedInstance].checkout paymentWithMethod:@"purchase" order:orderId parameters:paymentParameters success:^(NSDictionary *response) {
            // Payment success too!
            // We'll show a UIAlertController to tell the user they're done.
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Order complete!" message:@"Order complete and your payment has been processed - thanks for shopping with us!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okayButton];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            // In a production store app, this would be a great time to show a receipt...
            
            
        } failure:^(NSDictionary *response, NSError *error) {
            // Something went wrong with the payment...
            NSLog(@"Payment error: %@", error);
        }];
         
     } failure:^(NSDictionary *response, NSError *error) {
         // Something went wrong with the order...
         NSLog(@"Order error: %@", error);
         
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object valueForKey:@"title"];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
