//
//  OtherViewController.m
//  radbear-ios
//
//  Created by Gary Foster on 6/25/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBSettingsViewController.h"
#import "RBMenuOption.h"
#import "RBServerMessage.h"
#import "RBAppTools.h"

@implementation RBSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Settings"];
}

- (void)setDataSource {
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    if (rbApp.isAccountVerified) {
        RBMenuOption *profileItem = [[RBMenuOption alloc] init:@"My Profile" icon:[FAKFontAwesome userIconWithSize:50] darkTheme:rbApp.environment.darkThemeLists];
        [options addObject:profileItem];
    }
    
    //todo fix layout issue
    //RBMenuOption *aboutItem = [[RBMenuOption alloc] init:@"About" icon:[FAKFontAwesome infoCircleIconWithSize:50] darkTheme:rbApp.environment.darkThemeLists];
    //[options addObject:aboutItem];
    
    RBMenuOption *passwordItem = [[RBMenuOption alloc] init:@"Change Password" icon:[FAKFontAwesome lockIconWithSize:50] darkTheme:rbApp.environment.darkThemeLists];
    [options addObject:passwordItem];
    
    if (rbApp.environment.enableSpeedTest) {
        RBMenuOption *networkTestItem = [[RBMenuOption alloc] init:@"Internet Speed Test" icon:[FAKFontAwesome cloudUploadIconWithSize:50] darkTheme:rbApp.environment.darkThemeLists];
        [options addObject:networkTestItem];
    }
    
    if (rbApp.meUser.admin.boolValue) {
        RBMenuOption *serverItem = [[RBMenuOption alloc] init:@"Change Server" icon:[FAKFontAwesome barsIconWithSize:50] darkTheme:rbApp.environment.darkThemeLists];
        [options addObject:serverItem];
    }
    
    RBMenuOption *logOutItem = [[RBMenuOption alloc] init:[rbApp isAccountVerified] ? @"Logout" : @"Verify Account" icon:[FAKFontAwesome signOutIconWithSize:50] darkTheme:rbApp.environment.darkThemeLists];
    [options addObject:logOutItem];
    
    records = options;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditProfile"]) {
        UIViewController *vc = [segue destinationViewController];
        [vc setValue:[rbApp meUser] forKey:@"selectedItem"];
    }
}

//reminder: can't use alert view prompts here as they are sometimes overridden in sub classes

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBMenuOption *menuItem = [records objectAtIndex:indexPath.row];
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"RBMain" bundle:nil];
    
    if ([menuItem.display_name isEqualToString:@"My Profile"]) {
        UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"Profile"];
        [self.navigationController pushViewController:vc animated:TRUE];
    } else if ([menuItem.display_name isEqualToString:@"About"]) {
        UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"About"];
        [self.navigationController pushViewController:vc animated:TRUE];
    } else if ([menuItem.display_name isEqualToString:@"Change Password"]) {
        UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"Password"];
        [self.navigationController pushViewController:vc animated:TRUE];
    } else if ([menuItem.display_name isEqualToString:@"Change Server"]) {
        UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"Servers"];
        [self.navigationController pushViewController:vc animated:TRUE];
    } else if ([menuItem.display_name isEqualToString:@"Logout"] || [menuItem.display_name isEqualToString:@"Verify Account"]) {
        if ([rbApp isNetworkReachable:FALSE]) {
            [rbApp logout];
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
    } else if ([menuItem.display_name isEqualToString:@"Internet Speed Test"]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([rbApp isNetworkReachable:FALSE]) {
            [self runSpeedTest];
        }
    } else if ([menuItem.no_action isEqualToNumber:[NSNumber numberWithBool:TRUE]]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)runSpeedTest {
    UIImage *testImage = [UIImage imageNamed:@"speed-test-file.png"];
    NSData *testData = [NSData dataWithData:UIImagePNGRepresentation(testImage)];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[RBAppTools base64Encoding:[NSData dataWithData:testData]], @"test_file", nil];
    
    [self activityStart];
    
    [rbApp.objectManager.HTTPClient putPath:@"users/speed_test" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *headers = [operation.response allHeaderFields];
        NSString *runtimeHeader = [headers objectForKey:@"X-Runtime"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        double runtime = [[formatter numberFromString:runtimeHeader] doubleValue];
        NSNumber *mbps = [NSNumber numberWithDouble:(((1020593.0 * 8.0) / runtime) / 1000000)];
        NSString *mbpsString = [formatter stringFromNumber:mbps];
        
        [RBAppTools msgBox:[[@"Upload Speed: " stringByAppendingString:mbpsString] stringByAppendingString:@" Mbps"] withTitle:@"Test Complete"];
        
        [self activityEnd];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RBServerMessage msgWithOperation:operation error:error];
        [self activityEnd];
    }];
}

@end
