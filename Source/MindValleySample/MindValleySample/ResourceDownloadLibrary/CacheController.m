
//  MindValleySample
//
//  Created by ashen test on 12/23/16.
//  Copyright © 2016 calcey. All rights reserved.

//  Cache controller  - This Class will save cache objects in memory


#import "CacheController.h"

static CacheController *sharedInstance = nil;

@implementation CacheController

@synthesize cache;

+(CacheController *)sharedInstance {
    
    if (sharedInstance == nil) {
        
        sharedInstance = [[CacheController alloc] init];
    }
    
    return sharedInstance;
}

+(void)destroySharedInstance {
    
    sharedInstance = nil;
}

-(id)init {
    
    self = [super init];
    
    if (self)
    {
        
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

-(void)setCache:(id)obj forKey:(NSString *)key
{
    [cache setObject:obj forKey:key];
}


-(id)getCacheForKey:(NSString *)key
{
    return [cache objectForKey:key];
}

- (void) removeCache:(NSString *)key
{
    [cache removeObjectForKey:key];
}


@end
