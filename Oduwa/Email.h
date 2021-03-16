//
//  Email.h
//  UnifyEarth
//
//  Created by Jayesh on 31/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentTab.h"
#import "Pin.h"
#import "SignUpViewController.h"
#import "SWRevealViewController.h"
#import "PatternViewController.h"

@interface Email : UIViewController<UITextFieldDelegate, SWRevealViewControllerDelegate, PatternViewControllerDelegate> {
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UIButton *btnSignIn;
    IBOutlet UIButton *btnVerifyMail;
    IBOutlet UIButton *btnForgetPassword;
    IBOutlet UIButton *btnDontHaveAccount;
}

-(IBAction)onClickBtn:(id)sender;

@end
