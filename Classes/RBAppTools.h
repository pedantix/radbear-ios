//
//  RBAppTools.h
//  radbear-ios
//
//  Created by Gary Foster on 10/9/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FontAwesomeKit/FAKFontAwesome.h"

@interface RBAppTools : NSObject

//alerts
+ (void) msgBox:(NSString *)message withTitle:(NSString *)title;
+ (void) msgSuccess:(NSString *)message;
+ (void) msgInfo:(NSString *)message;

//string and ui
+ (NSString *) camelCaseToWords:(NSString *)input;
+ (NSString *) camelCaseToUnderscore:(NSString *)input;
+ (NSString *) dashToCamelCase:(NSString *)input;
+ (NSString *) underscoreToWords:(NSString *)input;
+ (UIColor *) greenColor;
+ (UIColor *) tintColorDefault;
+ (NSString *) getOrdinalNumber:(int)number;
+ (NSString *) appName;
+ (UIImage *)getFontAwesomeIcon:(FAKFontAwesome *)icon darkTheme:(BOOL)darkTheme dim:(BOOL)dim;
+ (UIImage *)getFontAwesomeIcon:(FAKFontAwesome *)icon;
+ (UIImage *)getFontAwesomeIcon:(FAKFontAwesome *)icon color:(UIColor *)color;
+ (UIImage *)getFontAwesomeIcon:(NSString *)iconName color:(UIColor *)color size:(float)size;
+ (UIButton *)getBarButton:(FAKFontAwesome *)icon text:(NSString *)text target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)getBarItem:(UIButton *)but;

//layout
+ (void) moveUp:(UIView *)view distance:(int)distance;
+ (void) moveDown:(UIView *)view distance:(int)distance;
+ (void) changeVerticalPosition:(UIView *)view position:(int)position;
+ (void) changeHorizontalPosition:(UIView *)view position:(int)position;
+ (void) changeWidth:(UIView *)view width:(int)height;
+ (void) changeHeight:(UIView *)view height:(int)height;
+ (void) doubleSize:(UIView *)view;
+ (int) textHeight:(UILabel *)lbl;
+ (void)moveUpperRight:(UIView *)view;
+ (void)centerHorizontal:(UIView *)view;

//filesystem and image handling
+ (BOOL)fileExistsInProject:(NSString *)fileName;
+ (NSString *) getDocumentsDirectory;
+ (BOOL) fileExistsInDocs:(NSString *)fileName;
+ (UIImage *)getImage:(NSString *)imageName;
+ (NSString *)getImageFileName:(NSString *)itemName;
+ (NSData *)compressImage:(UIImage *)image;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (NSString *)encodeFile:(NSString *)fileName;
+ (NSString *)encodeImage:(UIImage *)image;
+ (NSString *)base64Encoding:(NSData *)data;
+ (BOOL)hasBackgroundImage:(NSObject *)viewController;
+ (UIImage *)getBackgroundImage:(NSObject *)viewController;

//date functions
+ (NSString *) displayDate:(NSDate *)date;
+ (NSString *) displayLongDate:(NSDate *)date;
+ (NSString *) displayTime:(NSDate *)date;
+ (NSString *) displayDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *) displaySystemDate;
+ (NSString *) displaySystemDate:(NSString *)format;
+ (NSDate *) dateFromString:(NSString *)date;
+ (NSDate *) dateTimeFromString:(NSString *)dateTime;
+ (NSDate *) nextHour;
+ (NSDate *) noSeconds:(NSDate *)date;
+ (NSString *) paddedTimeComponent:(int)component;
+ (NSString *) timestamp;
+ (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;
+ (NSDate *)startOfDay:(NSDate *)date;
+ (NSDate *)endOfDay:(NSDate *)date;
+ (NSDate *)endOfMonth:(NSDate *)date;
+ (BOOL)isToday:(NSDate *)date;
+ (NSString *)timeUntil:(NSDate *)date;

//device functions
+ (BOOL)isIphone5;
+ (BOOL)isIos8;
+ (BOOL)isIpad;
+ (BOOL)isCameraAvailable;
+ (int)screenWidth;
+ (int)screenHeight;
+ (CGRect)screenBoundsForOrientation;
+ (int)screenWidthForOrientation;
+ (int)screenHeightForOrientation;
+ (int)statusBarHeight;

//contact options
+ (void)contactFacebook:(NSString *)facebookName;
+ (void)contactTwitter:(NSString *)twitterHandle;
+ (void)contactEmail:(NSString *)emailAddress;
+ (void)contactPhone:(NSString *)phoneNumber;

@end
