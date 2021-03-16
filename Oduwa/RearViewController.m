
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "RearViewController.h"
#import "SWRevealViewController.h"

@interface RearViewController() {
    NSInteger _presentedRow;
}

@end

@implementation RearViewController
@synthesize rearTableView = _rearTableView;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_rearTableView reloadData];
    
    self.rearTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma marl - UITableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    NSString *text = nil;
    if (row == 0) {
        text = @"  HOME";
        cell.imageView.image = [UIImage imageNamed:@"baseline_home_white_18dp"];
    } else if (row == 1) {
        text = @"  SEND";
        cell.imageView.image = [UIImage imageNamed:@"baseline_send_white_18dp"];
    } else if (row == 2) {
        text = @"  RECEIVE";
        cell.imageView.image = [UIImage imageNamed:@"baseline_call_received_white_18dp"];
    } else if (row == 3) {
        text = @" BUY COINS";
        cell.imageView.image = [UIImage imageNamed:@"baseline_call_received_white_18dp"];
    }
    else if (row == 4) {
        text = @"  SETTING";
        cell.imageView.image = [UIImage imageNamed:@"baseline_settings_white_18dp"];
    }
    cell.textLabel.text = NSLocalizedString( text,nil );
    [cell.textLabel setFont:[UIFont fontWithName:@"CenturyGothic" size:14]];
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealController = self.revealViewController;
    
    NSInteger row = indexPath.row;
    
    if ( row == _presentedRow ) {
        //[revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        //return;
    }
    if (row == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Home *controller = (Home *)[sb instantiateViewControllerWithIdentifier:@"Home"];
        [revealController pushFrontViewController:controller animated:YES];
    } else if (row == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Send *controller = (Send *)[sb instantiateViewControllerWithIdentifier:@"Send"];
        controller.type = @"Menu";
        [revealController pushFrontViewController:controller animated:YES];
    } else if (row == 2) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Receive *controller = (Receive *)[sb instantiateViewControllerWithIdentifier:@"Receive"];
        controller.type = @"Menu";
        [revealController pushFrontViewController:controller animated:YES];
    } else if (row == 3) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://coinpayment.net/$Oduwapay"]];
    }else if (row == 4) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Settings *controller = (Settings *)[sb instantiateViewControllerWithIdentifier:@"Settings"];
        [revealController pushFrontViewController:controller animated:YES];
    }
    _presentedRow = row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
