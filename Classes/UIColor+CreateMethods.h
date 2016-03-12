//
//  UIColor+CreateMethods.h
//
//  Created by Tomasz Rybakiewicz on 1/13/12.
//
// http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background

#import <UIKit/UIKit.h>

@interface UIColor (CreateMethods)

// wrapper for [UIColor colorWithRed:green:blue:alpha:]
// values must be in range 0 - 255
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

// Creates color using hex representation
// hex - must be in format: #FF00CC 
// alpha - must be in range 0.0 - 1.0
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithName:(NSString *)name;

@end
