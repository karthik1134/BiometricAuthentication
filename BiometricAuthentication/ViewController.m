//
//  ViewController.m
//  BiometricAuthentication
//
//  Created by Karthik Chinni on 20/10/17.
//  Copyright © 2017 Karthik Chinni. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

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

-(IBAction)performBioAuthentication:(id)sender{
    
    NSLog(@"FaceID Vs TouchID");
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Test bio authentication";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        if (@available(iOS 11.0, *)) {
            if (myContext.biometryType == LABiometryTypeFaceID) {
                NSLog(@"FaceId supported");
                myLocalizedReasonString = @"Authenticate using face";
            } else if (myContext.biometryType == LABiometryTypeTouchID) {
                NSLog(@"TouchId supported");
                myLocalizedReasonString = @"Authenticate using finger";
            } else {
                NSLog(@"No Biometric support");
            }
        } else {
            // Fallback on earlier versions
            myLocalizedReasonString = @"Authenticate using finger";
        }
        
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action
                                    if (@available(iOS 11.0, *)) {
                                        NSLog(@"%ld Verification Success", (long)myContext.biometryType);
                                    } else {
                                        // Fallback on earlier versions
                                        NSLog(@"Biometric Verification Success");
                                    }
                                } else {
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            NSLog(@"Authentication Failed");
                                            break;
                                            
                                        case LAErrorUserCancel:
                                            NSLog(@"User pressed Cancel button");
                                            break;
                                            
                                        case LAErrorUserFallback:
                                            NSLog(@"User pressed \"Enter Password\"");
                                            break;
                                        default:
                                            NSLog(@"Touch ID is not configured");
                                            break;
                                    }
                                    NSLog(@"Authentication Fails");
                                }
                            }];
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        NSLog(@"Can not evaluate Touch ID or Face ID");
    }
}


@end
