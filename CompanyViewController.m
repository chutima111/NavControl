//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "companyInfoClass.h"
#import "productClass.h"
#import "DAO.h"
#import "AddNewCompanyViewController.h"
#import "EditCompanyViewController.h"

@interface CompanyViewController ()

@property (nonatomic, strong) DAO * dao;

@end

@implementation CompanyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Set the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Add the addButton in navigation bar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewCompany)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    // self.navigationController.navigationBar.hidden = NO;
    
    // Set the navigation bar to color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:87.0/255 green:158.0/255 blue:38.0/255 alpha:1.0];
    
    // Set the navigation item to color
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // Set the navigation title
    self.title = @"Watch List";
    
    // ADD ALL THE COMPANIES
    
    self.dao = [DAO sharedInstance];
    [self.dao createCompaniesAndProducts];
    self.companies = self.dao.companyList;
    
    // Allow the select the cell during the editing mode
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // Listen to the post when data (Stock price) is done downloading
    // And I want to refresh or reload table view to show the stock price
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"StockDataReceived"
                                               object:nil];
    
    [self.dao getStockPrice];
    
}



-(void)refreshData
{
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

-(void)insertNewCompany
{
    //Create the next view controller
    AddNewCompanyViewController *addNewCompanyViewController = [[AddNewCompanyViewController alloc] initWithNibName:@"AddNewCompanyViewController" bundle:nil];
    
    // Push the view controller
    [self.navigationController pushViewController:addNewCompanyViewController animated:YES];
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
    return [self.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell...
    companyInfoClass *company = [self.companies objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = company.companyName;
    
    // set images all the same size
    UIImage *unscaledImage = [UIImage imageNamed:company.companyImageName];
    cell.imageView.image = [self reSizeImage:unscaledImage toSize:CGSizeMake(50,50)];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %@", company.stockPrice];
    
    // cell.imageView.image will be nil because it can not find the mathch in Images.xcassets
    // then we search through the document directory
    if (cell.imageView.image == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:company.companyName];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        cell.imageView.image = image;
    }
    
    // ADD accessory type to be able to edit the cell
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
        // Delete the row from the data source
        [self.companies removeObjectAtIndex:indexPath.row];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    companyInfoClass *company = [self.companies objectAtIndex:fromIndexPath.row];
    [self.companies removeObject:company];
    [self.companies insertObject:company atIndex:toIndexPath.row];
}





// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if tabel view is on editing mode
    // I want to be able to select the cell and do something with it
    if (tableView.editing == YES) {
        
        companyInfoClass *company = self.companies[indexPath.row];
        
        // Create the next view controller
        EditCompanyViewController *editCompanyViewController = [[EditCompanyViewController alloc]initWithNibName:@"EditCompanyViewController" bundle:nil];
        
        // Pass the company information to the next view controller
        editCompanyViewController.title = company.companyName;
        editCompanyViewController.company = company;
        
        [self.navigationController pushViewController:editCompanyViewController animated:YES];
        
        
    } else {
        
        // if the table view is not on editing mode do something when the select the cell
        companyInfoClass *company = self.companies[indexPath.row];
        self.productViewController.title = company.companyName;
        self.productViewController.company = company;
        
        
        [self.navigationController pushViewController:self.productViewController animated:YES];
    }
    
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


@end
