//
//  Avatar.m
//  radbear-ios
//
//  Created by Gary Foster on 10/15/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBAvatar.h"
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "UIColor+CreateMethods.h"
#import "RBAppTools.h"

@implementation RBAvatar

@synthesize small, normal, large, image, icon_name, icon_color;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromArray:@[@"small", @"normal", @"large", @"icon_name", @"icon_color"]];
    
    return objectMapping;
}

- (UIImage *)faImage:(CGFloat)size {
    if (self.icon_name && self.icon_color) {
        NSString *convertedName = [RBAppTools dashToCamelCase:[self.icon_name substringFromIndex:3]];
        return [RBAppTools getFontAwesomeIcon:convertedName color:[UIColor colorWithName:self.icon_color] size:size];
    } else {
        return nil;
    }
}

@end
