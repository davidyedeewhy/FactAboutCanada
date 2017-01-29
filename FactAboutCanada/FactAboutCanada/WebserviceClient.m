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

#pragma mark - request json objects
- (void)requestWithConnection:(NSString *)connection
           completionHandler:(void (^)(NSDictionary *))completionHandler{
    NSURL * url = [NSURL URLWithString:connection];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
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

#pragma mark - request image for object
- (void)requestImageWithObject:(id)object{
    if([object isMemberOfClass:[Fact class]]){
        Fact * fact = (Fact *)object;
        if (fact.imageHref){
            NSURL * url = [NSURL URLWithString:fact.imageHref];
            NSURLRequest * request = [NSURLRequest requestWithURL:url
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                  timeoutInterval:30];
            
            NSURLSessionTask * task = [[NSURLSession sharedSession] downloadTaskWithRequest:request
                                                                          completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                                              // 1. check if response has error
                                                                              if(response && !error){
                                                                                  NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
                                                                                  if(httpResponse.statusCode == 200){
                                                                                      if(location){
                                                                                          // 2. set object's image
                                                                                          fact.imageData = [[NSData alloc]initWithContentsOfURL:location];
                                                                                      }
                                                                                  }
                                                                              }
                                                                          }];
            
            [task resume];
        }
    }
}
@end
