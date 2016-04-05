//
//  XTSignInService.m
//  ReactiveCocoaDemo
//
//  Created by xiaotei's on 16/3/29.
//  Copyright © 2016年 xiaotei's. All rights reserved.
//

#import "XTSignInService.h"

@implementation XTSignInService

+ (void)signInWithUserName:(NSString *)userName passWord:(NSString *)password complete:(XTSignInResponse)completeBlock{
    
    BOOL success = NO;
    if ([userName isEqualToString:@"user"] && [password isEqualToString:@"123456"]) {
        success = YES;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completeBlock) {
            completeBlock(success);
        }
    });

}

@end
