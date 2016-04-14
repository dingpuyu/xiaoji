//
//  NSString+MD5.m
//  xiaoji
//
//  Created by xiaotei's on 16/4/14.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

#import "NSString+MD5.h"
#import<CommonCrypto/CommonDigest.h>
@implementation NSString (md5)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
@end