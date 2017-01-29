//
//  Fact.m
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import "Fact.h"

@implementation Fact

#pragma mark - init object with dictionary
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if([dictionary valueForKey:@"title"]){
            self.title = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"title"]];
        }
        
        if([dictionary valueForKey:@"description"] != [NSNull null]){
            self.content = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"description"]];
        }
        
        if([dictionary valueForKey:@"imageHref"] != [NSNull null]){
            self.imageHref = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"imageHref"]];
        }
    }
    return self;
}

#pragma mark - if self has imageHref, request image with imageHref
-(void)requestImage{
    NSURL * url = [NSURL URLWithString:self.imageHref];
    NSURLRequest * request = [NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:30];
    
    NSURLSessionTask * task = [[NSURLSession sharedSession] downloadTaskWithRequest:request
                                                                  completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        // 1. check if response has error
        if(response && !error){
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200){
                if(location){
                    self.image = [[NSData alloc]initWithContentsOfURL:location];
                }
            }
        }
    }];
    
    [task resume];
}

#pragma mark - override NSObject function 'isEqual' to check if object has identical title
-(BOOL)isEqual:(id)object{
    if([object isKindOfClass:[self class]]){
        Fact * obj = (Fact *)object;
        return [obj.title isEqual:self.title];
    }
    return NO;
}

@end
