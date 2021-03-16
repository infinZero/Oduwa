//
//  ViewController.h
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Send.h"
#import "Receive.h"
#import "Settings.h"
#import "HistoryMaster.h"
#import "SWRevealViewController.h"

@interface Home : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate, SWRevealViewControllerDelegate>
{
    NSMutableData *mutableData;

}
@property(nonatomic,strong) NSMutableDictionary *currentPrice;
@property (nonatomic, strong) NSString *savedValue;

@property (nonatomic,weak) IBOutlet UIView *viewHeading;
@property (nonatomic,weak) IBOutlet UILabel *lblBalance;
@property (weak,nonatomic) IBOutlet UITableView *tblhistory;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnReceived;
@end

