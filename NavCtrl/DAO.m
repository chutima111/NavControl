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

}

-(void)addNewCompanyToList:(NSString *)companyName
              companyImage:(NSString *)companyImage
             productsArray:(NSMutableArray *)productsArray
{
    companyInfoClass *companyInfo = [[companyInfoClass alloc] init];
    companyInfo.companyName = companyName;
    companyInfo.companyImageName = companyImage;
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
                 company:(companyInfoClass *)company
{
    company.companyName = companyName;
    company.companyImageName = companyImageURL;
    
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
