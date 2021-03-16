//
//  Pin.h
//  UnifyEarth
//
//  Created by Jayesh on 31/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentTab.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"

@interface Pin : UIViewController<UITextFieldDelegate, SWRevealViewControllerDelegate> {
}

@property (nonatomic) BOOL isRestoredAccount;
@property (nonatomic) BOOL isNewPin;
@property (nonatomic) BOOL isConfirmPin;
@property (nonatomic) BOOL isCheckPin;
@property (nonatomic) BOOL isChangePin;

@property (nonatomic, strong) IBOutlet UILabel *lblPinTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;

@property (nonatomic, strong) IBOutlet UITextField *textField1;
@property (nonatomic, strong) IBOutlet UITextField *textField2;
@property (nonatomic, strong) IBOutlet UITextField *textField3;
@property (nonatomic, strong) IBOutlet UITextField *textField4;

-(IBAction)onClickBtn:(id)sender;
-(IBAction)onClickBackBtn:(id)sender;

@end
