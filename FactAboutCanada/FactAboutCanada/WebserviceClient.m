//
//  WebserviceClient.m
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import "WebserviceClient.h"
#import "Fact.h"

@implementation WebserviceClient

-(void)requestWithConnection:(NSString *)connection
           completionHandler:(void (^)(NSDictionary *))completionHandler{
    NSURL * url = [NSURL URLWithString:connection];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        // handle http response
        // 1. check if request has error
        if(!error){
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            // 2. check if status code equals 200
            if(httpResponse.statusCode == 200){
                NSError * jsonError;
                NSString * resultString = [[NSString alloc] initWithData:data
                                                                encoding:NSISOLatin1StringEncoding];
                // 3. serialize json objects
                NSData * encodingData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:encodingData
                                                                            options:NSJSONReadingMutableLeaves error:&jsonError];
                if(!jsonError){
                    // 4. if serialization success, complete json objects
                    completionHandler(dictionary);
                }else{
                    NSLog(@"%@", jsonError);
                }
            }
        }
    }];
    [task resume];
}

@end
