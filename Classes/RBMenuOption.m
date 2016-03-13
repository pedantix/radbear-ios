//
//  RBMenuOption.m
//  rad_gallery-ios
//
//  Created by Gary Foster on 12/1/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBMenuOption.h"
#import "RBAppTools.h"

@implementation RBMenuOption

@synthesize display_name, avatar, highlight, no_action;

-(id)init:(NSString *)title icon:(FAKFontAwesome *)icon darkTheme:(BOOL)darkTheme {
    if(self=[super init]){
        self.display_name = title;
        self.highlight = [NSNumber numberWithBool:FALSE];
        self.no_action = [NSNumber numberWithBool:FALSE];
        
        if (icon) {
            self.avatar = [[RBAvatar alloc]init];
            self.avatar.image = [RBAppTools getFontAwesomeIcon:icon darkTheme:darkTheme dim:TRUE];
        }
    }
    return self;
}

-(id)init:(NSString *)title icon:(FAKFontAwesome *)icon highlight:(BOOL)theHighlight noAction:(BOOL)theNoAction darkTheme:(BOOL)darkTheme {
    if(self=[super init]){
        self.display_name = title;
        self.highlight = [NSNumber numberWithBool:theHighlight];
        self.no_action = [NSNumber numberWithBool:theNoAction];
        
        if (icon) {
            self.avatar = [[RBAvatar alloc]init];
            self.avatar.image = [RBAppTools getFontAwesomeIcon:icon darkTheme:darkTheme dim:TRUE];
        }
    }
    return self;
}

+ (RKObjectMapping *)mapping {
    return nil;
}

@end
