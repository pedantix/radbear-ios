//
//  MyHTTPConnection.h
//  radbear-ios
//
//  Created by Gary Foster on 2/7/14.
//  Copyright (c) 2014 Automotive Broadcasting Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"

@interface RBHTTPConnection : HTTPConnection

- (NSString *)relativePath:(NSString *)path;

@end
