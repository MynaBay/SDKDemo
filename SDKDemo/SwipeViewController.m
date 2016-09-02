//
//  SwipeViewController.m
//  SDKDemo
//
//  Created by Kevin Snow on 8/31/16.
//  Copyright © 2016 Lilitab LLC. All rights reserved.
//

#import "SwipeViewController.h"
#import "LilitabSDK/LilitabSDK.h"

@implementation SwipeViewController

- (IBAction)toggleButtonPressed:(id)sender {
    
    if( [LilitabSDK singleton].ledState == LED_On )
    {
        [LilitabSDK singleton].ledState = LED_Off;
    }else{
        [LilitabSDK singleton].ledState = LED_On;
    }
    
}

- (IBAction)statusButtonPressed:(id)sender {
    
    [[LilitabSDK singleton] status:^(BOOL success, NSDictionary *results) {
        if(success)
        {
            self.textView.text = results.description;
        }else{
            self.textView.text = @"Failed";
        }
    }];
}


-(void) lilitabConnected:(NSNotification*)notification
{
    self.toggleButton.enabled = YES;
    self.statusButton.enabled = YES;
    
    [LilitabSDK singleton].swipeBlock = ^(NSDictionary* swipeData)
                                {
                                    self.textView.text = swipeData.description;
                                };
    
    [LilitabSDK singleton].swipeTimeout = 0;
    [LilitabSDK singleton].enableSwipe = YES;
    
    [LilitabSDK singleton].allowMultipleSwipes = YES;
}

-(void) lilitabDisconnected:(NSNotification*)notification
{
    self.toggleButton.enabled = NO;
    self.statusButton.enabled = NO;
    
    self.textView.text = @"accessory disconnected";
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lilitabConnected:) name:LilitabSDK_DidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lilitabDisconnected:) name:LilitabSDK_DidDisconnectNotification object:nil];
    
    [[LilitabSDK singleton] scanForConnectedAccessories];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.toggleButton.enabled = NO;
    self.statusButton.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
