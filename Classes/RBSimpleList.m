//
//  SimpleList.m
//  radbear-ios
//
//  Created by Gary Foster on 6/26/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBSimpleList.h"
#import "RBAppTools.h"
#import "RBServerMessage.h"
#import "DejalActivityView.h"
#import "RBSimpleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FontAwesomeKit/FontAwesomeKit.h"

@implementation RBSimpleList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rbApp = [RBApp sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded:) name:NOTIFICATION_REFRESH object:nil];
    
    NSString *className = [self.class description];
    NSString *title = [[className componentsSeparatedByString:@"ViewController"] objectAtIndex:0];
    [[self navigationItem] setTitle:[RBAppTools camelCaseToWords:title]];
    
    self.tableView.accessibilityLabel = @"simpleListTable";
    
    if (darkTheme == nil)
        darkTheme = [NSNumber numberWithBool:rbApp.environment.darkThemeLists];

    if ([RBAppTools hasBackgroundImage:self]) {
        self.view.backgroundColor = [UIColor clearColor];
        UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
        backgroundImageView.image = [RBAppTools getBackgroundImage:self];
        [self.parentViewController.view insertSubview:backgroundImageView atIndex:0];
    } else {
        self.view.backgroundColor = [darkTheme boolValue] ? [UIColor blackColor] : [UIColor whiteColor];
        self.parentViewController.view.backgroundColor = self.view.backgroundColor;
    }
    
    if ([darkTheme boolValue])
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (enableHome) {
        UIImage *imgHome = [RBAppTools getFontAwesomeIcon:[FAKFontAwesome homeIconWithSize:30]];
        butHome = [[UIBarButtonItem alloc] initWithImage:imgHome landscapeImagePhone:imgHome style:UIBarButtonItemStylePlain target:self action:@selector(goHome)];
        [[self navigationItem] setRightBarButtonItem:butHome];
    }
    
    if(enableAdd) {
        UIBarButtonItem *butAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(add)];
        [butAdd setTintColor:RBAppTools.greenColor];
        [self.navigationItem setRightBarButtonItem:butAdd];
    }
    
    [self setDataSource];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor magentaColor];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Pull to Refresh"];
    [titleString addAttribute:NSForegroundColorAttributeName value:[darkTheme boolValue] ? [UIColor whiteColor] : [UIColor blackColor] range:NSMakeRange(0, titleString.length)];
    refreshControl.attributedTitle = titleString;
    
    [refreshControl addTarget:self action:@selector(reloadBaseData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)setDataSource {
    //override this method to use a custom data source
    records = [rbApp collectionForDataView:[[self class] description]];
}

- (void)dataLoaded:(NSNotification *) notification {
    [self setDataSource];
    [self.tableView reloadData];
}

- (void)reloadBaseData {
    if ([rbApp isNetworkReachable:FALSE]) {
        [rbApp.objectManager getObjectsAtPath:@"users" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            if ([rbApp handleUsersLoaded:[mappingResult array] silent:FALSE]) {
                [self dataLoaded:nil];
                [self.refreshControl endRefreshing];
            } else {
                [self.refreshControl endRefreshing];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [RBServerMessage msgWithError:error];
            [self.refreshControl endRefreshing];
        }];
    } else
        [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBSimpleCell *cell = (RBSimpleCell*)[self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    RBManagedObject *record = [records objectAtIndex:indexPath.row];
    NSString *cellText;
    
    cellText = [record getDisplayName];
    
    NSString *sub1;
    if([record respondsToSelector:NSSelectorFromString(@"display_sub1")])
        sub1 = [record valueForKey:@"display_sub1"];
    else
        sub1 = nil;
    
    NSString *sub2;
    if([record respondsToSelector:NSSelectorFromString(@"display_sub2")])
        sub2 = [record valueForKey:@"display_sub2"];
    else
        sub2 = nil;
    
    NSString *sub3;
    if([record respondsToSelector:NSSelectorFromString(@"display_sub3")]) {
        sub3 = [record valueForKey:@"display_sub3"];
        hasSubText = TRUE;
    }
    else {
        sub3 = nil;
    }
    if([record respondsToSelector:NSSelectorFromString(@"avatar")]) {
        RBAvatar *avatar = [record valueForKey:@"avatar"];
        if (avatar.image) {
            [cell.imageView setImage:avatar.image];
        }
        else {
            [cell.imageView setImageWithURL:[NSURL URLWithString:avatar.small] placeholderImage:[self placeHolderImage]];
            if( enableRoundedImages )
            {
                cell.imageView.layer.masksToBounds = YES;
                cell.imageView.clipsToBounds = YES;
                cell.imageView.layer.cornerRadius = 24;
            }
        }
    }
    
    BOOL noAction;
    if([record respondsToSelector:NSSelectorFromString(@"no_action")])
        noAction = [[record valueForKey:@"no_action"] boolValue];
    else
        noAction = FALSE;
    
    BOOL display_indicator;
    if([record respondsToSelector:NSSelectorFromString(@"display_indicator")])
        display_indicator = [[record valueForKey:@"display_indicator"] boolValue];
    else
        display_indicator = FALSE;
    
    [cell setAccessoryType:noAction ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator];
    
    BOOL highlight;
    if ([[[record class] description] isEqualToString:@"RBMenuOption"]) {
        if([record respondsToSelector:NSSelectorFromString(@"highlight")])
            highlight = [[record valueForKey:@"highlight"] boolValue];
        else
            highlight = FALSE;
    } else {
        highlight = FALSE;
    }
    
    if ([darkTheme boolValue])
        [cell changeCellStyle:(int)indexPath.row cellText:cellText sub1:sub1 sub2:sub2 sub3:sub3 highlight:highlight color:nil tableWidth:[RBAppTools screenWidthForOrientation] addIndicator:display_indicator];
    else
        [cell changeCellStyle:cellText sub1:sub1 sub2:sub2 sub3:sub3 highlight:highlight tableWidth:[RBAppTools screenWidthForOrientation] addIndicator:display_indicator];    
    
    return cell;
}

- (void)add {
    [self performSegueWithIdentifier:@"Add" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(hasSubText)
        return 70;
    else
        return 50;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowDetails"]) {
        RBSimpleViewController *vc = [segue destinationViewController];
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        [vc setSelectedItem:[records objectAtIndex:selectedIndex]];
    }
}

-(void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goHome {
    if (rbApp.tabBarController)
        [rbApp.tabBarController setSelectedIndex:0];
    else
        [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)activityStart {
    [DejalBezelActivityView activityViewForView:self.view];
}

- (void)activityEnd {
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (UIImage *)placeHolderImage {
    NSError *err = nil;
    FAKIonIcons *personIcon = [FAKIonIcons iconWithIdentifier:@"ion-person" size:48 error:err];
    return [personIcon imageWithSize:CGSizeMake(15, 15)];
}

@end
