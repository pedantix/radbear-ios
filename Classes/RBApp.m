//
//  RBApp.m
//  radbear-ios
//
//  Created by Gary Foster on 11/12/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBApp.h"
#import "Reachability.h"
#import "RBAppTools.h"
#import "RBServerMessage.h"
#import <AudioToolbox/AudioToolbox.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NSString* const NOTIFICATION_REFRESH = @"notificationRefresh";
NSString* const NOTIFICATION_PUSH_NOTIFICATION = @"notificationPushNotification";

@implementation RBApp

@synthesize registration, tabBarController, meUser, nonApiClient, objectManager, defaults, isTestDevice, environment, isSimulator, apnDeviceToken, objectPushed, messagePushed, users, isNetworkReachableViaWiFi;

+ (id)sharedInstance {
    static dispatch_once_t pred;
    static RBApp *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[RBApp alloc] init];
    });
    
    return sharedInstance;
}

- (void)dealloc {
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    NSLog(@"Catastrophic fault with RBApp");
    abort();
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.environment = [RBEnvironment sharedInstance];
        defaults = [NSUserDefaults standardUserDefaults];
        
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        reach.reachableBlock = ^(Reachability *reach) {
            reachable = TRUE;
            self.isNetworkReachableViaWiFi = [reach isReachableViaWiFi];
        };
        
        reach.unreachableBlock = ^(Reachability *reach) {
            reachable = FALSE;
            self.isNetworkReachableViaWiFi = FALSE;
        };
        [reach startNotifier];
        
        [self setIsTestDevice:NO];
        
#if TARGET_IPHONE_SIMULATOR
        self.isSimulator = TRUE;
#endif

        registration = [[RBRegistration alloc] init];
        
        [self restkitInitialize];
    }
    
    return self;
}

- (void)restkitInitialize {
    nonApiClient = [RBRailsNonApiClient sharedClient];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:environment.apiBaseURL]];
    [objectManager.HTTPClient setDefaultHeader:@"Accept" value:environment.apiVersionMimeType];
    [objectManager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //turn this on to log request and response bodies for use in building integration test http stubs
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    //tokens
    Class userClass = NSClassFromString(@"User");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id userMapping = [userClass performSelector:NSSelectorFromString(@"mapping")];
    id writeMapping = [userClass performSelector:NSSelectorFromString(@"writeMapping")];
#pragma clang diagnostic pop
    
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:userClass pathPattern:@"tokens" method:RKRequestMethodPOST]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny pathPattern:@"tokens" keyPath:@"users" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    //users
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:writeMapping objectClass:userClass rootKeyPath:@"user" method:RKRequestMethodAny]];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:userClass pathPattern:@"users/:itemId" method:RKRequestMethodPUT]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny pathPattern:@"users" keyPath:@"users" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny pathPattern:@"users/:itemId" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    //errors
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"message" toKeyPath:@"errorMessage"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    [objectManager addResponseDescriptor:errorDescriptor];
}

- (void)updateBadge:(int)tabIndex count:(int)count {
    if (count == 0)
        [self updateBadge:tabIndex value:nil];
    else
        [self updateBadge:tabIndex value:[NSString stringWithFormat:@"%d", count]];
}

- (void)updateBadge:(int)tabIndex value:(NSString *)value {
    UITabBarItem *tabItem = [tabBarController.tabBar.items objectAtIndex:tabIndex];
    [tabItem setBadgeValue:value];
}

- (bool)isAccountVerified {
    return meUser && meUser.account_verified && [meUser.account_verified boolValue];
}

- (BOOL)handleUsersLoaded:(NSArray *)loadedUsers silent:(BOOL)silent {
    for (RBUser *user in loadedUsers) {
        if ([user.is_me isEqualToNumber:[NSNumber numberWithBool:TRUE]])
            self.meUser = user;
    }
    
    if (self.meUser) {
        if (meUser.authentication_token && ![meUser.authentication_token isEqualToString:@""]) {
            [objectManager.HTTPClient setDefaultHeader:@"X-AUTH-TOKEN" value:meUser.authentication_token];
            self.users = [[NSMutableArray alloc] initWithArray:loadedUsers];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH object:nil];
            return TRUE;
        } else {
            if (!silent)
                [RBServerMessage msgWithString:@"Missing authentication, please contact support"];
            return FALSE;
        }
    } else {
        if (!silent)
            [RBServerMessage msgWithString:@"Could not load user data, please contact support"];
        return FALSE;
    }
}

- (bool)isNetworkReachable:(BOOL)silent {
    if (!reachable && !silent)
        [RBAppTools msgBox:@"This feature requires internet connection via WiFi or cellular network." withTitle:@"No Internet Connection"];
    
    return reachable;
}

- (id)collectionForDataView:(NSString *)class  {
    NSString *collectionName = [RBAppTools camelCaseToUnderscore:[class substringToIndex:[class length] - 14]];
    
    if([meUser respondsToSelector:NSSelectorFromString(collectionName)] && [meUser valueForKey:collectionName] != nil) {
        return [meUser valueForKey:collectionName];
    } else {
        NSLog(@"The '%@' collection does not exist in the user object.", collectionName);
        return nil;
    }
}

- (void)pushNotificationRegister:(NSData *)devToken {
    if (!isSimulator) {
        if (devToken) {
            apnDeviceToken = [[[devToken description]
                                    stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""];
        }
        
        NSLog(@"Device token %@", apnDeviceToken);
    }
}

- (void)pushNotificationFail:(NSError *)err {
    if (!isSimulator)
        NSLog(@"Error in registration. Error: %@", err);
}

- (void)maybePostDevice {
    if (!postedDevice && apnDeviceToken) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: apnDeviceToken, @"device_token", nil];
        [objectManager.HTTPClient postPath:@"devices" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            postedDevice = TRUE;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Could not post device: %@", [error localizedDescription]);
        }];
    }
}

- (void)processPushNotificationFromLaunch:(NSDictionary *)launchOptions {
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
        [self processPushNotification:userInfo];
}

- (void)processPushNotification:(NSDictionary *)userInfo {
    NSLog(@"Notification %@", userInfo.description);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSString *rawText = [apsInfo objectForKey:@"alert"];
    
    if (rawText)
        messagePushed = [self attributedStringWithHTMLString:rawText];
    else
        messagePushed = nil;
    
    objectPushed = [userInfo objectForKey:@"object_id"];
}

- (NSString *)attributedStringWithHTMLString:(NSString *)htmlString {
    //decode escaped html entities
    
    if (htmlString) {
        NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
        NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        return [[[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil] string];
    } else {
        return nil;
    }
}

-(void)logout {
    NSString *token = [objectManager.HTTPClient.defaultHeaders valueForKey:@"X-AUTH-TOKEN"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: meUser.itemId, @"user_id", nil];
    
    if (token) {
        [objectManager.HTTPClient deletePath:[@"tokens/" stringByAppendingString:token] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //do nothing on success
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [RBServerMessage msgWithError:error];
        }];
    } else {
        NSLog(@"There was no token when trying to log out, this should be investigated.");
    }
    
    registration.loggedOut = TRUE;
    registration.loggedOn = FALSE;
    [registration persist];
    
    meUser = nil;
    users = nil;
    
    if (environment.enableFacebook) {
        [[[FBSDKLoginManager alloc] init] logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }

    [objectManager.HTTPClient setDefaultHeader:@"X-AUTH-TOKEN" value:nil];
}

@end
