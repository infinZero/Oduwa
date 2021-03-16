//
//  Receive.h
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Send.h"
#import "Home.h"
#import "Settings.h"

@interface Receive : UIViewController
{
    IBOutlet UIImageView *imgViewQr;
    IBOutlet UIButton *btnAddress;
}
-(IBAction)onClickBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (nonatomic) NSString *type;
@end
