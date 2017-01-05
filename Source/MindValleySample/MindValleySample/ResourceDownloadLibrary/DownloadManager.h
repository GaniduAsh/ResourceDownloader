
//  DownloadManager.h
//  MindValleySample
//
//  Created by ashen test on 12/23/16.
//  Copyright © 2016 calcey. All rights reserved.
//
//  Single instance download manager to execute any type of resource manager


#import <Foundation/Foundation.h>
#import "CacheController.h"

@interface DownloadManager : NSObject
{
    CacheController *cacheController; // cache controller class is to save caceh object in memory
    
    NSMutableArray *cacheStack;  // keep all the cache data in keys .
}

+(DownloadManager *) getSharedInstance;  //create singleton download manager


// Request execute methods
- (void) executeGetRequest :(NSString *)URLString
                 parameters:(id)parameters
            completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock; //GET

- (void) executePostRequest :(NSString *)URLString
                  parameters:(id)parameters
             completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock;//POST

- (void) executePutRequest :(NSString *)URLString
                 parameters:(id)parameters
            completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock;//PUT

- (void) executeDeleteRequest :(NSString *)URLString
                    parameters:(id)parameters
               completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock;//DELETE

- (void) setHeader :(NSMutableDictionary *) header;

@end
