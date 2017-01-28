//
//  Fact.m
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import "Fact.h"

@implementation Fact
@synthesize title;
@synthesize content;
@synthesize imageHref;

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

-(void)requestImage{
    NSURL * url = [NSURL URLWithString:self.imageHref];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(response && !error){
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200){
                if(location){
                    self.image = [[NSData alloc]initWithContentsOfURL:location];
                }
            }
        }
    }] resume];
}

-(BOOL)isEqual:(id)object{
    if([object isKindOfClass:[self class]]){
        Fact * obj = (Fact *)object;
        return [obj.title isEqual:self.title];
    }
    return NO;
}

@end
