//
//  NSString+MessageDigest.h
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/13.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MessageDigest)
- (NSString *)md2;

- (NSString *)md4;

- (NSString *)md5;

- (NSString *)sha1;

- (NSString *)sha224;

- (NSString *)sha256;

- (NSString *)sha384;

- (NSString *)sha512;
@end
