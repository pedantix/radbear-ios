//
//  Registration.m
//  radbear-ios
//
//  Created by Gary Foster on 6/18/13.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBRegistration.h"

@implementation RBRegistration

@synthesize accountVerified, loggedOut, loggedOn, deviceId, lastRegistrationMethod, email, password;

-(id)init {
    if (self = [super init]) {
        defaults = [NSUserDefaults standardUserDefaults];
        
        accountVerified = [defaults boolForKey:@"verified"];
        loggedOut = [defaults boolForKey:@"loggedOut"];
        lastRegistrationMethod = (int)[defaults integerForKey:@"lastRegistrationMethod"];
        email = [defaults objectForKey:@"email"];
        password = [defaults objectForKey:@"password"];
        
        if (![defaults stringForKey:@"deviceId"]) {
            deviceId = [RBRegistration getNewUniqueId];
            [defaults setObject:deviceId forKey:@"deviceId"];
            [defaults synchronize];
        } else {
            deviceId = [defaults stringForKey:@"deviceId"];
        }
    }
    return self;
}

+(NSString *)getNewUniqueId {
    id appIdObject = [NSUUID UUID];
    NSString *newId = [appIdObject UUIDString];
    
    if (newId == nil) {
        //this is required for iOS 5 as the [NSUUID UUID] method is >= 6
        NSString *uuidString = nil;
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        if (uuid) {
            uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
            CFRelease(uuid);
        }
        newId = uuidString;
    }
    
    return newId;
}

-(void)persist {
    [defaults setBool:accountVerified forKey:@"verified"];
    [defaults setBool:loggedOut forKey:@"loggedOut"];
    [defaults setInteger:lastRegistrationMethod forKey:@"lastRegistrationMethod"];
    [defaults setObject:email forKey:@"email"];
    [defaults setObject:password forKey:@"password"];
    
    [defaults synchronize];
}

-(void)reset {
    deviceId = [RBRegistration getNewUniqueId];
    accountVerified = FALSE;
    lastRegistrationMethod = RegistrationMethodDevice;
    email = nil;
    [self persist];
}

@end