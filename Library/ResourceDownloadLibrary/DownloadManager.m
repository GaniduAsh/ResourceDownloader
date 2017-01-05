//
//  DownloadManager.m
//  MindValleySample
//
//  Created by ashen test on 12/23/16.
//  Copyright © 2016 calcey. All rights reserved.
//

#import "DownloadManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DownloadManager
{
    NSMutableDictionary *headerData;
}


static int const cacheSize = 10;

static DownloadManager *sharedMyManager;

// init
- (id) init
{
    self = [super init];
    cacheController = [CacheController sharedInstance]; //instantiate cache instace
    cacheStack = [[NSMutableArray alloc] initWithCapacity:cacheSize]; //cache stack with limited size
    return  self;
}

// get  single instance shared instance
+ (DownloadManager *) getSharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(sharedMyManager == nil){
            sharedMyManager = [[self alloc] init];
            
        }
    });
    return sharedMyManager;
}

#pragma mark cache stack  manager

- (void) addObject : (NSString *) key
        cacheObject :(id)cacheObject
{
    if([cacheStack count] == cacheSize)
    {
        //remove from cacehcontroller
        [cacheController removeCache:[cacheStack objectAtIndex:0]];
        
        // remove initially add object
        [cacheStack removeObjectAtIndex:0];
        
    }
    
    //add objectc to the que
    [cacheStack addObject:key];
    [cacheController setCache:cacheObject forKey:key];
}

-(id) getCachedObject : (NSString *) key
{
    int index = 0;
    //loop stack
    for (NSString *value in  cacheStack) {
        
        if([value isEqualToString:key]){
            
            //replace object at stack to replace index of recently used item
            NSString *retrievedKey = [cacheStack objectAtIndex:index];
            [cacheStack removeObjectAtIndex:index];
            [cacheStack addObject:retrievedKey];
            
            //object found in cache stack
            return [cacheController getCacheForKey:key];
        
        }
        
        ++index; //increatement index
    }
    
    return nil;
}

- (void) setHeader :(NSMutableDictionary *) header
{
     headerData = header;
}


#pragma mark Request executer

- (void) executeGetRequest :(NSString *)URLString
                 parameters:(id)parameters
            completionBlock:(void (^)(BOOL succeeded, NSData *image))completionBlock
{
    [self executeDataTask:@"GET" URLString:URLString parameters:parameters heders:headerData completionBlock:completionBlock];
}

- (void) executePostRequest :(NSString *)URLString
                  parameters:(id)parameters
             completionBlock:(void (^)(BOOL succeeded, NSData *image))completionBlock
{
     [self executeDataTask:@"POST" URLString:URLString parameters:parameters heders:headerData completionBlock:completionBlock];
}

- (void) executePutRequest :(NSString *)URLString
                 parameters:(id)parameters
            completionBlock:(void (^)(BOOL succeeded, NSData *image))completionBlock
{
     [self executeDataTask:@"PUT" URLString:URLString parameters:parameters heders:headerData completionBlock:completionBlock];
}

- (void) executeDeleteRequest :(NSString *)URLString
                    parameters:(id)parameters
               completionBlock:(void (^)(BOOL succeeded, NSData *image))completionBlock
{
     [self executeDataTask:@"DELETE" URLString:URLString parameters:parameters heders:headerData completionBlock:completionBlock];
}

- (void) executeDataTask :(NSString *) method
               URLString :(NSString *)URLString
               parameters:(id)parameters
                   heders:(id)headers
          completionBlock:(void (^)(BOOL succeeded, NSData *image))completionBlock

{
    //generate hash key
    NSString *hashKey = [self md5:URLString];
    
    //check whether the generated hash key is alreay available in local cache
    NSData *cachedObject = [self getCachedObject:hashKey];
    
    if(cachedObject != nil)
    {
        //object found in cache .return downloaded resource.
        completionBlock(YES,cachedObject);
        return;
    }
    
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setHTTPMethod:method];
    
    //assign HTTTP reqeust headers and authentication
    if (headers != nil) {
       mutableRequest = [self setHeaderValues:headers :mutableRequest];
    }
    
    //set request params
    if (parameters != nil) {
        mutableRequest = [self setMethodBody:parameters : mutableRequest];
    }
    
    //send async request in to que
    [NSURLConnection sendAsynchronousRequest:mutableRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   //data synced
                                   completionBlock(YES,data);
                                   
                                   //save data in cache
                                   [self addObject:hashKey cacheObject:data];
                                   
                               } else{
                                   //unable to sync data
                                   completionBlock(NO,nil);
                               }
    }];
}

// Set HTTP header values
- (NSMutableURLRequest * ) setHeaderValues : (id) headers : (NSMutableURLRequest *) request
{
    NSDictionary *headerDict = (NSDictionary *) headers;
    
    for (id key in headerDict) {
        
        NSString *value = [headerDict objectForKey:key];
        
        //set param values to request
        [request addValue:value forHTTPHeaderField:key];
    }
    
    return request;
}


// set request parameters
- (NSMutableURLRequest *) setMethodBody  : (id) parameters  : (NSMutableURLRequest *) request
{
    
    NSDictionary *parameterDict = (NSDictionary *) parameters;
    
    NSString *requestData = @"";
    
    for (id key in parameterDict) {
        
        NSString *value = [parameterDict objectForKey:key];
        
        requestData = [requestData stringByAppendingFormat:@"%@=%@",key,value];
        
    }
    
    NSData   *postBody      = [requestData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    
    return request;
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]]; //%02X for capital letters
    return output;
}

@end
