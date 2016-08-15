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

@interface CompanyViewController ()
{
    NSMutableArray *companyLogoImageArray;
}

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"Mobile device makers";
    
    
    // GROUP Things together using companyInfoClass and productClass
    // Group apple company and its products
    companyInfoClass *apple = [[companyInfoClass alloc]init];
    apple.companyName = @"Apple mobile devices";
    apple.companyImageName = @"apple company logo";
    apple.productsArray = [NSMutableArray array];
    
    productClass *iPhone = [[productClass alloc] init];
    iPhone.productName = @"iPhone";
    iPhone.productImage = @"iPhone pic";
    iPhone.productUrl = @"http://www.apple.com/iphone/";
    
    productClass *iPad = [[productClass alloc] init];
    iPad.productName = @"iPad";
    iPad.productImage = @"iPad pic";
    iPad.productUrl = @"http://www.apple.com/ipad/";
    
    productClass *iPod = [[productClass alloc] init];
    iPod.productName = @"iPod";
    iPod.productImage = @"iPod pic";
    iPod.productUrl = @"http://www.apple.com/ipod/";
    
    // Add product information in the apple company
    [apple.productsArray addObject:iPhone];
    [apple.productsArray addObject:iPad];
    [apple.productsArray addObject:iPod];
    
    // GROUP SAMSUNG COMPANY AND ITS PRODUCT
    companyInfoClass *samsung = [[companyInfoClass alloc] init];
    samsung.companyName = @"Samsung mobile devices";
    samsung.companyImageName = @"samsung company logo";
    samsung.productsArray = [NSMutableArray array];
    
    productClass *samsungGalaxyS4 = [[productClass alloc] init];
    samsungGalaxyS4.productName = @"Samsung Galaxy S4";
    samsungGalaxyS4.productImage = @"samsung galaxy s4 pic";
    samsungGalaxyS4.productUrl = @"http://www.samsung.com/us/mobile/phones/galaxy-s/samsung-galaxy-s4-prepaid-verizon-black-sch-i545zkpvzw/";
    
    productClass *samsungGalaxyNote = [[productClass alloc] init];
    samsungGalaxyNote.productName = @"Samsung Galaxy Note";
    samsungGalaxyNote.productImage = @"samsung galaxy note pic";
    samsungGalaxyNote.productUrl = @"http://www.samsung.com/us/mobile/phones/galaxy-note/samsung-galaxy-note5-32gb-t-mobile-black-sapphire-sm-n920tzkatmb/";
    
    productClass *samsungGalaxyTap = [[productClass alloc]init];
    samsungGalaxyTap.productName = @"Samsung Galaxy Tap";
    samsungGalaxyTap.productImage = @"samsung tap pic";
    samsungGalaxyTap.productUrl = @"http://www.samsung.com/us/mobile/tablets/all-other-tablets/samsung-galaxy-tab-4-10-1-16gb-wi-fi-black-sm-t530nyksxar/";
    // ADD SAMSUNG product into samsung company
    [samsung.productsArray addObject:samsungGalaxyS4];
    [samsung.productsArray addObject:samsungGalaxyNote];
    [samsung.productsArray addObject:samsungGalaxyTap];
    
    // GROUP LG COMPANY AND ITS PRODUCT
    companyInfoClass *lg = [[companyInfoClass alloc] init];
    lg.companyName = @"LG mobile devices";
    lg.companyImageName = @"LG company logo";
    lg.productsArray = [NSMutableArray array];
    
    // List LG products (LG Phone, LG Tablet, LG Watch)
    productClass *lgPhone = [[productClass alloc]init];
    lgPhone.productName = @"LG Phone";
    lgPhone.productImage = @"LG phone pic";
    lgPhone.productUrl = @"http://www.lg.com/us/cell-phones";
    
    productClass *lgTablet = [[productClass alloc]init];
    lgTablet.productName = @"LG Tablet";
    lgTablet.productImage = @"LG pad pic";
    lgTablet.productUrl = @"http://www.lg.com/us/tablets";
    
    productClass *lgWatch = [[productClass alloc]init];
    lgWatch.productName = @"LG Watch";
    lgWatch.productImage = @"LG watch pic";
    lgWatch.productUrl = @"http://www.lg.com/us/smart-watches";
    
    // Add LG product to LG company
    [lg.productsArray addObject:lgPhone];
    [lg.productsArray addObject:lgTablet];
    [lg.productsArray addObject:lgWatch];
    
    // GROUP HTC COMPANY AND ITS PRODUCTS
    companyInfoClass *htc = [[companyInfoClass alloc]init];
    htc.companyName = @"HTC mobile devices";
    htc.companyImageName = @"htc company logo";
    htc.productsArray = [NSMutableArray array];
    
    // List HTC products (htc desire, htc One A9, htc Evo)
    productClass *htcDesire = [[productClass alloc]init];
    htcDesire.productName = @"htc Desire";
    htcDesire.productImage = @"htc desire";
    htcDesire.productUrl = @"http://www.htc.com/us/smartphones/htc-desire/";
    
    productClass *htcOne = [[productClass alloc]init];
    htcOne.productName = @"htc One";
    htcOne.productImage = @"htc one";
    htcOne.productUrl = @"http://www.htc.com/us/smartphones/htc-one-a9/";
    
    productClass *htcEvo = [[productClass alloc]init];
    htcEvo.productName = @"htc Evo";
    htcEvo.productImage = @"htc evo";
    htcEvo.productUrl = @"http://www.htc.com/us/smartphones/htc-evo-4g-lte/";
    
    // Add the htc products to the HTC company
    [htc.productsArray addObject:htcDesire];
    [htc.productsArray addObject:htcOne];
    [htc.productsArray addObject:htcEvo];
    
    self.companyList = [NSMutableArray array];
    
    // ADD ALL COMPANYS TO COMPANY ARRAY
    [self.companyList addObject:apple];
    [self.companyList addObject:samsung];
    [self.companyList addObject:lg];
    [self.companyList addObject:htc];
    
    // Add images of each company in the companyLogoImageArray
    companyLogoImageArray = [@[apple.companyImageName, samsung.companyImageName, lg.companyImageName, htc.companyImageName]mutableCopy];
   
    
    
    //SETUP THE PRODUCTS
    
//    //apple
//    self.appleProducts = [@[@"iPad", @"iPod Touch",@"iPhone"]mutableCopy];
//    self.appleProductImages = [@[@"iPad pic", @"iPod pic", @"iPhone pic"]mutableCopy];
//    self.appleProductUrls = [@[@"http://www.apple.com/ipad/", @"http://www.apple.com/ipod/", @"http://www.apple.com/iphone/"]mutableCopy];
//    
//    //samsung
//    self.samsungProducts = [@[@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab"]mutableCopy];
//    self.samsungProductImages = [@[@"samsung galaxy s4 pic", @"samsung galaxy note pic", @"samsung tap pic"]mutableCopy];
//    self.samsungProductUrls = [@[@"http://www.samsung.com/us/mobile/phones/galaxy-s/samsung-galaxy-s4-prepaid-verizon-black-sch-i545zkpvzw/",
//                               @"http://www.samsung.com/us/mobile/phones/galaxy-note/samsung-galaxy-note5-32gb-t-mobile-black-sapphire-sm-n920tzkatmb/", @"http://www.samsung.com/us/mobile/tablets/all-other-tablets/samsung-galaxy-tab-4-10-1-16gb-wi-fi-black-sm-t530nyksxar/"]mutableCopy];
//    //LG
//    self.lgProducts = [@[@"LG Phone", @"LG Pad", @"LG Watch"]mutableCopy];
//    self.lgProductImages = [@[@"LG phone pic", @"LG pad pic", @"LG watch pic"]mutableCopy];
//    self.lgProductUrls = [@[@"http://www.lg.com/us/cell-phones", @"http://www.lg.com/us/tablets", @"http://www.lg.com/us/smart-watches"]mutableCopy];
//    
//    // htc
//    self.htcProducts = [@[@"htc desire", @"htc One A9", @"htc Evo"]mutableCopy];
//    self.htcProductImages = [@[@"htc desire", @"htc one", @"htc evo"]mutableCopy];
//    self.htcProductUrls = [@[@"http://www.htc.com/us/smartphones/htc-desire/", @"http://www.htc.com/us/smartphones/htc-one-a9/", @"http://www.htc.com/us/smartphones/htc-evo-4g-lte/"]mutableCopy];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    companyInfoClass *company = [self.companyList objectAtIndex:[indexPath row]];

    
    cell.textLabel.text = company.companyName;
    cell.imageView.image = [UIImage imageNamed:company.companyImageName];
    
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
        [_companyList removeObjectAtIndex:indexPath.row];
        [companyLogoImageArray removeObjectAtIndex:indexPath.row];
         
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
    companyInfoClass *company = [self.companyList objectAtIndex:fromIndexPath.row];
    [self.companyList removeObject:company];
    [self.companyList insertObject:company atIndex:toIndexPath.row];
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
    
    /*    if (indexPath.row == 0){
     self.productViewController.title = @"Apple mobile devices";
     } else {
     self.productViewController.title = @"Samsung mobile devices";
     }
     */
    
    companyInfoClass *company = self.companyList[indexPath.row];
    self.productViewController.title = company.companyName; //@"Apple mobile devices";
    self.productViewController.products = company.productsArray;
    
    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
    

}
 


@end
