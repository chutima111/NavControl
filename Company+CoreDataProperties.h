//
//  Company+CoreDataProperties.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/28/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Company.h"

NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *companyImageName;
@property (nullable, nonatomic, retain) NSString *companyTicker;
@property (nullable, nonatomic, retain) NSNumber *stockPrice;
@property (nullable, nonatomic, retain) NSOrderedSet<Product *> *products;

@end

@interface Company (CoreDataGeneratedAccessors)

- (void)insertObject:(Product *)value inProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductsAtIndex:(NSUInteger)idx;
- (void)insertProducts:(NSArray<Product *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductsAtIndex:(NSUInteger)idx withObject:(Product *)value;
- (void)replaceProductsAtIndexes:(NSIndexSet *)indexes withProducts:(NSArray<Product *> *)values;
- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSOrderedSet<Product *> *)values;
- (void)removeProducts:(NSOrderedSet<Product *> *)values;

@end

NS_ASSUME_NONNULL_END
