//
//  RDRequestOperation.m
//  MindValleySample
//
//  Created by ashen test on 12/25/16.
//  Copyright © 2016 calcey. All rights reserved.
//

#import "RDRequestOperation.h"



@implementation RDRequestOperation

@synthesize taskName,request;

- (instancetype)initWithCompletion:(void (^)(BOOL succeeded, NSData *data))completion
{
    self = [super init];
    
    if (self)
    {
        self.completion = completion;
        self.name = taskName;
    }
    
    return self;
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   //data synced
                                   self.completion(YES,data);
                                   
                               } else{
                                   //unable to sync data
                                   self.completion(NO,nil);
                               }
                           }];

}

#pragma mark - Cancel

- (void)cancel
{
    [super cancel];
    
    [self finish];
}

@end
