//  MindValleySample
//
//  Created by ashen test on 12/23/16.
//  Copyright © 2016 calcey. All rights reserved.

//  Cache controller  - this is create cache in memory

#import <Foundation/Foundation.h>

@interface CacheController : NSObject {
    
    NSCache *cache;
}

@property (retain, nonatomic) NSCache *cache;

+ (CacheController *) sharedInstance;  // Get single instance cache instance

+ (void) destroySharedInstance;        // Destroy cache memory

- (void) setCache:(id)obj forKey:(NSString *)key;  // Set cache by id

- (id) getCacheForKey:(NSString *)key; // Get cache object by key

- (void) removeCache:(NSString *)key; // Remove cached object from memory


@end
