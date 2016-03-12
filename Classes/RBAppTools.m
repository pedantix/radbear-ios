//
//  RBAppTools.m
//  radbear-ios
//
//  Created by Gary Foster on 10/9/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBAppTools.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const float CONST_IconSize = 30.0f;

@implementation RBAppTools

+(void) msgBox:(NSString *)message withTitle:(NSString *)title {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
}

+(void) msgSuccess:(NSString *)message {
	[RBAppTools msgBox:message withTitle:@"Success"];
}

+(void) msgInfo:(NSString *)message {
	[RBAppTools msgBox:message withTitle:@"Info"];
}

+(NSString *) camelCaseToWords:(NSString *)input {
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@" %@", [NSString stringWithCharacters:&c length:1]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

+ (NSString *) camelCaseToUnderscore:(NSString*)input {
    NSScanner *scanner = [NSScanner scannerWithString:input];
    scanner.caseSensitive = YES;
    
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *lowercase = [NSCharacterSet lowercaseLetterCharacterSet];
    
    NSString *buffer = nil;
    NSMutableString *output = [NSMutableString string];
    
    while (scanner.isAtEnd == NO) {
        
        if ([scanner scanCharactersFromSet:uppercase intoString:&buffer]) {
            [output appendString:[buffer lowercaseString]];
        }
        
        if ([scanner scanCharactersFromSet:lowercase intoString:&buffer]) {
            [output appendString:buffer];
            if (!scanner.isAtEnd)
                [output appendString:@"_"];
        }
    }
    return [NSString stringWithString:output];
}

+ (NSString *) dashToCamelCase:(NSString *)input {
    NSArray *words = [input componentsSeparatedByString: @"-"];
    NSMutableArray *formattedWords = [[NSMutableArray alloc]initWithCapacity:words.count];
    
    int index = 0;
    for (NSString *word in words) {
        if (index == 0)
            [formattedWords addObject:[word lowercaseString]];
        else
            [formattedWords addObject:[word capitalizedString]];
        
        index ++;
    }
    
    return [formattedWords componentsJoinedByString:@""];
}

+ (NSString *)underscoreToWords:(NSString *)input {
    NSArray *words = [input componentsSeparatedByString: @"_"];
    NSMutableArray *formattedWords = [[NSMutableArray alloc]initWithCapacity:words.count];
    
    for (NSString *word in words) {
        [formattedWords addObject:[word capitalizedString]];
    }
    
    return [formattedWords componentsJoinedByString:@" "];
}

+(NSString *) getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

+(BOOL)fileExistsInProject:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileInResourcesFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return [fileManager fileExistsAtPath:fileInResourcesFolder];
}

+(BOOL)fileExistsInDocs:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsPath = [[self getDocumentsDirectory] stringByAppendingPathComponent:fileName];
	
    return [fileManager fileExistsAtPath:docsPath];
}

+(UIImage *)getImage:(NSString *)imageName {
	UIImage *img;
	NSString *imageFileName = [RBAppTools getImageFileName:imageName];
	
	if([self fileExistsInDocs:imageFileName]) {
		NSString *docsPath = [[self getDocumentsDirectory] stringByAppendingPathComponent:imageFileName];
		
		img = [UIImage imageWithContentsOfFile:docsPath];
	}
	else {
		img = [UIImage imageNamed:imageFileName];
	}
	
	return img;
}

+(NSString *)getImageFileName:(NSString *)itemName {
	NSString *fileName = [[itemName stringByAppendingString:@".jpg"] lowercaseString];
	fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
	return fileName;
}

+(NSData *)compressImage:(UIImage *)image {
	UIImage *imageCopy = [self scaleAndRotateImage:image];
	NSData *testImageSize = [NSData dataWithData:UIImageJPEGRepresentation(imageCopy, 1)];
	
	CGFloat compression;
	if([testImageSize length] <= 400000)
		compression = 1;
	else
		compression = .2;
	
	return [NSData dataWithData:UIImageJPEGRepresentation(imageCopy, compression)];
}

+(void)moveUp:(UIView *)view distance:(int)distance {
    CGRect frame = view.frame;
    int y = frame.origin.y - distance;
    
    CGRect newFrame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    view.frame = newFrame;
}

+(void)moveDown:(UIView *)view distance:(int)distance {
    CGRect frame = view.frame;
    int y = frame.origin.y + distance;
    
    CGRect newFrame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    view.frame = newFrame;
}

+ (void)changeVerticalPosition:(UIView *)view position:(int)position {
    CGRect frame = view.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, position, frame.size.width, frame.size.height);
    view.frame = newFrame;
}

+ (void)changeHorizontalPosition:(UIView *)view position:(int)position {
    CGRect frame = view.frame;
    CGRect newFrame = CGRectMake(position, frame.origin.y, frame.size.width, frame.size.height);
    view.frame = newFrame;
}

+(void)changeWidth:(UIView *)view width:(int)width {
    CGRect frame = view.frame;
    
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    view.frame = newFrame;
}

+(void)changeHeight:(UIView *)view height:(int)height {
    CGRect frame = view.frame;
    
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    view.frame = newFrame;
}

+(void)doubleSize:(UIView *)view {
    CGRect frame = view.frame;
    
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * 2, frame.size.height * 2);
    view.frame = newFrame;
}

+ (void)moveUpperRight:(UIView *)view {
    view.frame = CGRectMake([RBAppTools screenWidthForOrientation] - view.frame.size.width - 20, 20, view.frame.size.width, view.frame.size.height);
}

+ (void)centerHorizontal:(UIView *)view {
    view.frame = CGRectMake(([RBAppTools screenWidthForOrientation] - view.frame.size.width) / 2, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

+(int)textHeight:(UILabel *)lbl {
    UIFont *font = lbl.font;
    CGSize max = CGSizeMake(lbl.frame.size.width, lbl.frame.size.height);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:lbl.text attributes:@ {NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return ceil(rect.size.height);
}

+(UIColor *)greenColor {
    CGFloat nRed=65.0/255.0;
    CGFloat nBlue=171.0/255.0;
    CGFloat nGreen=76.0/255.0;
    
    return [[UIColor alloc]initWithRed:nRed green:nBlue blue:nGreen alpha:1];
}

+(UIColor *)tintColorDefault {
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

+(NSString *)getOrdinalNumber:(int)number {
    //todo expand this to handle all numbers
    switch(number) {
        case 1:
            return @"1st";
            break;
        case 2:
            return @"2nd";
            break;
        case 3:
            return @"3rd";
            break;
        case 4:
            return @"4th";
            break;
        case 5:
            return @"5th";
            break;
        case 6:
            return @"6th";
            break;
        case 7:
            return @"7th";
            break;
        case 8:
            return @"8th";
            break;
        case 9:
            return @"9th";
            break;
        case 10:
            return @"10th";
            break;
        default:
            return @"0th";
    }
}

+ (NSString *)appName {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    return [info objectForKey:@"CFBundleDisplayName"];
}

+ (UIImage *)getFontAwesomeIcon:(FAKFontAwesome *)icon darkTheme:(BOOL)darkTheme dim:(BOOL)dim {
    UIColor *darkColor = dim ? [UIColor darkGrayColor] : [UIColor blackColor];
    UIColor *lightColor = dim ? [UIColor lightGrayColor] : [UIColor whiteColor];
    
    return [RBAppTools getFontAwesomeIcon:icon color:darkTheme ? lightColor : darkColor];
}

+ (UIImage *)getFontAwesomeIcon:(FAKFontAwesome *)icon {
    return [RBAppTools getFontAwesomeIcon:icon color:nil];
}

+ (UIImage *)getFontAwesomeIcon:(FAKFontAwesome *)icon color:(UIColor *)color {
    int imageSize = icon.iconFontSize;
    [icon setIconFontSize:icon.iconFontSize - 5];
    
    if (color)
        [icon addAttribute:NSForegroundColorAttributeName value:color];
    
    UIImage *image = [icon imageWithSize:CGSizeMake(imageSize, imageSize)];
    return image;
}

+ (UIImage *)getFontAwesomeIcon:(NSString *)iconName color:(UIColor *)color size:(float)size {
    NSMutableDictionary *allIcons = [NSMutableDictionary dictionaryWithDictionary:[FAKFontAwesome allIcons]];
    
    for (NSString *key in [allIcons allKeys]) {
        allIcons[allIcons[key]] = key;
        [allIcons removeObjectForKey:key];
    }
    
    NSString *resultCode = [allIcons objectForKey:iconName];
    
    if (resultCode) {
        FAKFontAwesome *icon = [FAKFontAwesome iconWithCode:resultCode size:size];
        
        if (color)
            [icon addAttribute:NSForegroundColorAttributeName value:color];
        
        return [RBAppTools getFontAwesomeIcon:icon];
    } else {
        NSLog(@"Could not find icon: %@", iconName);
        return nil;
    }
}

+ (UIButton *)getBarButton:(FAKFontAwesome *)icon text:(NSString *)text target:(id)target action:(SEL)action {
    UIImage *img = [RBAppTools getFontAwesomeIcon:icon];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.backgroundColor = [UIColor clearColor];
    [but setImage:img forState:UIControlStateNormal];
    [but setTitle:text forState:UIControlStateNormal];
    but.autoresizesSubviews = YES;
    but.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [but addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return but;
}

+ (UIBarButtonItem *)getBarItem:(UIButton *)but {
    CGSize textSize = [but.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:but.titleLabel.font}];
    CGFloat labelWidth = textSize.width;
    
    UIView *vwBut = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelWidth + CONST_IconSize, CONST_IconSize)];
    but.frame = vwBut.frame;
    [vwBut addSubview:but];
    
    return [[UIBarButtonItem alloc]initWithCustomView:vwBut];
}

+ (NSString *)encodeFile:(NSString *)fileName {
    NSString *filePath = [[RBAppTools getDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
	
	return [RBAppTools base64Encoding:[NSData dataWithData:fileData]];
}

+ (NSString *)encodeImage:(UIImage *)image {
    UIImage *imageCopy = [RBAppTools scaleAndRotateImage:image];
	NSData *fileData = [NSData dataWithData:UIImageJPEGRepresentation(imageCopy, 1)];
	return [RBAppTools base64Encoding:[NSData dataWithData:fileData]];
}

+ (NSString *)base64Encoding:(NSData *)data {
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        // Encode the bytes in the buffer to four characters,
        // including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length
                                        encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

+(BOOL)hasBackgroundImage:(NSObject *)viewController {
    NSString *fileName = [[viewController.class description] stringByAppendingString:@"_background.png"];
    
    if([RBAppTools fileExistsInProject:fileName])
        return TRUE;
    else
        return [RBAppTools fileExistsInProject:@"background.png"];
}

+(UIImage *)getBackgroundImage:(NSObject *)viewController {
    NSString *fileName = [[viewController.class description] stringByAppendingString:@"_background.png"];
    
    if([RBAppTools fileExistsInProject:fileName])
        return [UIImage imageNamed:fileName];
    else if([RBAppTools fileExistsInProject:@"background.png"])
        return [UIImage imageNamed:@"background.png"];
    else
        return nil;
}

+(UIImage *)scaleAndRotateImage:(UIImage *)image {
	// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
	
	int kMaxResolution = 640; // Or whatever
	
    CGImageRef imgRef = image.CGImage;
	
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
	
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
	
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
			
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
			
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
			
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
			
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
    }
	
    UIGraphicsBeginImageContext(bounds.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
	
    CGContextConcatCTM(context, transform);
	
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return imageCopy;
}

//date functions

+(NSString *) displayDate:(NSDate *)date {
	return [self displayDate:date withFormat:@"M/d/yyyy"];
}

+(NSString *) displayLongDate:(NSDate *)date {
	return [self displayDate:date withFormat:@"EEEE, MMMM d, y"];
}

+(NSString *) displayTime:(NSDate *)date {
	return [self displayDate:date withFormat:@"h:mm a"];
}

+(NSString *) displaySystemDate {
	return [self displayDate:[NSDate date]];
}

+(NSString *) displaySystemDate:(NSString *)format {
	return [self displayDate:[NSDate date] withFormat:format];
}

+(NSString *) displayDate:(NSDate *)date withFormat:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	
	NSString *stringDate;
	
	if(date == nil)
		stringDate = @"";
	else
		stringDate = [formatter stringFromDate:date];
	
	return stringDate;
}

+(NSDate *) dateFromString:(NSString *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyyy"];
	
	NSDate *returnDate = [formatter dateFromString:date];
	
	return returnDate;
}

+(NSDate *) dateTimeFromString:(NSString *)dateTime {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *returnDate = [formatter dateFromString:dateTime];
	
	return returnDate;
}

+(NSDate *) nextHour {
    NSDate *now = [NSDate date];
    NSDateComponents *time = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
    int secondsToAdd;
    
    if (time.second != 0 || time.minute != 0)
        secondsToAdd = (int)((60 * (60 - time.minute ) + (60 - time.second)) - 60);
    else
        secondsToAdd = 0;
    
    return [now dateByAddingTimeInterval:secondsToAdd];
}

+(NSDate *) noSeconds:(NSDate *)date {
    NSDateComponents *time = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    return [date dateByAddingTimeInterval:-time.second];
}

+ (NSString *)paddedTimeComponent:(int)component {
    NSString *rawString = [[NSNumber numberWithInt:component] stringValue];
    if (rawString.length < 2)
        return [@"0" stringByAppendingString:rawString];
    else
        return rawString;
}

+ (NSString *) timestamp {
    return [RBAppTools displayDate:[NSDate date] withFormat:@"yyyyMMddHHmmss"];
}

+ (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}

+ (NSDate *)startOfDay:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
	
	return [calendar dateFromComponents:comp];
}

+ (NSDate *)endOfDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
    
    comp.hour = 23;
    comp.minute = 59;
    comp.second = 59;
    
    return [calendar dateFromComponents:comp];
}

+ (NSDate *)endOfMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
    
    comp.hour = 23;
    comp.minute = 59;
    comp.second = 59;
    
    [comp setMonth:[comp month] +1 ];
    [comp setDay:0];
    return [calendar dateFromComponents:comp];
}

+ (BOOL)isToday:(NSDate *)date {
    return [RBAppTools isDate:date inRangeFirstDate:[RBAppTools startOfDay:[NSDate date]] lastDate:[RBAppTools endOfDay:[NSDate date]]];
}

+ (NSString *)timeUntil:(NSDate *)date {
    NSDate *target = [NSDate date];
    
    if ([date compare:target] == NSOrderedDescending) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger components = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *difference = [calendar components:components fromDate:target toDate:date options:0];
        
        return [NSString stringWithFormat:@"%@:%@:%@:%@", [RBAppTools paddedTimeComponent:(int)difference.day], [RBAppTools paddedTimeComponent:(int)difference.hour], [RBAppTools paddedTimeComponent:(int)difference.minute], [RBAppTools paddedTimeComponent:(int)difference.second]];
    } else {
        return @"00:00:00:00";
    }
}

+ (BOOL)isIphone5 {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height < 500)
            return FALSE;  // iPhone 4S / 4th Gen iPod Touch or earlier
        else
            return TRUE;  // iPhone 5
    } else {
        return FALSE; // iPad
    }
}

+ (BOOL)isIos8 {
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    return [currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending;
}

+ (BOOL)isIpad {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return TRUE;
    }
#endif
    
    return  FALSE;
}

+ (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (int)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (int)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGRect)screenBoundsForOrientation {
    if ([RBAppTools isIos8])
        return [UIScreen mainScreen].bounds;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
        NSLog(@"Portrait Height: %f", screenBounds.size.height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
        NSLog(@"Landscape Height: %f", screenBounds.size.height);
    }
    
    return screenBounds ;
}

+ (int)screenWidthForOrientation {
    return [RBAppTools screenBoundsForOrientation].size.width;
}

+ (int)screenHeightForOrientation {
    return [RBAppTools screenBoundsForOrientation].size.height;
}

+ (int)statusBarHeight {
    return 20;
}

//contact options

+ (void)contactFacebook:(NSString *)facebookName {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://facebook.com/" stringByAppendingString:facebookName]]];
}

+ (void)contactTwitter:(NSString *)twitterHandle {
    NSURL *url = [NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:twitterHandle]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://twitter.com/" stringByAppendingString:twitterHandle]]];
}

+ (void)contactEmail:(NSString *)emailAddress {
    NSURL *url = [NSURL URLWithString:[@"mailto://" stringByAppendingString:emailAddress]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
    else
        [RBAppTools msgBox:emailAddress withTitle:@"Email Address"];
}

+ (void)contactPhone:(NSString *)phoneNumber {
    NSString *fixedPhone = [phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])];
    
    NSURL *url = [NSURL URLWithString:[@"tel://" stringByAppendingString:fixedPhone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
    else
        [RBAppTools msgBox:phoneNumber withTitle:@"Phone Number"];
}

@end
