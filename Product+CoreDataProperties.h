//
//  Product+CoreDataProperties.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/31/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *productImage;
@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) NSString *productURL;
@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) Company *company;

@end

NS_ASSUME_NONNULL_END
