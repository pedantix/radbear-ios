//
//  RBMenuOption.h
//  rad_gallery-ios
//
//  Created by Gary Foster on 12/1/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBManagedObject.h"
#import "RBAvatar.h"
#import "FontAwesomeKit/FAKFontAwesome.h"

@interface RBMenuOption : RBManagedObject<RBManagedObjectProtocol>

@property (nonatomic, retain) NSString *display_name;
@property (nonatomic, retain) NSNumber *highlight;
@property (nonatomic, retain) NSNumber *no_action;

@property (nonatomic, retain) RBAvatar *avatar;

-(id)init:(NSString *)title icon:(FAKFontAwesome *)icon darkTheme:(BOOL)darkTheme;
-(id)init:(NSString *)title icon:(FAKFontAwesome *)icon highlight:(BOOL)theHighlight noAction:(BOOL)theNoAction darkTheme:(BOOL)darkTheme;

@end
