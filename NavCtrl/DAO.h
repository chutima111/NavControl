//
//  DAO.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class companyInfoClass;
@class productClass;

@interface DAO : NSObject

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) NSMutableArray<companyInfoClass *> *companyList;

-(void)createCompaniesAndProducts;

-(void)addNewCompanyToList:(NSString *)companyName
              companyImage:(NSString *)companyImage
             companyTicker:(NSString *)companyTicker
             productsArray:(NSMutableArray *)productsArray;

-(void)updateCompanyInfo:(NSString *)companyName
   updateCompanyImageURL:(NSString *)companyImageURL
     updateCompanyTicker:(NSString *)companyTicker
                 company:(companyInfoClass *)company;

-(void)addNewProductToList:(NSString *)productName
           productImageURL:(NSString *)productImageURL
                productURL:(NSString *)productURL
               companyInfo:(companyInfoClass *)companyInfo;

-(void)deleteProduct:(productClass *)product;



-(void)updateProductInfo:(NSString *)productName
        updateProductURL:(NSString *)productURL
   updateProductImageURL:(NSString *)productImageURL
             productInfo:(productClass *)productInfo;

-(void)getStockPrice;

-(void)deleteCompany:(companyInfoClass *)company;


+(DAO *)sharedInstance;

-(NSString *)archivePath;

-(void)reloadDataFromContext;

-(void)saveChanges;

-(void)undoLastAction;

-(void)redoLastUndo;


@end
