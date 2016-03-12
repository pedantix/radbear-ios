//
//  TabBarViewController.h
//  radbear-ios
//
//  Created by Gary Foster on 7/24/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontAwesomeKit/FAKFontAwesome.h"

static const int TAB_ICON_SIZE = 28;

@interface RBTabBarViewController : UITabBarController

- (void)assignIcon:(int)tabItem icon:(FAKFontAwesome *)icon;

@end
