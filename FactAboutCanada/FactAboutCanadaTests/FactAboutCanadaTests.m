//
//  FactAboutCanadaTests.m
//  FactAboutCanadaTests
//
//  Created by David Ye on 28/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FactAboutCanadaTests : XCTestCase

@end

@implementation FactAboutCanadaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWebRequest {
    
    NSString * connection = @"https://dl.dropboxusercontent.com/u/746330/facts.json";
    NSURL * url = [NSURL URLWithString:connection];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    XCTestExpectation * expectations = [self expectationWithDescription:@"expectations"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError * jsonError;
        NSString * resultString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        NSData * encodingData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:encodingData options:NSJSONReadingMutableLeaves error:&jsonError];
        NSLog(@"%@", dictionary);
        
        [expectations fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        
    }];
    
}

@end
