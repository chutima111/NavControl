//
//  productClass.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "productClass.h"

@implementation productClass

-(instancetype)initWithID:(companyInfoClass *)company
{
    self = [super init];
    if (self) {
        self.companyID = company.companyID;
    }
    
    return self;
}

-(void)dealloc
{
    [_productName release];
    [_productImage release];
    [_productUrl release];
    [super dealloc];
}


@end
