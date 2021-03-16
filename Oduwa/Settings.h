//
//  Settings.h
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomeTableViewCell.h"
#import "Pin.h"
#import "Email.h"
#import "PatternViewController.h"

@interface Settings : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
}
@property (weak,nonatomic) IBOutlet UITableView *tblViewSettings;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@end
