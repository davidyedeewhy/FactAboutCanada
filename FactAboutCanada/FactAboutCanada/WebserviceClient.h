//
//  WebserviceClient.h
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebserviceClient : NSObject

-(void)requestWithConnection : (NSString *)connection
            completionHandler:(void (^)(NSDictionary * result))completionHandler;

@end
