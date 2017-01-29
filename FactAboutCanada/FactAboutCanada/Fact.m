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
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
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

#pragma mark - update object's content and imageHref
- (void)updateWithDictionary:(NSDictionary *)dictionary{
    if([dictionary valueForKey:@"description"] != [NSNull null] && ![self.content isEqualToString:[dictionary valueForKey:@"description"]]){
        self.content = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"description"]];
    }
    
    if([dictionary valueForKey:@"imageHref"] != [NSNull null] && ![self.imageHref isEqualToString:[dictionary valueForKey:@"imageHref"]]){
        self.imageHref = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"imageHref"]];
    }
}

#pragma mark - override NSObject function 'isEqual' to check if object has identical title
- (BOOL)isEqual:(id)object{
    if([object isKindOfClass:[self class]]){
        Fact * obj = (Fact *)object;
        return [obj.title isEqual:self.title];
    }
    return NO;
}

@end
