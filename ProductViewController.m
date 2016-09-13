//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "productClass.h"
#import "AddNewProductViewController.h"





@interface ProductViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProductViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
 //    self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the navigation bar
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Add the backButton on the left side of navigation bar
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [backButton release];
    
    // Add the addButton in navigation bar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewProduct)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    [addButton release];
    
    // set the empty or bottom view hidded
    self.bottomView.hidden = YES;

    
    
   }

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Set up company Image, Name, Ticker on the top view
    self.imgCompany.image = [UIImage imageNamed:self.company.companyName];
    
    if (self.imgCompany.image == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:self.company.companyName];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        self.imgCompany.image = image;
        
    }
    
    self.lblNameAndTicker.text = [NSString stringWithFormat:@"%@ (%@)", self.company.companyName, self.company.companyTicker];
    
    if ([self.company.productsArray count] > 0) {
        
        // set the empty or bottom view hidded
        self.bottomView.hidden = YES;
    } else {
        
        self.bottomView.hidden = NO;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
        [self.tableView reloadData];
 
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    // overide the edit navigationItem
    [super setEditing:editing animated:animated];
}

-(void)insertNewProduct
{
    // Create the next view controller
    AddNewProductViewController *addNewProductViewController = [[AddNewProductViewController alloc]initWithNibName:@"AddNewProductViewController" bundle:nil];
    
    addNewProductViewController.company = self.company;
    
    [self setTransitionAnimation];
    
    [self.navigationController pushViewController:addNewProductViewController animated:YES];
    [addNewProductViewController release];
    
}

-(void)backButtonPressed
{
    [self setTransitionAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.company.productsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    productClass *product = [self.company.productsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = product.productName;
    cell.imageView.image = [UIImage imageNamed:product.productImage];
    
    // cell.imageView.image will be nil because it can not find the mathch in Images.xcassets
    // then we search through the document directory
    
    if (cell.imageView.image == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:product.productName];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        cell.imageView.image = image;
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    detailsViewController *detailViewController = [[detailsViewController alloc] initWithNibName:@"detailsViewController" bundle:nil];
    

    // Pass the selected object to the new view controller.
    productClass *product = self.company.productsArray[indexPath.row];
    
    
    // Create the product reference to the new view controller
    detailViewController.product = product;
    detailViewController.company = _company;
    
    // Set animation for transition between view controller
    [self setTransitionAnimation];
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[DAO sharedInstance]deleteProduct:self.company.productsArray[indexPath.row]];
        
        // Delete the row from the data source
        [self.company.productsArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
    
    if ([self.company.productsArray count] == 0) {
        self.bottomView.hidden = NO;
    }
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    productClass *product = self.company.productsArray[fromIndexPath.row];
    [self.company.productsArray removeObject:product];
     [self.company.productsArray insertObject:product atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}






- (void)dealloc {
    [_tableView release];
    [_topView release];
    [_bottomView release];
    [_imgCompany release];
    [_lblNameAndTicker release];
    [_company release];
   
    [super dealloc];
}
- (IBAction)addButtonPressed:(id)sender {
    
    // Create the next view controller
    AddNewProductViewController *addNewProductViewController = [[AddNewProductViewController alloc]initWithNibName:@"AddNewProductViewController" bundle:nil];
    
    addNewProductViewController.company = self.company;
    
    [self setTransitionAnimation];
    [self.navigationController pushViewController:addNewProductViewController animated:YES];
    
    [addNewProductViewController release];
    
    
}

-(void)setTransitionAnimation
{
    // Set transition between view controller
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    return [self.navigationController.view.layer addAnimation:transition forKey:nil];
}
@end
