//
//  companyInfoClass.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface companyInfoClass : NSObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyImageName;
@property (nonatomic, strong) NSString *companyTicker;
@property (nonatomic, strong) NSString *stockPrice;
@property (nonatomic, strong) NSMutableArray *productsArray;
@property int companyID;

-(instancetype)init;
-(instancetype)initWithId:(int)companyId;

@end
