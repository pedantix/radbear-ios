//
//  Avatar.h
//  radbear-ios
//
//  Created by Gary Foster on 10/15/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBManagedObject.h"

@interface RBAvatar : RBManagedObject<RBManagedObjectProtocol>

@property (nonatomic, retain) NSString *small;
@property (nonatomic, retain) NSString *normal;
@property (nonatomic, retain) NSString *large;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *icon_name;
@property (nonatomic, retain) NSString *icon_color;

- (UIImage *)faImage:(CGFloat)size;

@end
