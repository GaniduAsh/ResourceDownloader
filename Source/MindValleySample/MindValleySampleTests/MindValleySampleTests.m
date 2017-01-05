//
//  MindValleySampleTests.m
//  MindValleySampleTests
//
//  Created by ashen test on 12/23/16.
//  Copyright © 2016 calcey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DownloadManager.h"

@interface MindValleySampleTests : XCTestCase
{
    DownloadManager *manager;
}

@end

@implementation MindValleySampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    manager = [DownloadManager getSharedInstance];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark TestCases DownloadManager

- (void) testExecuteGetRequest
{
    //download expected result first
    __block  NSData *expectedImage;
    
    NSURL *imgURL = [NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/originals/de/92/74/de927444ad0c05a4d78e0f6bd2f35a27.jpg"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            expectedImage = data;
        }
    }];
    
    __block  NSData *downloadedResult;
    // Test GET request with following URL
    NSString *urlString = @"https://s-media-cache-ak0.pinimg.com/originals/de/92/74/de927444ad0c05a4d78e0f6bd2f35a27.jpg";
    [manager executeGetRequest:urlString parameters:nil completionBlock:^(BOOL succeeded, NSData *data) {
        downloadedResult = data;
        [self performTest:expectedImage expected:downloadedResult];
    }];
}

-(void) performTest : (NSData *) actual expected : (NSData *) expected
{
    XCTAssertEqualObjects(actual, expected);
}


-(void) testExecutePostRequest
{
    //expected output
    __block NSString *expected = @"Mindvaley";
    
    
    //generate headers
    [manager setHeader:[self generateHeaderDataForPostRequest]];
    
    // Execute sample post request to test functionality
    [manager executePostRequest:@"http://localhost:8081" parameters:[self generateParametersForRequest] completionBlock:^(BOOL succeeded, NSData *data) {
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if(responseString && responseString.length) {
            NSDictionary  * returnDict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options: NSJSONReadingMutableContainers
                                                                           error: nil];
            
            NSString * value  = [[returnDict objectForKey:@"Name"] stringValue];
            
            XCTAssertEqualObjects(expected, value);
        }
    }];
    
}

-(NSMutableDictionary *) generateHeaderDataForPostRequest
{
    NSMutableDictionary *headerValues = [[NSMutableDictionary alloc] init];
    [headerValues setObject:@"application/json"  forKey:@"Content-Type"];
    
    return headerValues;
}

-(NSMutableDictionary *) generateParametersForRequest
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"Mindvaley"  forKey:@"Name"];
    
    return parameters;
}

@end
