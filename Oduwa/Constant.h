//
//  Constant.h
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define RGBa(r,g,b,a)            [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define WS_Local_URL    @"https://www.oduwa.org/oduwacoinservice.asmx" //LocaL
#define WS_Live_URL     @"https://www.oduwa.org/oduwacoinservice.asmx" //Live
#define Message_Title   @"Oduwa"


#define kPref               [NSUserDefaults standardUserDefaults]
#define DeviceUUID          [[NSUUID UUID] UUIDString]
#define Key_UserEmail         @"UserEmail"
#define Key_PinNo             @"PinNo"
#define Key_Pin               @"Pin"
#define Key_CopiedAddress     @"CopiedAddress"
#define Key_LabelName         @"LabelName"
#define Key_LoginPassword     @"LoginPassword"
#define Key_Password          @"Password"
#define Key_MainPassword      @"MainPassword"
#define Key_Address           @"Address"
#define Key_API               @"API"
#define Key_FEES              @"FEES"
#define Key_FirstName         @"FirstName"
#define Key_LastName          @"LastName"
#define Key_MobileNo          @"MobileNo"
#define Key_EmailVerify       @"EmailVerify"
#define Key_Active            @"Active"
#define Key_MinimumTx         @"MinimumTx"
#define Key_RedirectUrl       @"REDIRECT_URL"

//*********************** Parameters ***********************
#define Para_Email               @"EMAIL_ID"
#define Para_API                 @"API"
#define Para_Label               @"LABLE_NAME"
#define Para_Password            @"PASSWORD"
#define Para_FirstName           @"FIRST_NAME"
#define Para_LastName            @"LAST_NAME"
#define Para_MobileNo            @"MOBILE_NO"
#define Para_EmailVerify         @"EMAIL_VERIFY"
#define Para_Active              @"ACTIVE"
#define Para_Address             @"ADDRESS"
#define Para_ToAddress           @"TO_ADDRESS"
#define Para_Amount              @"AMOUNT"
#define Para_MinimumTx           @"MINIMUM_TX"
#define Para_Fees                @"FEES"
#define Para_pin                 @"PIN"
#define Para_MainPassword        @"MAIN_PASSWORD"
#define Para_Device              @"DEVICE"



//*********************** WebServices ***********************
#define EX_USER_CREATE                  @"EX_USER_CREATE"
#define EX_EMAIL_VERIFY                 @"EX_EMAIL_VERIFY"
#define EX_CHANGE_PASSWORD              @"EX_CHANGE_PASSWORD"
#define EX_RESET_PASSWORD               @"EX_RESET_PASSWORD"
#define EX_CHANGE_PIN                   @"EX_CHANGE_PIN"
#define EX_CHECK_LOGIN                  @"EX_CHECK_LOGIN"
#define EX_GET_BALANCE                  @"EX_GET_BALANCE"
#define EX_GET_BALANCE_V1               @"EX_GET_BALANCE_V1"
#define EX_TRANSACTION_HISTORY_FILL     @"EX_TRANSACTION_HISTORY_FILL"
#define EX_TRANSACTION_SEND             @"EX_TRANSACTION_SEND"
#define EX_TRANSACTION_SEND_V1          @"EX_TRANSACTION_SEND_V1"


#endif /* Constant_h */
