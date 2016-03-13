//
//  RBServersViewController.m
//  Pods
//
//  Created by Gary Foster on 1/3/16.
//
//

#import "RBServersViewController.h"
#import "RBSimpleObject.h"
#import "RBAppTools.h"

@implementation RBServersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Change Server"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBSimpleObject *server = [records objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:server.display_name forKey:@"server"];
    
    [RBAppTools msgInfo:[[@"Next time your app is closed and re-opened, it will be connected to the " stringByAppendingString:server.display_name] stringByAppendingString:@" server"]];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
