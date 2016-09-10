//
//  companyInfoClass.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "companyInfoClass.h"

@implementation companyInfoClass

-(instancetype)initWithId:(int)companyId
{
    self = [super init];
    if (self) {
        _companyID = companyId;
        _productsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
       
        NSNumber *companyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyID"];
        
        if (companyID == nil) {
            
            NSNumber *companyID = @1;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:companyID forKey:@"companyID"];
            [defaults synchronize];
            
            NSLog(@"company id saved");
            
            self.companyID = [companyID intValue];
        }
        else
        {
            self.companyID = [companyID intValue] + 1;
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(self.companyID) forKey:@"companyID"];
            [defaults synchronize];
        }
    }
    _productsArray = [[NSMutableArray alloc] init];

    return self;
}

-(void)dealloc {
    [_productsArray release];
    [_companyName release];
    [_companyImageName release];
    [_companyTicker release];
    [_stockPrice release];
    
    [super dealloc];
}

@end
