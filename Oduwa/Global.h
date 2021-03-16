//
//  Global.h
//  SNJ
//
//  Created by peacock on 08/07/16.
//  Copyright © 2016 peacock. All rights reserved.
//

#import <UIKit/UIKit.h>
#include<netdb.h>
#import "Constant.h"


@interface Global : NSObject
{
    
}

+ (Global *)sharedInstance;

@property(nonatomic ,retain) NSMutableArray *arr_Mast;
@property(nonatomic ,retain) NSMutableArray *arr_LooseStockMast;


-(BOOL)isNetworkAvailable;
-(void)ShowAlertWithMessage:(NSString*)strMessage Title:(NSString*)strTitle;
-(void)GetDataFromWebService:(NSString*)WebServiceName parameters : (NSMutableDictionary*)parameters;
-(void)LogOut;
-(BOOL)IsValidEmail:(NSString *)checkString;



@end
