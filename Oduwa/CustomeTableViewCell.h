//
//  SettingTableViewCell.h
//  UnifyEarth
//
//  Created by Jayesh on 31/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeTableViewCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel *lblTitle;
@property (weak,nonatomic) IBOutlet UIImageView *imgView;
@end

@interface HistoryCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UIView  *viewContainer;
@property (weak,nonatomic) IBOutlet UILabel *lblFrom;
@property (weak,nonatomic) IBOutlet UILabel *lblTo;
@property (weak,nonatomic) IBOutlet UIButton *btnTrnId;
@property (weak,nonatomic) IBOutlet UILabel *lblFee;
@property (weak,nonatomic) IBOutlet UILabel *lblTrnStatus;
@property (weak,nonatomic) IBOutlet UILabel *lblTrnTime;

@end
