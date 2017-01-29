//
//  Fact.h
//  FactAboutCanada
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Fact : NSObject

-(id)initWithDictionary : (NSDictionary *)dictionary;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * imageHref;
@property (nonatomic, strong) NSData * image;

-(void)updateFactWithDictionary : (NSDictionary *)dictionary;
-(void)requestImage;

@end
