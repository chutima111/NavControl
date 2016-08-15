//
//  DAO.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAO : NSObject

@property (nonatomic,strong) NSMutableArray *companyList;

-(void)createCompaniesAndProducts;

@end
