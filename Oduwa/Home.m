//
//  ViewController.m
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "Home.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "Send.h"
#define URL  @"https://api.coingecko.com/api/v3/coins/oduwa-coin"
#define NO_CONNECTION  @"No Connection"
#define NO_VALUES      @"Please enter parameter values"

static int const kHeaderSectionTag = 6900;
@interface Home () {
    //NSMutableArray* arrayData;
    NSString* tableCellIdentifier,*strBalance,*strTrnType,*strStatus,*upperCase;
    double douBalanceAmount,douDollorAmount,douTotalAmount,douAmount,crncyValue;
    
    float fltBalance;
    Global *Glb;
    //UIRefreshControl *refreshControl;
    NSTimer *timer;
    
    int intPageIndex,intTotalRecord,intTxId;
    NSMutableArray *arrResult;
    NSMutableArray *arrparent;
    NSMutableArray *arrsub;
    NSMutableArray *resultingArray;
    NSMutableDictionary *finalArgument;
    NSMutableDictionary *finalValue;
    
    BOOL isViewDidLoad,isLoadMore;
    
    NSInteger expandedSectionHeaderNumber;
    UITableViewHeaderFooterView *expandedSectionHeader;
}
@end

@implementation Home
@synthesize savedValue, currentPrice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Glb = [Global sharedInstance];
    
    savedValue = [[NSUserDefaults standardUserDefaults]
    stringForKey:@"preferedCurrency"];
    if (!savedValue){
        savedValue = @"usd";
    }
   // [self sendDataToServer : @"GET"];
    [self GetBalance];

//    refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(RefreshHistory) forControlEvents:UIControlEventValueChanged];
//    [self.tblhistory addSubview:refreshControl];
    
    expandedSectionHeaderNumber = -1;
    
    self.tblhistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tblhistory.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewHeading.layer.cornerRadius = 5;
    
   
    
    intPageIndex = 0;
    intTotalRecord = 10;
    intTxId = 0;
    
    arrResult = [[NSMutableArray alloc] init];
    arrparent = [[NSMutableArray alloc]init];
    arrsub = [[NSMutableArray alloc]init];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [_btnMenu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(GetBalance) userInfo:nil repeats:YES];
    
    //if(intPageIndex > 0)
        //[self RefreshHistory];
    intPageIndex = 0;
    [self GetHistory];
    
    self.btnSend.layer.borderWidth = 1.0f;
    self.btnSend.layer.borderColor=[ UIColor whiteColor].CGColor;
    
    self.btnReceived.layer.borderWidth = 1.0f;
    self.btnReceived.layer.borderColor=[ UIColor whiteColor].CGColor;
    
    self.btnSend.layer.cornerRadius = 8;
    self.btnSend.clipsToBounds = YES;
    
    self.btnReceived.layer.cornerRadius = 8;
    self.btnReceived.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnSend:(id)sender {
    Send *send = (Send *)[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    send.type = @"Close";
    [self presentViewController:send animated:YES completion:nil];
}

- (IBAction)btnReceived:(id)sender {
    Receive *send = (Send *)[self.storyboard instantiateViewControllerWithIdentifier:@"Receive"];
    send.type = @"Close";
    [self presentViewController:send animated:YES completion:nil];
}


#pragma mark User Defined Delegate
-(void)GetBalance {
    @try {
        if (![Glb isNetworkAvailable]) {
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [kPref valueForKey:Key_API],Para_API, 
                                           nil];
        
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_GET_BALANCE_V1];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *writeError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
           // NSLog(@"Here are the resulting Currencies %@", dic);
            
            //if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]])
            if ([[dic valueForKey:@"UserPIN"] isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                
              //  self->douBalanceAmount = [[[dic valueForKey:@"Result"] valueForKey:@"AMOUNT"]  doubleValue];
                self->douBalanceAmount = [[dic valueForKey:@"Amount"]  doubleValue];
           //     NSLog(@"Amount = %f", self->douBalanceAmount);
                self->resultingArray = [dic valueForKey:@"currnecy"];
            //    NSLog(@"resulting array %@", self->resultingArray);
                for (NSDictionary *aDict in self->resultingArray) {
                    if ([aDict objectForKey:@"Name"]  == self->savedValue) {
                       // id was indeed 1, replace '1', with the id that you're looking for
                        self->crncyValue = [[aDict valueForKey:@"Price"] doubleValue];
                      //  NSLog(@"%@ = %f", self->savedValue, self->crncyValue);
                   }
                }
                self->upperCase = [self->savedValue uppercaseString];

              //  self->douDollorAmount = [[[dic valueForKey:@"Result"] valueForKey:@"OWC_PRICE"]  doubleValue];
                self->douTotalAmount = self->douBalanceAmount * self->crncyValue;
                
                self->strBalance = [NSString stringWithFormat:@"%.04f",self->douBalanceAmount];
                
                self->strBalance = [self->strBalance stringByAppendingString:@" OWC = "];
                
                self->strBalance = [self->strBalance stringByAppendingString:[NSString stringWithFormat:@"%.02f",self->douTotalAmount]];
                
                self->strBalance = [self->strBalance stringByAppendingString:@" "];
                
                self->strBalance = [self->strBalance stringByAppendingString:self->upperCase];

                [self.lblBalance setText:self->strBalance];
            } else {
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    @catch (NSException *exception) {
    }
}

-(void)GetHistory
{
    @try {
        
        if (![Glb isNetworkAvailable]) {
            
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [kPref valueForKey:Key_API],Para_API,
                                           [NSNumber numberWithInteger:intPageIndex],@"PAGEINDEX",
                                           [NSNumber numberWithInteger:intTotalRecord],@"TOTAL_RECORD",
                                           nil];
        
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_TRANSACTION_HISTORY_FILL];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *writeError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
            if ([[dataDic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
               if(intPageIndex == 0)
               {
                   [arrResult removeAllObjects];
                   [arrsub removeAllObjects];
                   expandedSectionHeaderNumber = -1;
               }
                
                for (NSMutableDictionary *dict in [[dataDic valueForKey:@"Result"] valueForKey:@"data"] )
                {
                    HistoryMaster *hm=[[HistoryMaster alloc]init];
                    
                    if(![[dict valueForKey:@"ID"] isKindOfClass:[NSNull class]])
                        hm.ID=[[dict valueForKey:@"ID"] intValue];
                    
                    if(![[dict valueForKey:@"AMOUNT"] isKindOfClass:[NSNull class]])
                        hm.AMOUNT=[[dict valueForKey:@"AMOUNT"] floatValue];
                    
                    if(![[dict valueForKey:@"FEES"] isKindOfClass:[NSNull class]])
                        hm.FEES=[[dict valueForKey:@"FEES"] floatValue];
                    
                    if(![[dict valueForKey:@"CONFIRMATION"] isKindOfClass:[NSNull class]])
                        hm.CONFIRMATION=[[dict valueForKey:@"CONFIRMATION"] intValue];
                    
                    if(![[dict valueForKey:@"FROM_ADDRESS"] isKindOfClass:[NSNull class]])
                        hm.FROM_ADDRESS=[dict valueForKey:@"FROM_ADDRESS"];
                    
                    if(![[dict valueForKey:@"TO_ADDRESS"] isKindOfClass:[NSNull class]])
                        hm.TO_ADDRESS=[dict valueForKey:@"TO_ADDRESS"];
                    
                    if(![[dict valueForKey:@"TRNDATE"] isKindOfClass:[NSNull class]])
                        hm.TRNDATE=[dict valueForKey:@"TRNDATE"];
                    
                    if(![[dict valueForKey:@"API"] isKindOfClass:[NSNull class]])
                        hm.API=[dict valueForKey:@"API"];
                    
                    if(![[dict valueForKey:@"TXID"] isKindOfClass:[NSNull class]])
                        hm.TXID=[dict valueForKey:@"TXID"];
                    
                    if(![[dict valueForKey:@"STATUS_TEXT"] isKindOfClass:[NSNull class]])
                        hm.STATUS=[dict valueForKey:@"STATUS_TEXT"];
                    
                    if(![[dict valueForKey:@"MESSAGE"] isKindOfClass:[NSNull class]])
                        hm.MESSAGE=[dict valueForKey:@"MESSAGE"];
                    
                    if(![[dict valueForKey:Key_RedirectUrl] isKindOfClass:[NSNull class]])
                        hm.RedirectURL = [dict valueForKey:Key_RedirectUrl];
                    
                    [arrResult addObject:hm];
                }
                [arrparent removeAllObjects];
                for(int i=0;i<arrResult.count;i++)
                {
                    HistoryMaster *tm=[arrResult objectAtIndex:i];
                    if(arrparent.count==0)
                    {
                        [arrparent addObject:[NSNumber numberWithInt:tm.ID]];
                    }
                    else
                    {
                        if(![arrparent containsObject:[NSNumber numberWithInt:tm.ID]])
                        {
                            [arrparent addObject:[NSNumber numberWithInt:tm.ID]];
                        }
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tblhistory reloadData];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self ShowToastMessage:[[dataDic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
                
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    @catch (NSException *exception) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

-(void)ShowToastMessage:(NSString*)strToastMessage InterVal:(NSTimeInterval)Interval
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = strToastMessage;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.labelFont = [UIFont fontWithName:@"Helvetica" size:10];
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:Interval];
}

#pragma mark TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [arrparent count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (expandedSectionHeaderNumber == section) {
        return 1;
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width - 10, 45)];
    
    UIView *viewbg = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width - 10, 40)];
    //[viewbg setBackgroundColor:[UIColor colorWithRed:22.0f/255.0f green:139.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [viewbg setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:56.0f/255.0f blue:78.0f/255.0f alpha:1.0f]];
    [view addSubview:viewbg];
    /* Create custom view to display section header... */
    UIImage *image = [[UIImage alloc] init];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,25, 25)];
    [iv setImage:image];
    
    UILabel *labelMsg = [[UILabel alloc] initWithFrame:CGRectMake(45,5, 70, 35)];
    [labelMsg setFont:[UIFont boldSystemFontOfSize:12]];
    labelMsg.textColor = [UIColor blackColor];
    UILabel *labelFEES = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-10-80-30, 0, 100, 40)];
    [labelFEES setFont:[UIFont boldSystemFontOfSize:12]];
    labelFEES.textColor = [UIColor blackColor];
    
     HistoryMaster *hm = [arrResult objectAtIndex:section];
    
    douAmount = 0;
    
    strTrnType =hm.MESSAGE;
    
    if([strTrnType isEqualToString:@"SEND"] || [strTrnType isEqualToString:@"SENT"])
        [iv setImage:[UIImage imageNamed:@"send.png"]];
    else if([strTrnType isEqualToString:@"RECEIVE"] || [strTrnType isEqualToString:@"RECEIVED"])
        [iv setImage:[UIImage imageNamed:@"recevice.png"]];
    
    [labelMsg setText:hm.MESSAGE];
    labelMsg.textColor = UIColor.whiteColor;
    [labelFEES setText:[[NSString alloc]initWithFormat:@"%f",hm.AMOUNT]];
    labelFEES.textColor = UIColor.whiteColor;
    [view addSubview:iv];
    [view addSubview:labelMsg];
    [view addSubview:labelFEES];
    
    UIImageView *viewWithTag = [self.view viewWithTag:kHeaderSectionTag + section];
    if (viewWithTag) {
        [viewWithTag removeFromSuperview];
    }
    
    // add the arrow image
    CGSize headerFrame = self.view.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, 13, 18, 18)];
    theImageView.image = [UIImage imageNamed:@"Expand.png"];
    theImageView.tag = kHeaderSectionTag + section;
    [view addSubview:theImageView];
    
    // make headers touchable
    view.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderWasTouched:)];
    [view addGestureRecognizer:headerTapGesture];
    
     if(section == [arrResult count] - 1)
         isLoadMore = YES;
    return view;
}

- (void)updateTableViewRowDisplay:(NSArray *)arrayOfIndexPaths {
    [_tblhistory beginUpdates];
    [_tblhistory deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    [_tblhistory endUpdates];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableCellIdentifier = @"HistoryCell";
    
    HistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if(cell==nil) {
        cell=(HistoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustomeTableViewCell" owner:self options:nil] objectAtIndex:1];
    }
    
    NSNumber *hid=[arrparent objectAtIndex:indexPath.section];
    [arrsub removeAllObjects];
    
    for(int i=0;i<arrResult.count;i++) {
        HistoryMaster *tm = [arrResult objectAtIndex:i];
        if(tm.ID == hid.intValue) {
            [arrsub addObject:tm];
        }
    }
    HistoryMaster *t = [arrsub objectAtIndex:indexPath.row];
    
    cell.lblFrom.text = t.FROM_ADDRESS;
    cell.lblTo.text = t.TO_ADDRESS;
    [cell.btnTrnId setTitle:t.TXID forState:UIControlStateNormal];
    [cell.btnTrnId setAccessibilityLabel:t.RedirectURL];
    [cell.btnTrnId addTarget:self action:@selector(onClickCellBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblFee.text = [NSString stringWithFormat:@"%.08f",t.FEES];
    
    cell.lblFee.textColor = UIColor.whiteColor;
    
    strStatus = t.STATUS;
    cell.lblTrnStatus.text = strStatus;
    cell.lblTrnStatus.textColor = UIColor.whiteColor;
    if([strStatus isEqualToString:@"UNCONFIRM"] || [strStatus isEqualToString:@"UNCONFIRMED"])
        cell.lblTrnStatus.textColor = [UIColor redColor];
    else {
        //cell.lblTrnStatus.textColor = RGBa(76, 175, 80, 1);
        cell.lblTrnStatus.textColor = RGBa(254, 197, 37, 1);
    }
    
    cell.lblTrnTime.text =t.TRNDATE;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:22.0f/255.0f green:139.0f/255.0f blue:239.0f/255.0f alpha:1.0f];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == arrResult.count-1) {
        isLoadMore = YES;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

#pragma mark - Expand / Collapse Methods
-(void)onClickCellBtn:(id)sender {
    UIButton *btn = (UIButton*)sender;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = btn.accessibilityLabel;
    NSLog(@"URL = %@",pasteboard.string);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open URL" message:NSLocalizedString(@"Are You Sure To Open This Transaction In URL?", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(NSLocalizedString(@"Yes", nil), nil),nil];
    alert.tag = 1;
    alert.delegate = self;
    [alert show];
}

- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:kHeaderSectionTag + section];
    expandedSectionHeader = headerView;
    
    if (expandedSectionHeaderNumber == -1) {
        expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage: eImageView];
    } else {
        if (expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section withImage: eImageView];
            expandedSectionHeader = nil;
        } else {
            UIImageView *cImageView  = (UIImageView *)[self.view viewWithTag:kHeaderSectionTag + expandedSectionHeaderNumber];
            [self tableViewCollapeSection:expandedSectionHeaderNumber withImage: cImageView];
            [self tableViewExpandSection:section withImage: eImageView];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSNumber *hid=[arrparent objectAtIndex:section];
    [arrsub removeAllObjects];
    
    for(int i=0;i<arrResult.count;i++) {
        HistoryMaster *tm=[arrResult objectAtIndex:i];
        if(tm.ID == hid.intValue) {
            [arrsub addObject:tm];
        }
    }
    NSArray *sectionData = [arrsub copy];
    
    expandedSectionHeaderNumber = -1;
    if (sectionData.count == 0) {
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [_tblhistory beginUpdates];
        [_tblhistory deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [_tblhistory endUpdates];
    }
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSNumber *hid=[arrparent objectAtIndex:section];
    [arrsub removeAllObjects];
    
    for(int i=0;i<arrResult.count;i++) {
        HistoryMaster *tm=[arrResult objectAtIndex:i];
        if(tm.ID == hid.intValue) {
            [arrsub addObject:tm];
        }
    }
    
    NSArray *sectionData = [arrsub copy];
    
    if (sectionData.count == 0) {
        expandedSectionHeaderNumber = -1;
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i = 0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        expandedSectionHeaderNumber = section;
        [_tblhistory beginUpdates];
        [_tblhistory insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [_tblhistory endUpdates];
    }
}

#pragma mark Scrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    
    if(expandedSectionHeaderNumber == -1)
        reload_distance = 50;
    else
        reload_distance = 80;
    
    if(y > h + reload_distance) {
        if(isLoadMore) {
            isLoadMore = NO;
            intPageIndex++;
            [self GetHistory];
        }
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 2) {
        if(buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UIPasteboard generalPasteboard].string]];
        }
    }
}

#pragma mark Currency Value retrievel Delegate
-(void) sendDataToServer : (NSString *) method{

        
        NSURL *url = nil;
        NSMutableURLRequest *request = nil;
        
        // Only Difference between POST and GET is only in the way they send parameters
        
        if([method isEqualToString:@"GET"]){
            
            NSString *getURL = [NSString stringWithFormat:@"%@", URL];
            url = [NSURL URLWithString: getURL];
            request = [NSMutableURLRequest requestWithURL:url];
      //      NSLog(@"Request data  = %@", request);

            
        }
        else{  // POST
            
            
            
            NSString *parameter = [NSString stringWithFormat:@"%@", URL];
            NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            url = [NSURL URLWithString: URL];
            request = [NSMutableURLRequest requestWithURL:url];
          //  NSLog(@"request Data = %@", request);
            [request setHTTPBody:parameterData];
            
        }
        
        [request setHTTPMethod:method];
        [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if( connection )
        {
            
            mutableData = [NSMutableData new];
            
        }else{
            
            [self showemntyAlert];
            
        }
        

    
}


#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", NO_CONNECTION);
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
   // NSLog(@"Response from Server : %@", responseStringWithEncoded);
    NSString * receveiddata = responseStringWithEncoded;
    if ([receveiddata  isEqual: (@"null")]){
        NSLog(@"Plesae Check your internet Connection and the try again. . .");
       
    }else{
        [self getData:responseStringWithEncoded];
        
        
    }
    
}

-(void) getData:(NSString *) responseStringWithEncoded{
    
    NSData *data = [responseStringWithEncoded dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
    NSMutableDictionary *marketData = [json objectForKey:@"market_data"];
    
    currentPrice = [marketData objectForKey:@"current_price"];
    
  //  NSLog(@"API Data is %@", currentPrice);
   
    
    crncyValue = [[currentPrice objectForKey:savedValue] doubleValue];

    upperCase = [savedValue uppercaseString];
    
     [self GetBalance];
              // NSNumber *myDoubleNumber = [NSNumber numberWithDouble:valueForLabel];
               
            //  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            //   NSString *myString = [formatter stringFromNumber:@(crncyValue)];
        
    //NSString * forlable =[NSString stringWithFormat:@"%@ %@", myString ,upperCase];
 
    
             // self.txtCrcAmount.text = [NSString stringWithFormat:@"%f", crncyValue];;
             //  self.lblTotalDollar.text = upperCase;
    
        
}

-(void)showemntyAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection Problem"
                                                                   message:@"Please Check your internet Conneciton and then try again..."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Thank You" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


@end
