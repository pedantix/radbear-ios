//
//  RBUser.h
//  radbear-ios
//
//  Created by Gary Foster on 11/12/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBManagedObject.h"
#import "RBAvatar.h"

@interface RBUser : RBManagedObject

@property (nonatomic, retain) NSNumber *itemId;
@property (nonatomic, retain) NSNumber *is_me;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *authentication_token;
@property (nonatomic, retain) NSString *display_name;
@property (nonatomic, retain) NSString *first_name;
@property (nonatomic, retain) NSString *last_name;
@property (nonatomic, retain) NSString *mobile_phone;
@property (nonatomic, retain) NSNumber *account_verified;
@property (nonatomic, retain) NSNumber *admin;
@property (nonatomic, retain) NSDate *created_at;
@property (nonatomic, retain) NSString *upgrade_notice;
@property (nonatomic, retain) NSString *upgrade_url;

@property (nonatomic, retain) RBAvatar *avatar;

+ (NSDictionary *)mapping;
+ (NSArray *)relationshipMapping;
+ (NSDictionary *)writeMapping;
+ (RBUser *)findByEmail:(NSArray *)users email:(NSString *)email;
+ (NSArray *)additionalProfileFields;
- (BOOL) isAdmin;
- (NSArray *)rbservers;

@end
