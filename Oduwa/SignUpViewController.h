//
//  SignUpViewController.h
//  Oduwa
//
//  Created by Jayesh on 16/10/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Email.h"
#import "Global.h"

@interface SignUpViewController : UIViewController
{
    IBOutlet UIScrollView * scrlViewMain;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtMobile;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    
    IBOutlet UIButton *btnSignUp;
    IBOutlet UIButton *btnAlreadyRegister;
}
-(IBAction)onClickBtn:(id)sender;
@end
