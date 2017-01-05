//
//  ViewController.m
//  MindValleySample
//
//  Created by ashen test on 12/23/16.
//  Copyright © 2016 calcey. All rights reserved.
//

#import "ViewController.h"
#import "PDKClient.h"
#import "PDKPin.h"
#import "PDKResponseObject.h"
#import "PDKUser.h"
#import "PinsViewController.h"

@interface ViewController ()


@property (nonatomic, strong) PDKUser *user;

// UI outlets
@property (weak, nonatomic) IBOutlet UIButton *pinsButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateButtonEnabledState
{
    self.pinsButton.enabled  = [PDKClient sharedInstance].authorized;
}


#pragma mark Button actions

- (IBAction)authenticateUser:(id)sender
{
    // authenticate pinterset user
    __weak ViewController *weakSelf = self;
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions,
                                                              PDKClientWritePublicPermissions,
                                                              PDKClientReadRelationshipsPermissions,
                                                              PDKClientWriteRelationshipsPermissions]
                                         fromViewController:self
                                                withSuccess:^(PDKResponseObject *responseObject)
     {
         weakSelf.user = [responseObject user];
         weakSelf.resultLabel.text = [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user.firstName];
         [weakSelf updateButtonEnabledState];
     } andFailure:^(NSError *error) {
         weakSelf.resultLabel.text = @"authentication failed";
     }];
    
}

- (IBAction)viewPins:(id)sender
{
    // navigate to pins view controller with data load call back
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PinsViewController *pinsVC = (PinsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PinsViewController"];
    pinsVC.dataLoadingBlock = ^(PDKClientSuccess succes, PDKClientFailure failure) {
        [[PDKClient sharedInstance] getAuthenticatedUserPinsWithFields:[NSSet setWithArray:@[@"id", @"image", @"note"]] success:succes andFailure:failure];
    };
    pinsVC.navigationItem.title = NSLocalizedString(@"Pins", nil);
    [self.navigationController pushViewController:pinsVC animated:YES];
}



@end
