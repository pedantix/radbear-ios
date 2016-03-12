//
//  RBUser.m
//  radbear-ios
//
//  Created by Gary Foster on 11/12/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBUser.h"
#import "RBSimpleObject.h"
#import "RBEnvironment.h"

@implementation RBUser

@synthesize itemId, email, authentication_token, display_name, first_name, last_name, avatar, username, mobile_phone, account_verified, is_me, admin, created_at;

+ (NSDictionary *)mapping {
    return @{
             @"id" : @"itemId",
             @"is_me" : @"is_me",
             @"admin" : @"admin",
             @"created_at" : @"created_at",
             @"authentication_token" : @"authentication_token",
             @"account_verified" : @"account_verified",
             @"display_name" : @"display_name",
             @"first_name" : @"first_name",
             @"last_name" : @"last_name",
             @"email" : @"email",
             @"username" : @"username",
             @"mobile_phone" : @"mobile_phone",
             @"upgrade_notice" : @"upgrade_notice",
             @"upgrade_url" : @"upgrade_url"
             };
}

+ (NSArray *)relationshipMapping {
    RKRelationshipMapping *avatarMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"avatar" toKeyPath:@"avatar" withMapping:[RBAvatar mapping]];
    NSArray *mappings = [NSArray arrayWithObjects:avatarMapping, nil];
    return mappings;
}

+ (NSDictionary *)writeMapping {
    return @{
             @"itemId" : @"id",
             @"first_name" : @"first_name",
             @"last_name" : @"last_name",
             @"username" : @"username",
             @"mobile_phone" : @"mobile_phone",
             };
}

+ (RBUser *)findByEmail:(NSArray *)users email:(NSString *)email {
    for (RBUser *user in users) {
        if ([user.email isEqualToString:email])
            return user;
    }
    
    NSLog(@"Could not find user with email %@", email);
    return nil;
}

+ (NSArray *)additionalProfileFields {
    //this is meant to be overridden as needed by any subclasses
    return nil;
}

- (BOOL)isAdmin {
    return [self.admin isEqualToNumber:[NSNumber numberWithBool:TRUE]];
}

- (NSArray *)rbservers {
    NSArray *names = [RBEnvironment sharedInstance].servers;
    NSMutableArray *servers = [[NSMutableArray alloc] init];
    
    for (NSString *name in names) {
        RBSimpleObject *server = [[RBSimpleObject alloc] init];
        server.display_name = name;
        [servers addObject:server];
    }
    
    return servers;
}

@end
