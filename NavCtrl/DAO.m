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
    }else {
        NSMutableArray *companiesArray = [[NSMutableArray alloc] init];
        for(Company *company in fetchedObjects){
            [companiesArray addObject:[self convertManagedCompanyToCIC:company]];
        }
        
        [self setCompanyList:companiesArray];
    }
    
#pragma mark convenient method
    
}

-(companyInfoClass*)convertManagedCompanyToCIC:(Company *) company{
    companyInfoClass *theCompany = [[companyInfoClass alloc]initWithId:[company.companyID intValue]];
    theCompany.companyName = company.companyName;
    theCompany.companyImageName = company.companyImageName;
    theCompany.companyTicker = company.companyTicker;
//    theCompany.companyID = [company.companyID intValue];
    theCompany.productsArray = [[NSMutableArray alloc]init];
    for (Product *product in company.products) {
        productClass *product1 = [[productClass alloc] init];
        product1.productName = product.productName;
        product1.productImage = product.productImage;
        product1.productUrl = product.productURL;
        product1.companyID = [product.companyID intValue];
        [theCompany.productsArray addObject:product1];
    }
    return theCompany;
}

-(Company *)convertCompanyInfoClassToManagedCompany:(companyInfoClass *)company
{
    Company *theCompany = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    theCompany.companyName = company.companyName;
    theCompany.companyImageName = company.companyImageName;
    theCompany.companyTicker = company.companyTicker;
    theCompany.companyID = @(company.companyID);
//    theCompany.products = [NSSet setWithArray:company.productsArray];
    NSMutableArray *tempProductsArray = [NSMutableArray array];
    for (productClass *product in company.productsArray)
    {
        Product *theProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
        theProduct.productName = product.productName;
        theProduct.productImage = product.productImage;
        theProduct.productURL = product.productUrl;
        theProduct.companyID = @(product.companyID);
        
        [tempProductsArray addObject:theProduct];
//        [theCompany setProducts:[NSSet setWithObject:theProduct]];
    }
    
    [theCompany setProducts:[NSSet setWithArray:tempProductsArray]];
    return theCompany;
}

#pragma mark create default values

-(void)createCompaniesAndProducts
{
    // Test : create default value for company in core data
    
    // Apple company
/*    Company *apple = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    
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
    
    // Try to add products to the company [Both ways work]
//    [iPhone setValue:apple forKey:@"company"];
//    [iPad setValue:apple forKey:@"company"];
//    [iPod setValue:apple forKey:@"company"];
//    
    [apple setProducts:[NSSet setWithObjects:iPhone, iPad, iPod, nil]];
  */  
    
 
    // Create all default value for companies
    companyInfoClass *apple = [[companyInfoClass alloc]init];
    apple.companyName = @"Apple Inc";
    apple.companyImageName = @"Apple Inc";
    apple.companyTicker = @"AAPL";
    apple.productsArray = [NSMutableArray array];
    
    productClass *iPhone = [[productClass alloc] initWithID:apple];
    iPhone.productName = @"iPhone";
    iPhone.productImage = @"iPhoneImage";
    iPhone.productUrl = @"http://www.apple.com/iphone/";
    
    productClass *iPad = [[productClass alloc] initWithID:apple];
    iPad.productName = @"iPad";
    iPad.productImage = @"iPadImage";
    iPad.productUrl = @"http://www.apple.com/ipad/";
    
    productClass *iPod = [[productClass alloc] initWithID:apple];
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
    google.companyImageName = @"Google";
    google.companyTicker = @"GOOG";
    google.productsArray = [NSMutableArray array];
    
    productClass *googleGmail = [[productClass alloc]initWithID:google];
    googleGmail.productName = @"Gmail";
    googleGmail.productImage = @"gmailLogoImage";
    googleGmail.productUrl = @"https://www.google.com/gmail/about/";
    
    productClass *googleMaps = [[productClass alloc]initWithID:google];
    googleMaps.productName = @"Google Maps";
    googleMaps.productImage = @"googleMapsLogoImage";
    googleMaps.productUrl = @"https://maps.google.com/";
    
    // Add google products into Google company
    [google.productsArray addObject:googleGmail];
    [google.productsArray addObject:googleMaps];
    
    // GROUP TESLA COMPANY AND ITS PRODUCTS
    companyInfoClass *tesla = [[companyInfoClass alloc]init];
    tesla.companyName = @"Tesla";
    tesla.companyImageName = @"Tesla";
    tesla.companyTicker = @"TSLA";
    tesla.productsArray = [NSMutableArray array];
    
    productClass *teslaModelS = [[productClass alloc]initWithID:tesla];
    teslaModelS.productName = @"Model S";
    teslaModelS.productImage = @"teslaModelSImage";
    teslaModelS.productUrl = @"https://www.tesla.com/models";
    
    productClass *teslaModelX = [[productClass alloc] initWithID:tesla];
    teslaModelX.productName = @"Model X";
    teslaModelX.productImage = @"teslaModelXImage";
    teslaModelX.productUrl = @"https://www.tesla.com/modelx";
    
    productClass *teslaModel3 = [[productClass alloc] initWithID:tesla];
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
    ford.companyImageName = @"Ford";
    ford.companyTicker = @"F";
    ford.productsArray = [NSMutableArray array];
    
    productClass *fordFiesta = [[productClass alloc]initWithID:ford];
    fordFiesta.productName = @"Fiesta";
    fordFiesta.productImage = @"fordFiestaImage";
    fordFiesta.productUrl = @"http://www.ford.com/cars/fiesta/";
    
    productClass *fordFocus = [[productClass alloc]initWithID:ford];
    fordFocus.productName = @"Focus";
    fordFocus.productImage = @"fordFocusImage";
    fordFocus.productUrl = @"http://www.ford.com/cars/focus/";
    
    productClass *fordMustang = [[productClass alloc]initWithID:ford];
    fordMustang.productName = @"Mustang";
    fordMustang.productImage = @"fordMustangImage";
    fordMustang.productUrl = @"http://www.ford.com/cars/mustang/";
    
    // Add ford products to the company
    [ford.productsArray addObject:fordFiesta];
    [ford.productsArray addObject:fordFocus];
    [ford.productsArray addObject:fordMustang];
 
    
    
    self.companyList = [NSMutableArray array];
    
    // ADD ALL COMPANYS TO COMPANY ARRAY
    [self.companyList addObject:apple];
    [self.companyList addObject:google];
    [self.companyList addObject:tesla];
    [self.companyList addObject:ford];
    
    // Create the managed objects and add it in core data
    
    for (companyInfoClass *company in self.companyList) {
        Company *theCompany = [self convertCompanyInfoClassToManagedCompany:company];
    }
    
    [self saveChanges];
    
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

-(void)undoLastAction
{
    [_managedObjectContext undo];
    [self reloadDataFromContext];
    
}

-(void)redoLastUndo
{
    [_managedObjectContext redo];
    [self reloadDataFromContext];
}


-(void)addNewCompanyToList:(NSString *)companyName
              companyImage:(NSString *)companyImage
             companyTicker:(NSString *)companyTicker
             productsArray:(NSMutableArray *)productsArray

{
    companyInfoClass *newCompany = [[companyInfoClass alloc]init];
    newCompany.companyName = companyName;
    newCompany.companyImageName = companyImage;
    newCompany.companyTicker = companyTicker;
    newCompany.productsArray = [NSMutableArray array];
    
    [self.companyList addObject:newCompany];
    
    // Save to Disk
    [self convertCompanyInfoClassToManagedCompany:newCompany];
    
    [self saveChanges];
}

-(void)updateCompanyInfo:(NSString *)companyName
   updateCompanyImageURL:(NSString *)companyImageURL
     updateCompanyTicker:(NSString *)companyTicker
                 company:(companyInfoClass *)company
{
        // Fetch the company from the core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"companyID", company.companyID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not fetch the objects");
    }
    
    else {
        if ([fetchedObjects count] > 0) {
            Company *targetCompany = fetchedObjects[0];
            targetCompany.companyName = companyName;
            targetCompany.companyImageName = companyImageURL;
            targetCompany.companyTicker = companyTicker;
            
            [self saveChanges];
        }
        
    }

    company.companyName = companyName;
    company.companyImageName = companyImageURL;
    company.companyTicker = companyTicker;
    
    
}

-(void)deleteCompany:(companyInfoClass *)company
{
    // Fetch the company from the core data first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fethchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fethchedObjects == nil)
    {
        NSLog(@"Could not delete Entity objects");
    }
    for (Company *targetCompany in fethchedObjects) {
        if ([targetCompany.companyID intValue] == company.companyID)
            [_managedObjectContext deleteObject:targetCompany];
    }
   
    
    [self.companyList removeObject:company];
    
        
//    [self saveChanges];
    
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
    productInfo.companyID = companyInfo.companyID;
    
    if (companyInfo.productsArray == nil) {
        companyInfo.productsArray = [NSMutableArray array];
    }
    [companyInfo.productsArray addObject:productInfo];
    
    // Create managed object, product in Core data
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    newProduct.productName = productName;
    newProduct.productImage = productImageURL;
    newProduct.productURL = productURL;
    newProduct.companyID = @(companyInfo.companyID);
    
    // Add product to company managed object
    // First, fetch the company from the model
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fethchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fethchedObjects == nil)
    {
        NSLog(@"Could not delete Entity objects");
    }
    for (Company *targetCompany in fethchedObjects) {
        if ([targetCompany.companyID intValue] == productInfo.companyID)
           
           [targetCompany addProducts:[NSSet setWithObject:newProduct]];
    }
    
    [self saveChanges];

    
}


-(void)updateProductInfo:(NSString *)productName
        updateProductURL:(NSString *)productURL
   updateProductImageURL:(NSString *)productImageURL
             productInfo:(productClass *)productInfo
{
    // Fetch that product from the data first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"companyID", productInfo.companyID];
    [fetchRequest setPredicate:predicate];
    
        NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not fetch the objects");
    }
    
    else {
            for (Product *targetProduct in fetchedObjects) {
                if ([targetProduct.productName isEqualToString:productInfo.productName]) {
            
            targetProduct.productName = productName;
            targetProduct.productImage = productImageURL;
            targetProduct.productURL = productURL;
                    
                }
            }
            
            [self saveChanges];
        }
        
    
    // update product info to product object class
    productInfo.productName = productName;
    productInfo.productUrl = productURL;
    productInfo.productImage = productImageURL;
}



///Here Im typint something

-(void)deleteProduct:(productClass *)product
{
    // Fetch that product from the data first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create Predicate, by finding the product id
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"companyID", product.companyID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    // This fetchedObjects should have all the products that have same id
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not find the product object");
    }
    else {
        for (Product *targetProduct in fetchedObjects) {
            if ([targetProduct.productName isEqualToString:product.productName]) {
                [_managedObjectContext deleteObject:targetProduct];
            }
        }
        [self saveChanges];
    }
    
   
}



-(void)getStockPrice
{
    NSString *urlStartString = @"http://finance.yahoo.com/d/quotes.csv?s=";
    NSString *urlEndString = @"&f=sl1";
    NSString *tickersString =@"";
    NSString *urlStringWithTickers;
    
    int i = 0;
    for (i = 0; i < [_companyList count]; i++) {
        companyInfoClass *temp = _companyList[i];
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
