//
//  UIColor+CreateMethods.m
//
//  Created by Tomasz Rybakiewicz on 1/13/12.
//
// http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background

#import "UIColor+CreateMethods.h"

@implementation UIColor (CreateMethods)

+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
    
    assert(7 == [hex length]);
    assert('#' == [hex characterAtIndex:0]);
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
}

+ (UIColor *)colorWithName:(NSString *)name {
    if ([name isEqualToString:@"Black"])
        return [UIColor blackColor];
    else if ([name isEqualToString:@"DarkGray"] || [name isEqualToString:@"Dark Gray"])
        return [UIColor darkGrayColor];
    else if ([name isEqualToString:@"LightGray"] || [name isEqualToString:@"Light Gray"])
        return [UIColor lightGrayColor];
    else if ([name isEqualToString:@"White"])
        return [UIColor whiteColor];
    else if ([name isEqualToString:@"Gray"])
        return [UIColor grayColor];
    else if ([name isEqualToString:@"Red"])
        return [UIColor redColor];
    else if ([name isEqualToString:@"Green"])
        return [UIColor greenColor];
    else if ([name isEqualToString:@"Blue"])
        return [UIColor blueColor];
    else if ([name isEqualToString:@"Cyan"])
        return [UIColor cyanColor];
    else if ([name isEqualToString:@"Yellow"])
        return [UIColor yellowColor];
    else if ([name isEqualToString:@"Magenta"])
        return [UIColor magentaColor];
    else if ([name isEqualToString:@"Orange"])
        return [UIColor orangeColor];
    else if ([name isEqualToString:@"Purple"])
        return [UIColor purpleColor];
    else if ([name isEqualToString:@"Brown"])
        return [UIColor brownColor];
    else if ([name isEqualToString:@"Clear"])
        return [UIColor clearColor];
    else
        return [UIColor blackColor];
}

@end
