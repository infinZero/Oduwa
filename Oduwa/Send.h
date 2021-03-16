//
//  Send.h
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"
#import "Receive.h"
#import "Settings.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <AVFoundation/AVFoundation.h>

@interface Send : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    IBOutlet TPKeyboardAvoidingScrollView* scrlViewMain;
    NSMutableData *mutableData;

}
@property(nonatomic,strong) NSMutableDictionary *currentPrice;


@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (nonatomic,weak) IBOutlet UIView *viewHeading;
@property (nonatomic, strong) IBOutlet UILabel *lblBalance;
@property (nonatomic, strong) IBOutlet UILabel *lblFees;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalDollar;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress;
@property (nonatomic, strong) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtCrcAmount;

@property (nonatomic, strong) IBOutlet UITextField *txtTotal;
@property (nonatomic) BOOL isReading;

@property (nonatomic) NSString *type;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) NSString *savedValue;

-(BOOL)startReading;
-(void)stopReading;
-(IBAction)onClickBtn:(id)sender;

@end
