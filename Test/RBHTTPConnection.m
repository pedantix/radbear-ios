//
//  MyHTTPConnection.m
//  radbear-ios
//
//  Created by Gary Foster on 2/7/14.
//  Copyright (c) 2014 Automotive Broadcasting Network. All rights reserved.
//

#import "RBHTTPConnection.h"
#import "RBFileResponse.h"
#import "HTTPLogging.h"
#import "HTTPMessage.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;

@implementation RBHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSString *pathPart = [[self relativePath:path] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *fileName = [[[method lowercaseString] stringByAppendingString:pathPart] stringByAppendingString:@".json"];
    NSString *fullFilePath = [[[config documentRoot] stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullFilePath])
        return [[RBFileResponse alloc] initWithFilePath:fullFilePath forConnection:self];
    else {
        NSException *exception = [NSException exceptionWithName:@"FileNotFoundException" reason:[@"File not found on system: " stringByAppendingString:fullFilePath] userInfo:nil];
        
        @throw exception;
    }
}

- (NSString *)relativePath:(NSString *)path {
    NSString *filePath = [self filePathForURI:path];
    NSString *documentRoot = [config documentRoot];
    
    if ([filePath hasPrefix:documentRoot]) {
        return [filePath substringFromIndex:[documentRoot length]];
    } else {
        // HTTPConnection's filePathForURI was supposed to take care of this for us.
        return nil;
    }
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    HTTPLogTrace();
    
    return TRUE;
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path {
    HTTPLogTrace();
    
    if([method isEqualToString:@"POST"])
        return YES;
    
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength {
    HTTPLogTrace();
}

- (void)processBodyData:(NSData *)postDataChunk {
    HTTPLogTrace();
    
    BOOL result = [request appendData:postDataChunk];
    if (!result) {
        HTTPLogError(@"%@[%p]: %@ - Couldn't append bytes!", THIS_FILE, self, THIS_METHOD);
    }
}

@end