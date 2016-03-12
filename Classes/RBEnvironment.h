//
//  Environment.h
//  radbear-ios
//
//  Created by Gary Foster on 5/28/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SignupModeNone,
    SignupModeStandard,
    SignupModeWeb
} SignupMode;

@interface RBEnvironment : NSObject

@property (strong, nonatomic) NSString *apiVersionMimeType;
@property (strong, nonatomic) NSString *apiBaseURL;
@property (strong, nonatomic) NSString *baseURL;
@property (nonatomic) BOOL useMobilePhone;
@property (nonatomic) BOOL useFirstName;
@property (nonatomic) BOOL useLastName;
@property (nonatomic) BOOL useUsername;
@property (nonatomic) BOOL useAvatar;
@property (nonatomic) BOOL enableLocation;
@property (nonatomic) BOOL enableFacebook;
@property (nonatomic) BOOL enableFrictionless;
@property (nonatomic) BOOL enableConfirmation;
@property (nonatomic) BOOL enableSpeedTest;
@property (nonatomic) BOOL runningKifTests;
@property (nonatomic) BOOL wizardTestMode;
@property (nonatomic) BOOL darkTheme;
@property (nonatomic) BOOL darkThemeLists;
@property (nonatomic) SignupMode signupMode;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyEmail;
@property (strong, nonatomic) NSString *companyWebsite;
@property (strong, nonatomic) NSDictionary *environment;
@property (strong, nonatomic) NSArray *servers;

+ (RBEnvironment *)sharedInstance;
- (void)loadAppSettings:(NSDictionary *)data;

@end
