//
//  XTSignInService.h
//  ReactiveCocoaDemo
//
//  Created by xiaotei's on 16/3/29.
//  Copyright © 2016年 xiaotei's. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XTSignInResponse)(BOOL status);

@interface XTSignInService : NSObject

+ (void)signInWithUserName:(NSString*)userName passWord:(NSString*)password complete:(XTSignInResponse)completeBlock;

@end
