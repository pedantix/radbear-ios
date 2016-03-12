//
//  Environment.m
//  radbear-ios
//
//  Created by Gary Foster on 5/28/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBEnvironment.h"
#import "RBAppTools.h"

@implementation RBEnvironment

static RBEnvironment *sharedInstance = nil;

@synthesize apiVersionMimeType, apiBaseURL, baseURL, useMobilePhone, useFirstName, useLastName, useUsername, useAvatar, enableLocation, runningKifTests, enableFrictionless, enableConfirmation, enableFacebook, enableSpeedTest, darkTheme, darkThemeLists, companyEmail, companyName, companyWebsite, signupMode;

- (id)init {
    self = [super init];
    return self;
}

- (void)initializeSharedInstance {
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* envsPListPath = [bundle pathForResource:@
                               "Environments" ofType:@"plist"];
    
    //global settings
    NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    
    NSMutableArray *serverKeys = [[NSMutableArray alloc] init];
    for(id key in environments) {
        id value = [environments objectForKey:key];
        
        if([value isKindOfClass:[NSDictionary class]])
            [serverKeys insertObject:key atIndex:0];
    }
    
    
    self.servers = [serverKeys copy];
    
    NSArray *keys = [self.servers arrayByAddingObjectsFromArray:@[@"api_version_mime_type", @"dark_theme", @"dark_theme_lists"]];
    
    [self checkKeys:environments keys:keys];
    
    self.apiVersionMimeType = [environments objectForKey:@"api_version_mime_type"];
    self.darkTheme = [[environments objectForKey:@"dark_theme"] boolValue];
    self.darkThemeLists = [[environments objectForKey:@"dark_theme_lists"] boolValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* configuration;
    
    if ([defaults stringForKey:@"server"])
        configuration = [defaults stringForKey:@"server"];
    else
        configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
    
    //environment specific settings
    self.environment = [environments objectForKey:configuration];
    
    keys = @[@"base_url"];
    [self checkKeys:self.environment keys:keys];
    
    if ([configuration isEqualToString:@"Debug"]) {
        [self checkKeys:self.environment keys:@[@"wizard_test_mode"]];
        [self checkEnvironmentVariables:@[@"running_kif_tests"]];
    }
    
    self.runningKifTests = [[[[NSProcessInfo processInfo] environment] objectForKey:@"running_kif_tests"] boolValue];
    
    self.baseURL = self.runningKifTests ? @"http://localhost:12345" : [self.environment valueForKey:@"base_url"];
    NSURL *url = [NSURL URLWithString:[self.environment valueForKey:@"base_url"]];
    
    if (![configuration isEqualToString:@"Debug"] && ![url.scheme isEqualToString:@"https"])
        [RBAppTools msgInfo:@"Unsecured api url"];
    
    self.apiBaseURL = [self.baseURL stringByAppendingString:@"/api"];
    self.wizardTestMode = [[self.environment valueForKey:@"wizard_test_mode"] boolValue] && !self.runningKifTests;
}

- (void)loadAppSettings:(NSDictionary *)data {
    self.useMobilePhone = [[data valueForKey:@"use_mobile_phone"] boolValue];
    self.useFirstName = [[data valueForKey:@"use_first_name"] boolValue];
    self.useLastName = [[data valueForKey:@"use_last_name"] boolValue];
    self.useUsername = [[data valueForKey:@"use_username"] boolValue];
    self.useAvatar = [[data valueForKey:@"use_avatar"] boolValue];
    self.enableLocation = [[data valueForKey:@"enable_location"] boolValue];
    self.enableFacebook = [[data valueForKey:@"enable_facebook"] boolValue];
    self.enableFrictionless = [[data valueForKey:@"enable_frictionless"] boolValue];
    self.enableConfirmation = [[data valueForKey:@"enable_confirmation"] boolValue];
    self.enableSpeedTest = [[data valueForKey:@"enable_speed_test"] boolValue];
    self.companyName = [data valueForKey:@"company_name"];
    self.companyEmail = [data valueForKey:@"company_email"];
    self.companyWebsite = [data valueForKey:@"company_website"];
    self.signupMode = [[data valueForKey:@"signup_mode"] intValue];
    
    if (self.enableLocation)
        [self checkKeys:[[NSBundle mainBundle] infoDictionary] keys:@[@"NSLocationAlwaysUsageDescription", @"NSLocationWhenInUseUsageDescription"]];
}

- (void)checkKeys:(NSDictionary *)dictionary keys:(NSArray *)keys {
    for (NSString *key in keys) {
        if ([dictionary valueForKey:key] == nil) {
            [RBAppTools msgInfo:[@"Missing environment key: " stringByAppendingString:key]];
            break;
        }
    }
}

- (void)checkEnvironmentVariables:(NSArray *)keys {
    for (NSString *key in keys) {
        if ([[[NSProcessInfo processInfo] environment] objectForKey:key] == nil) {
            [RBAppTools msgInfo:[@"Missing environment variable: " stringByAppendingString:key]];
            break;
        }
    }
}

#pragma mark - Lifecycle Methods

+ (RBEnvironment *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            [sharedInstance initializeSharedInstance];
        }
        return sharedInstance;
    }
}

@end

