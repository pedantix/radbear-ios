//
//  RBTestHelper.m
//  radbear-ios
//
//  Created by Gary Foster on 2/18/14.
//  Copyright (c) 2014 Radical Bear LLC. All rights reserved.
//

#import "RBTestHelper.h"
#import "RBHTTPConnection.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation RBTestHelper

+ (HTTPServer *)startServer:(BOOL)withPhoto testMethodName:(NSString *)testMethodName {
    if (withPhoto)
        [RBTestHelper addPhotoToSimulator];
    
    HTTPServer *httpServer = [[HTTPServer alloc] init];
    
    [httpServer setConnectionClass:[RBHTTPConnection class]];
    [httpServer setType:@"_http._tcp."];
    [httpServer setPort:12345];
    
    NSString *webPath = [[[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"Web"] stringByAppendingPathComponent:testMethodName];
    [httpServer setDocumentRoot:webPath];
    
    NSError *error  = nil;
    if([httpServer start:&error]) {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    } else {
        NSLog(@"Error starting HTTP Server: %@", error);
        //todo abort
    }

    return httpServer;
}

+ (void)addPhotoToSimulator {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block BOOL anyPhotos = FALSE;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            if (alAsset) {
                anyPhotos = TRUE;
            } else {
                if (!anyPhotos) {
                    UIImage *image = [UIImage imageNamed:@"document.png"];
                    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
                }
            }
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"Error detecting photos, no groups");
    }];
}

@end