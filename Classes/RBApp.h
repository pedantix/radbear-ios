//
//  RBApp.h
//  radbear-ios
//
//  Created by Gary Foster on 11/12/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBRegistration.h"
#import "RBEnvironment.h"
#import "RBTabBarViewController.h"
#import "RBUser.h"
#import "RBRailsNonApiClient.h"

extern NSString* const NOTIFICATION_REFRESH;
extern NSString *const NOTIFICATION_PUSH_NOTIFICATION;

@interface RBApp : NSObject {
    bool reachable;
    bool postedDevice;
}

@property (nonatomic, strong) RBRegistration *registration;
@property (nonatomic, strong) RBEnvironment *environment;
@property (nonatomic, strong) RBTabBarViewController *tabBarController;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) RBUser *meUser;
@property (nonatomic, strong) RBRailsNonApiClient *nonApiClient;
@property (nonatomic, retain) RKObjectManager *objectManager;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSString *apnDeviceToken;
@property (nonatomic, strong) NSString *objectPushed;
@property (nonatomic, strong) NSString *messagePushed;
@property (nonatomic) bool isSimulator;
@property BOOL isTestDevice;
@property BOOL isNetworkReachableViaWiFi;

+(id)sharedInstance;

- (bool)isNetworkReachable:(BOOL)silent;
- (bool)isAccountVerified;
- (BOOL)handleUsersLoaded:(NSArray *)loadedUsers silent:(BOOL)silent;
- (id)collectionForDataView:(NSString *)sourceClass;
- (void)updateBadge:(int)tabIndex count:(int)count;
- (void)updateBadge:(int)tabIndex value:(NSString *)value;
- (void)logout;

//push notifications
- (void)pushNotificationRegister:(NSData *)devToken;
- (void)pushNotificationFail:(NSError *)err;
- (void)maybePostDevice;
- (void)processPushNotificationFromLaunch:(NSDictionary *)launchOptions;
- (void)processPushNotification:(NSDictionary *)userInfo;

@end
