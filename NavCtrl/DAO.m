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

@implementation DAO

-(void)createCompaniesAndProducts
{
    companyInfoClass *apple = [[companyInfoClass alloc]init];
    apple.companyName = @"Apple mobile devices";
    apple.companyImageName = @"apple company logo";
    apple.companyTicker = @"AAPL";
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
             productsArray:(NSMutableArray *)productsArray
{
    companyInfoClass *companyInfo = [[companyInfoClass alloc] init];
    companyInfo.companyName = companyName;
    companyInfo.companyImageName = companyImage;
    companyInfo.companyTicker = companyTicker;
    companyInfo.productsArray = productsArray;
    [self.companyList addObject:companyInfo];
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
            companyInfoClass *company = [self findCompanyByTicker:ticker];
            company.stockPrice = tickerAndPriceArray[i+1];
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

-(companyInfoClass *)findCompanyByTicker:(NSString *)ticker
{
    for (companyInfoClass *company in self.companyList) {
        if ([company.companyTicker isEqualToString:ticker])
            return company;
    }
    
    return nil;
}

+(DAO *)sharedInstance
{
    static DAO *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DAO alloc]init];
    });
    
    return sharedInstance;
    
}



@end
