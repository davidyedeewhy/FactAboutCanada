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

// initalize object with dictionary
- (instancetype)initWithDictionary : (NSDictionary *)dictionary;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * imageHref;
@property (nonatomic, copy) NSData * imageData;

// update identical(title) object with dictionary
- (void)updateWithDictionary : (NSDictionary *)dictionary;

@end
