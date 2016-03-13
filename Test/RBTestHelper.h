//
//  RBTestHelper.h
//  radbear-ios
//
//  Created by Gary Foster on 2/18/14.
//  Copyright (c) 2014 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTTPServer.h>

@interface RBTestHelper : NSObject

+ (HTTPServer *)startServer:(BOOL)withPhoto testMethodName:(NSString *)testMethodName;

@end
