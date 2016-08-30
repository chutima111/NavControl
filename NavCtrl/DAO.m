//
//  DAO.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"
#import "companyInfoClass.h"
#import "productClass.h"

#import "Company.h"
#import "Product.h"

@implementation DAO


+(DAO *)sharedInstance
{
    static DAO *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DAO alloc]init];
    });
    
    return sharedInstance;
    
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        //custom initializer
        [self createCoreData];
    }
    return self;
}

#pragma mark core data

-(void) createCoreData
{
    // 1. Create  ObjectModel
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    // 2. Create context
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error;
    
    NSLog(@"%@", path);
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    
    if (error) {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    // Add an undo manager
    _managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    
    // 3. Now the context points to the SQLite store
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    //try to load from core data
    [self reloadDataFromContext];
}

// Physical storage location in device
-(NSString *)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"NavCtrl.data"];
}

-(void)reloadDataFromContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    //
    //    // Specify criteria for filtering which objects to fetch
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //    [fetchRequest setPredicate:predicate];
    //    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"companyName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([fetchedObjects count] == 0) {
        [self createCompaniesAndProducts];
    } else {
        [self setCompanyList:[[NSMutableArray alloc]initWithArray:fetchedObjects]];
    }
    
}


#pragma mark create default values

-(void)createCompaniesAndProducts
{
    // Test : create default value for company in core data
    
    // Apple company
    Company *apple = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    
    [apple setCompanyName:@"Apple Inc"];
    [apple setCompanyImageName:@"Apple Inc"];
    [apple setCompanyTicker:@"AAPL"];
    
    Product *iPhone = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [iPhone setProductName:@"iPhone"];
    [iPhone setProductImage:@"iPhoneImage"];
    [iPhone setProductURL:@"http://www.apple.com/iphone/"];
    
    Product *iPad = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [iPad setProductName:@"iPad"];
    [iPad setProductImage:@"iPadImage"];
    [iPad setProductURL:@"http://www.apple.com/ipad/"];
    
    Product *iPod = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [iPod setProductName:@"iPod"];
    [iPod setProductImage:@"iPodImage"];
    [iPod setProductURL:@"http://www.apple.com/ipod/"];
    
    [apple addProductsObject:iPhone];
    [apple addProductsObject:iPad];
    [apple addProductsObject:iPod];
    
    
    // Google company
    Company *google = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    
    [google setCompanyName:@"Google"];
    [google setCompanyImageName:@"googleLogoImage"];
    [google setCompanyTicker:@"GOOG"];
    
    Product *gmail = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [gmail setProductName:@"Gmail"];
    [gmail setProductImage:@"gmailLogoImage"];
    [gmail setProductURL:@"https://www.google.com/gmail/about/"];
    
    Product *googleMaps = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [googleMaps setProductName:@"Google Maps"];
    [googleMaps setProductImage:@"googleMapsLogoImage"];
    [googleMaps setProductURL:@"https://maps.google.com/"];
    
    // Then add products to Google company
    [google addProductsObject:gmail];
    [google addProductsObject:googleMaps];
    
    // Tesla company
    Company *tesla = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    
    [tesla setCompanyName:@"Tesla"];
    [tesla setCompanyImageName:@"teslaLogoImage"];
    [tesla setCompanyTicker:@"TSLA"];
    
    Product *teslaModelS = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [teslaModelS setProductName:@"Tesla Model S"];
    [teslaModelS setProductImage:@"teslaModelSImage"];
    [teslaModelS setProductURL:@"https://www.tesla.com/models"];
    
    Product *teslaModelX = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [teslaModelX setProductName:@"Tesla Model X"];
    [teslaModelX setProductImage:@"teslaModelXImage"];
    [teslaModelX setProductURL:@"https://www.tesla.com/modelx"];
    
    Product *teslaModel3 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [teslaModel3 setProductName:@"Tesla Model 3"];
    [teslaModel3 setProductImage:@"teslaModel3Image"];
    [teslaModel3 setProductURL:@"https://www.tesla.com/model3"];
    
    // Add products to Tesla company
    [tesla addProductsObject:teslaModelS];
    [tesla addProductsObject:teslaModelX];
    [tesla addProductsObject:teslaModel3];
    
    // Ford company
    Company *ford = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [ford setCompanyName:@"Ford"];
    [ford setCompanyImageName:@"fordLogoImage"];
    [ford setCompanyTicker:@"F"];
    
    Product *fordFiesta = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fordFiesta setProductName:@"Ford Fiesta"];
    [fordFiesta setProductImage:@"fordFiestaImage"];
    [fordFiesta setProductURL:@"http://www.ford.com/cars/fiesta/"];
    
    Product *fordFocus = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fordFocus setProductName:@"Ford Focus"];
    [fordFocus setProductImage:@"fordFocusImage"];
    [fordFocus setProductURL:@"http://www.ford.com/cars/focus/"];
    
    Product *fordMustang = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fordMustang setProductName:@"Ford Mustang"];
    [fordMustang setProductImage:@"fordMustangImage"];
    [fordMustang setProductURL:@"http://www.ford.com/cars/mustang/"];
    
    // Add products to Ford company
    [ford addProductsObject:fordFiesta];
    [ford addProductsObject:fordFocus];
    [ford addProductsObject:fordMustang];
    
    
    
    // Create all default value for companies
/*    companyInfoClass *apple = [[companyInfoClass alloc]init];
    apple.companyName = @"Apple mobile devices";
    apple.companyImageName = @"appleLogoImage";
    apple.companyTicker = @"AAPL";
    apple.productsArray = [NSMutableArray array];
    
    productClass *iPhone = [[productClass alloc] init];
    iPhone.productName = @"iPhone";
    iPhone.productImage = @"iPhoneImage";
    iPhone.productUrl = @"http://www.apple.com/iphone/";
    
    productClass *iPad = [[productClass alloc] init];
    iPad.productName = @"iPad";
    iPad.productImage = @"iPadImage";
    iPad.productUrl = @"http://www.apple.com/ipad/";
    
    productClass *iPod = [[productClass alloc] init];
    iPod.productName = @"iPod";
    iPod.productImage = @"iPodImage";
    iPod.productUrl = @"http://www.apple.com/ipod/";
    
    // Add product information in the apple company
    [apple.productsArray addObject:iPhone];
    [apple.productsArray addObject:iPad];
    [apple.productsArray addObject:iPod];
    
    
    // GROUP GOOGLE COMPANY AND ITS PRODUCTS
    companyInfoClass *google = [[companyInfoClass alloc] init];
    google.companyName = @"Google";
    google.companyImageName = @"googleLogoImage";
    google.companyTicker = @"GOOG";
    google.productsArray = [NSMutableArray array];
    
    productClass *googleGmail = [[productClass alloc]init];
    googleGmail.productName = @"Gmail";
    googleGmail.productImage = @"gmailLogoImage";
    googleGmail.productUrl = @"https://www.google.com/gmail/about/";
    
    productClass *googleMaps = [[productClass alloc]init];
    googleMaps.productName = @"Google Maps";
    googleMaps.productImage = @"googleMapsLogoImage";
    googleMaps.productUrl = @"https://maps.google.com/";
    
    // Add google products into Google company
    [google.productsArray addObject:googleGmail];
    [google.productsArray addObject:googleMaps];
    
    // GROUP TESLA COMPANY AND ITS PRODUCTS
    companyInfoClass *tesla = [[companyInfoClass alloc]init];
    tesla.companyName = @"Tesla";
    tesla.companyImageName = @"teslaLogoImage";
    tesla.companyTicker = @"TSLA";
    tesla.productsArray = [NSMutableArray array];
    
    productClass *teslaModelS = [[productClass alloc]init];
    teslaModelS.productName = @"Model S";
    teslaModelS.productImage = @"teslaModelSImage";
    teslaModelS.productUrl = @"https://www.tesla.com/models";
    
    productClass *teslaModelX = [[productClass alloc] init];
    teslaModelX.productName = @"Model X";
    teslaModelX.productImage = @"teslaModelXImage";
    teslaModelX.productUrl = @"https://www.tesla.com/modelx";
    
    productClass *teslaModel3 = [[productClass alloc] init];
    teslaModel3.productName = @"Model 3";
    teslaModel3.productImage = @"teslaModel3Image";
    teslaModel3.productUrl = @"https://www.tesla.com/model3";
    
    // Add Tesla products into Tesla company
    [tesla.productsArray addObject:teslaModelS];
    [tesla.productsArray addObject:teslaModelX];
    [tesla.productsArray addObject:teslaModel3];
    
    // GROUP FORD COMPANY AND ITS PRODUCTS
    companyInfoClass *ford = [[companyInfoClass alloc] init];
    ford.companyName = @"Ford";
    ford.companyImageName = @"fordLogoImage";
    ford.companyTicker = @"F";
    ford.productsArray = [NSMutableArray array];
    
    productClass *fordFiesta = [[productClass alloc]init];
    fordFiesta.productName = @"Fiesta";
    fordFiesta.productImage = @"fordFiestaImage";
    fordFiesta.productUrl = @"http://www.ford.com/cars/fiesta/";
    
    productClass *fordFocus = [[productClass alloc]init];
    fordFocus.productName = @"Focus";
    fordFocus.productImage = @"fordFocusImage";
    fordFocus.productUrl = @"http://www.ford.com/cars/focus/";
    
    productClass *fordMustang = [[productClass alloc]init];
    fordMustang.productName = @"Mustang";
    fordMustang.productImage = @"fordMustangImage";
    fordMustang.productUrl = @"http://www.ford.com/cars/mustang/";
    
    // Add ford products to the company
    [ford.productsArray addObject:fordFiesta];
    [ford.productsArray addObject:fordFocus];
    [ford.productsArray addObject:fordMustang];
 */
    
    
    self.companyList = [NSMutableArray array];
    
    // ADD ALL COMPANYS TO COMPANY ARRAY
    [self.companyList addObject:apple];
    [self.companyList addObject:google];
    [self.companyList addObject:tesla];
    [self.companyList addObject:ford];
    
    
   }

-(void)addNewCompanyToList:(NSString *)companyName
              companyImage:(NSString *)companyImage
             companyTicker:(NSString *)companyTicker

{
    Company *companyInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [companyInfo setCompanyName:companyName];
    [companyInfo setCompanyImageName:companyImage];
    [companyInfo setCompanyTicker:companyTicker];
    
    // Save to Disk
    [self saveChanges];
    
    [self.companyList addObject:companyInfo];
}

-(void)saveChanges
{
    NSError *error = nil;
    BOOL successful = [_managedObjectContext save:&error];
    if (!successful)
    {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    NSLog(@"Data saved");
}


-(void)addNewProductToList:(NSString *)productName
           productImageURL:(NSString *)productImageURL
                productURL:(NSString *)productURL
               companyInfo:(companyInfoClass *)companyInfo
{
    productClass *productInfo = [[productClass alloc] init];
    productInfo.productName = productName;
    productInfo.productImage = productImageURL;
    productInfo.productUrl = productURL;
    
    if (companyInfo.productsArray == nil)
        companyInfo.productsArray = [NSMutableArray array];
    
    [companyInfo.productsArray addObject:productInfo];
}

-(void)updateCompanyInfo:(NSString *)companyName
   updateCompanyImageURL:(NSString *)companyImageURL
     updateCompanyTicker:(NSString *)companyTicker
                 company:(companyInfoClass *)company
{
    company.companyName = companyName;
    company.companyImageName = companyImageURL;
    company.companyTicker = companyTicker;
    
}

-(void)updateProductInfo:(NSString *)productName
        updateProductURL:(NSString *)productURL
   updateProductImageURL:(NSString *)productImageURL
             productInfo:(productClass *)productInfo
{
    productInfo.productName = productName;
    productInfo.productUrl = productURL;
    productInfo.productImage = productImageURL;
}

-(void)getStockPrice
{
    NSString *urlStartString = @"http://finance.yahoo.com/d/quotes.csv?s=";
    NSString *urlEndString = @"&f=sl1";
    NSString *tickersString =@"";
    NSString *urlStringWithTickers;
    
    int i = 0;
    for (i = 0; i < [_companyList count]; i++) {
        Company *temp = _companyList[i];
        NSString *tempTicker = temp.companyTicker;
        
        tickersString = [tickersString stringByAppendingString:tempTicker];
        tickersString = [NSString stringWithFormat:@"%@+", tickersString];
        
    }
    NSString *newTickerString = [tickersString substringToIndex:[tickersString length] -1];
    
//    NSString *urlStringWithTicker = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+MSFT&f=sl1";
    urlStringWithTickers = [NSString stringWithFormat:@"%@%@%@", urlStartString, newTickerString,urlEndString];
    NSURL *url = [NSURL URLWithString:urlStringWithTickers];
    NSURLSessionDownloadTask *downloadStockTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"result = %@", newStr);
        
        // Separate the string to get individual ticker and stock price
        NSString *newStringWithOutQuotation = [newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"%@", newStringWithOutQuotation);
        
        // Now put in array
        NSArray *tickerAndPriceArray = [newStringWithOutQuotation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",\n"]];
       
        NSLog(@"%@", tickerAndPriceArray);
        
        for (int i = 0; i < [tickerAndPriceArray count]-1; i = i+2) {
            NSString *ticker = tickerAndPriceArray[i];
            Company *company = [self findCompanyByTicker:ticker];
            company.stockPrice = [NSNumber numberWithInteger:[tickerAndPriceArray[i+1]integerValue]];
        }
        
        // get the main thred
        dispatch_async(dispatch_get_main_queue(), ^{
            
        // Post the notification when the data is done downloading
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"StockDataReceived"
         object:self];
        });
    }];

    [downloadStockTask resume];
        
    
}

-(Company *)findCompanyByTicker:(NSString *)ticker
{
    for (Company *company in self.companyList) {
        if ([company.companyTicker isEqualToString:ticker])
            return company;
    }
    
    return nil;
}





@end
