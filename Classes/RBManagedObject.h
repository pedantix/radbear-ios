//
//  ManagedObject.h
//  radbear-ios
//
//  Created by Gary Foster on 8/22/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol RBManagedObjectProtocol <NSObject>

+ (RKObjectMapping *)mapping;

@end

@class RKObjectMapping;

@interface RBManagedObject : NSObject

- (NSString *)getDisplayName;

@end