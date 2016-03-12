//
//  Registration.h
//  radbear-ios
//
//  Created by Gary Foster on 6/18/13.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RegistrationMethodDevice,
    RegistrationMethodEmail,
    RegistrationMethodFacebook,
} RegistrationMethod;

@interface RBRegistration : NSObject {
    NSUserDefaults *defaults;
}

@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic) BOOL accountVerified;
@property (nonatomic) BOOL loggedOut;
@property (nonatomic) BOOL loggedOn;
@property (nonatomic) RegistrationMethod lastRegistrationMethod;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

- (void)persist;
- (void)reset;
+ (NSString *)getNewUniqueId;

@end
