//
//  RBSimpleObject.h
//  Pods
//
//  Created by Gary Foster on 1/3/16.
//
//

#import <Foundation/Foundation.h>
#import "RBManagedObject.h"

@interface RBSimpleObject : RBManagedObject<RBManagedObjectProtocol>

@property (nonatomic, retain) NSString *display_name;

- (NSString *)itemId;

@end
