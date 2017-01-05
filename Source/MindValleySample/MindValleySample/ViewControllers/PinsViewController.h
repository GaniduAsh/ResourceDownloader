//
//  PDKPinsViewController.h
//  PinterestSDK
//
//  Created by Ricky Cancro on 3/11/15.
//  Copyright (c) 2015 ricky cancro. All rights reserved.
//

@import UIKit;

#import "PDKClient.h"

@class PDKBoard;

typedef void (^PinsViewControllerLoadBlock)(PDKClientSuccess succes, PDKClientFailure failure);

@interface PinsViewController : UIViewController

@property (nonatomic, copy) PinsViewControllerLoadBlock dataLoadingBlock;

- (instancetype)initWithBoard:(PDKBoard *)board;
@end
