//
//  WebserviceClient.m
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import "WebserviceClient.h"

@implementation WebserviceClient

-(void)requestWithConnection:(NSString *)connection completionHandler:(void (^)(NSDictionary *))completionHandler{
    NSURL * url = [NSURL URLWithString:connection];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError * jsonError;
        NSString * resultString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        NSData * encodingData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:encodingData options:NSJSONReadingMutableLeaves error:&jsonError];
        completionHandler(dictionary);
    }] resume];
}

-(void)requestImageWithConnection:(NSString *)connection completionHandler:(void (^)(NSData *))completionHandler{
    NSURL * url = [NSURL URLWithString:connection];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(response && !error){
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200){
                if(location){
                    completionHandler([[NSData alloc]initWithContentsOfURL:location]);
                }
            }
        }
    }] resume];
}

@end
