//
//  HistoryMaster.h
//  Oduwa
//
//  Created by Satish Koladiya on 18/10/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryMaster : NSObject
@property(nonatomic)int ID;
@property(nonatomic)float AMOUNT;
@property(nonatomic)float FEES;
@property(nonatomic)int CONFIRMATION;
@property(nonatomic,retain) NSString *FROM_ADDRESS;
@property(nonatomic,retain) NSString *TO_ADDRESS;
@property(nonatomic,retain) NSString *TRNDATE;
@property(nonatomic,retain) NSString *API;
@property(nonatomic,retain) NSString *TXID;
@property(nonatomic,retain) NSString *STATUS;
@property(nonatomic,retain) NSString *MESSAGE;
@property(nonatomic,retain) NSString *RedirectURL;
@end

NS_ASSUME_NONNULL_END
