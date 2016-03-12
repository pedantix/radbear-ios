//
//  ManagedObject.m
//  radbear-ios
//
//  Created by Gary Foster on 8/22/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBManagedObject.h"

@implementation RBManagedObject

- (NSString *)getDisplayName {
    //todo can we throw error if obj has a property named displayName, since that will collide w/ this?
    
    if ([self respondsToSelector:NSSelectorFromString(@"display_name")] && [self valueForKey:@"display_name"])
        return [self valueForKey:@"display_name"];
    else if ([self respondsToSelector:NSSelectorFromString(@"name")] && [self valueForKey:@"name"])
        return [self valueForKey:@"name"];
    else
        return @"Unknown Object";
}

@end