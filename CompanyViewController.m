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

#import "CompanyTableViewCell.h"




@interface CompanyViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIBarButtonItem *editButton;
}

@property (nonatomic, strong) DAO * dao;


@end

@implementation CompanyViewController
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//    self.tableView.clearsSelectionOnViewWillAppear = NO;
    
    
    // Set the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Add the addButton in navigation bar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewCompany)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Add the Done button in navigation bar
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    
    // self.navigationController.navigationBar.hidden = NO;
    
    // Set the navigation bar to color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:87.0/255 green:158.0/255 blue:38.0/255 alpha:1.0];
    
    // Set the navigation item to color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // Set the navigation title
    self.title = @"Watch List";
    
       
    // ADD ALL THE COMPANIES
    
    self.dao = [DAO sharedInstance];
    
    self.companies = self.dao.companyList;
    
    // Allow the select the cell during the editing mode
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // Listen to the post when data (Stock price) is done downloading
    // And I want to refresh or reload table view to show the stock price
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"StockDataReceived"
                                               object:nil];
    if ([self.companies count] == 0) {
        self.emptyView.hidden = NO;
    }
    else {
    [self.dao getStockPrice];
    }
    
    }



-(void)refreshData
{
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.companies count] == 0) {
        self.emptyView.hidden = NO;
    } else {
        
    self.emptyView.hidden = YES;
    [self.dao getStockPrice];
    }
    
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
    [self.tableView setEditing:editing animated:animated];
    
    // set the buttons not hidden when editing mode
    self.btnUndo.hidden = NO;
    self.btnRedo.hidden = NO;
}

-(void)editButtonPressed
{
    if (self.tableView.editing == NO) {
        
        [editButton setTitle:@"Done"];
        [self.tableView setEditing:YES animated:YES];
        self.btnUndo.hidden = NO;
        self.btnRedo.hidden = NO;
        
    } else {
        
        [editButton setTitle:@"Edit"];
        [self.tableView setEditing:NO animated:NO];
        self.btnUndo.hidden = YES;
        self.btnRedo.hidden = YES;
        [[DAO sharedInstance] saveChanges];
    }
    
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
    // Create custom tabel view cell
    
    static NSString *cellIdentifier = @"CompanyTableViewCell";
    
    CompanyTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CompanyTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }

    
    // Configure the cell...
    
    companyInfoClass *company = [self.companies objectAtIndex:indexPath.row];
    cell.lblCompanyName.text = company.companyName;
    cell.lblStockPrice.text = [NSString stringWithFormat:@"$ %@", company.stockPrice];
    cell.imgCompany.image = [UIImage imageNamed:company.companyImageName];
    
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
        
        [[DAO sharedInstance]deleteCompany:[self.companies objectAtIndex:indexPath.row]];
        
      //  [self.companies removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
    
    if ([self.companies count] == 0) {
        self.emptyView.hidden = NO;
    }
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
    // if table view is on editing mode
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

#pragma mark - Additional methods

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


- (IBAction)undoButtonPressed:(id)sender {
    
    [[DAO sharedInstance] undoLastAction];
    self.companies = [DAO sharedInstance].companyList;
    [self.dao getStockPrice];
    [self.tableView reloadData];
    
}

- (IBAction)redoButtonPressed:(id)sender {
    
    [[DAO sharedInstance] redoLastUndo];
    self.companies = self.dao.companyList;
    [self.dao getStockPrice];
    [self.tableView reloadData];
}

- (void)dealloc {
    [_btnUndo release];
    [_btnRedo release];
    [_emptyView release];
    [super dealloc];
}
@end
