//
//  RDRequestOperation.h
//  MindValleySample
//
//  Created by ashen test on 12/25/16.
//  Copyright © 2016 calcey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDOperation.h"

@interface RDRequestOperation : RDOperation

- (instancetype)initWithCompletion:(void (^)(BOOL succeeded, NSData *data))completion;

@property (nonatomic , copy) void (^completion)(BOOL succeeded, NSData *data);
@property (nonatomic , copy) NSString *taskName;
@property (nonatomic , copy) NSMutableURLRequest *request;



@end
