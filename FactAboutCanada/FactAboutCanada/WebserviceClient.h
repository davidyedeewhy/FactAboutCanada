//
//  WebserviceClient.h
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebserviceClient : NSObject

// request json objects with the connection and handle the json objects in block
- (void)requestWithConnection : (NSString *)connection
            completionHandler:(void (^)(NSDictionary * result))completionHandler;

// request image for object with image url
- (void)requestImageWithObject : (id)object;

@end
