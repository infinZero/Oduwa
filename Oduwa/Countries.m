//
//  Countries.m
//  Oduwa
//
//  Created by Faiz Fareed on 5/6/20.
//  Copyright © 2020 Jayesh. All rights reserved.
//

#import "Countries.h"
#import "Settings.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>

@interface Countries ()
{
    Global *Glb;

    NSMutableArray* arrayData;
    
    NSMutableArray *resultingArray;
    NSMutableDictionary *finalArgument;
    NSMutableDictionary *finalValue;

}
@end

@implementation Countries
//@synthesize filemgr,docPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // [self.tableview LoadData];
    
   [self getdocumentPath];
  //  [self GetBalance];
    //self.tableView.delegate = self;
   // self.tableView.dataSource = self;
    
     
}

-(void)getdocumentPath{
    
  //  [self GetBalance];
      arrayData=[[NSMutableArray alloc] initWithObjects:@"aed",@"ars",@"aud",@"bch",@"bdt",@"bhd",@"bmd",@"bnb",@"brl",@"btc",@"cad",@"chf",@"clp",@"cny",@"czk",@"dkk",@"eos",@"eth",@"eur",@"gbp",@"hkd",@"huf",@"idr",@"ils",@"inr",@"jpy",@"krw",@"kwd",@"lkr",@"ltc",@"mmk",@"mxn",@"myr",@"nok",@"nzd",@"php",@"pkr",@"rub",@"sar",@"sek",@"sgd",@"thb",@"try",@"twd",@"uah",@"usd",@"vef",@"vnd",@"xag",@"xau",@"xdr",@"xlm",@"xrp",@"zar",nil];
    resultingArray = [[NSMutableArray alloc] initWithObjects:@"usd",@"btc",@"inr",@"aed",@"ars",@"aud",@"bch",@"bdt",@"bhd",@"bmd",@"bnb",@"brl",@"cad",@"chf",@"clp",@"cny",@"czk",@"eos",@"eth",@"eur",@"gbp",@"hkd",@"huf",@"idr",@"ils",@"jpy",@"krw",@"kwd",@"lkr",@"ltc",@"mmk",@"mxn",@"myr",@"nok",@"nzd",@"php",@"pkr",@"pln",@"rub",@"sar",@"sek",@"sgd",@"thb",@"try",@"twd",@"uah",@"vef",@"vnd",@"xag",@"xau",@"xdr",@"xlm",@"xrp",@"zar",@"amd",@"bif",@"bob",@"cop",@"etb",@"ghs",@"gnf",@"htg",@"isk",@"irr",@"jmd",@"kes",@"lrd",@"lyd",@"ngn",@"pen",@"rwf",@"ttd",@"tzs",@"xaf",@"xpf",@"xof",@"zmw",@"zwl", nil];
   //NSLog (@"File list is %@",arrayData);

    /*
    docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"CurrencyIcons"];
    // NSString* folder=[documentDirectory stringByAppendingPathComponent:@"VoiceDB"];
    filemgr = [NSFileManager defaultManager];
    filelist= [filemgr contentsOfDirectoryAtPath:docPath error:nil];
    NSLog (@"File list is %@",filelist);
    
    [self.tableView reloadData];
    */
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    //return arrayData.count;
    return resultingArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
//    NSDictionary *myDict = [resultingArray objectAtIndex:indexPath.row];
//    NSString *currencyCountry = [myDict objectForKey:@"Name"];
//    NSString *upperCaseCurrency = [currencyCountry uppercaseString];
//    cell.textLabel.text = upperCaseCurrency;
//    cell.imageView.image = [UIImage imageNamed:currencyCountry];
    
//    NSString *mystring = [arrayData objectAtIndex:indexPath.row];
//    NSString *upperCase = [mystring uppercaseString];
//
//    cell.textLabel.text = upperCase;
//    cell.imageView.image = [UIImage imageNamed:mystring];

     NSString *mystring = [resultingArray objectAtIndex:indexPath.row];
        NSString *upperCase = [mystring uppercaseString];
    
        cell.textLabel.text = upperCase;
        cell.imageView.image = [UIImage imageNamed:mystring];

    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   //accessing selected row's cell text
    NSString * contryCurrency = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
   //Saving string value in userdefault
   // NSLog(@"Selected Currency is %@", contryCurrency);
     NSString *lowerCase = [contryCurrency lowercaseString];

    [[NSUserDefaults standardUserDefaults] setObject:lowerCase forKey:@"preferedCurrency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    //moving back to the previous view controller
   /*
    Settings *previousVController = (Settings *)[self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:previousVController animated:YES];
*/
    [self.navigationController popViewControllerAnimated:true];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)GetBalance {
    @try {
//        if (![Glb isNetworkAvailable]) {
//            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
//            return;
//        }
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
//                self->douBalanceAmount = [[dic valueForKey:@"Amount"]  doubleValue];
//                NSLog(@"Amount = %f", self->douBalanceAmount);
               self->resultingArray = [dic valueForKey:@"currnecy"];
                NSLog(@"resulting array %@", self->resultingArray);
//                for (NSDictionary *aDict in self->resultingArray) {
//                    if ([aDict objectForKey:@"Name"]  == self->savedValue) {
//                       // id was indeed 1, replace '1', with the id that you're looking for
//                        self->crncyValue = [[aDict valueForKey:@"Price"] doubleValue];
//                        NSLog(@"%@ = %f", self->savedValue, self->crncyValue);
//                   }
//                }
//                self->upperCase = [self->savedValue uppercaseString];
//
//              //  self->douDollorAmount = [[[dic valueForKey:@"Result"] valueForKey:@"OWC_PRICE"]  doubleValue];
//                self->douTotalAmount = self->douBalanceAmount * self->crncyValue;
//
//                self->strBalance = [NSString stringWithFormat:@"%.04f",self->douBalanceAmount];
//
//                self->strBalance = [self->strBalance stringByAppendingString:@" OWC = "];
//
//                self->strBalance = [self->strBalance stringByAppendingString:[NSString stringWithFormat:@"%.02f",self->douTotalAmount]];
//
//                self->strBalance = [self->strBalance stringByAppendingString:@" "];
//
//                self->strBalance = [self->strBalance stringByAppendingString:self->upperCase];
//
//                [self.lblBalance setText:self->strBalance];
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

@end

