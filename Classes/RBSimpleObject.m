//
//  RBSimpleObject.m
//  Pods
//
//  Created by Gary Foster on 1/3/16.
//
//

#import "RBSimpleObject.h"

@implementation RBSimpleObject

@synthesize display_name;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"name" : @"display_name",
                                                        }];
    
    return objectMapping;
}

- (NSString *)itemId {
    return self.display_name;
}

@end
