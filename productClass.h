//
//  productClass.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "companyInfoClass.h"

@interface productClass : NSObject

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImage;
@property (nonatomic, strong) NSString *productUrl;
@property int companyID;

-(instancetype)initWithID:(companyInfoClass *)company;

@end
