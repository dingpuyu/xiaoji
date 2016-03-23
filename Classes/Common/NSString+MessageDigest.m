//
//  NSString+MessageDigest.m
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/13.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

#import "NSString+MessageDigest.h"
#import <CommonCrypto/CommonCrypto.h>

typedef unsigned char *(*MessageDigestFuncPtr)(const void *data, CC_LONG len, unsigned char *md);

static NSString *_getMessageDigest(NSString *string, MessageDigestFuncPtr fp, NSUInteger length)

{
    
    const char *cString = [string UTF8String];
    
    unsigned char *digest = malloc(sizeof(unsigned char) * length);
    
    fp(cString, (CC_LONG)strlen(cString), digest);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:length * 2];
    
    for (int i = 0; i < length; ++i) {
        
        [hash appendFormat:@"%02x", digest[i]];
        
    }
    
    free(digest);
    
    return [hash lowercaseString];
    
}

@implementation NSString (MessageDigest)

- (NSString *)md2

{
    
    return _getMessageDigest(self, CC_MD2, CC_MD2_DIGEST_LENGTH);
    
}

- (NSString *)md4

{
    
    return _getMessageDigest(self, CC_MD4, CC_MD4_DIGEST_LENGTH);
    
}

- (NSString *)md5

{
    
    return _getMessageDigest(self, CC_MD5, CC_MD5_DIGEST_LENGTH);
    
}

- (NSString *)sha1

{
    
    return _getMessageDigest(self, CC_SHA1, CC_SHA1_DIGEST_LENGTH);
    
}

- (NSString *)sha224

{
    
    return _getMessageDigest(self, CC_SHA224, CC_SHA224_DIGEST_LENGTH);
    
}

- (NSString *)sha256

{
    
    return _getMessageDigest(self, CC_SHA256, CC_SHA256_DIGEST_LENGTH);
    
}

- (NSString *)sha384

{
    
    return _getMessageDigest(self, CC_SHA384, CC_SHA384_DIGEST_LENGTH);
    
}

- (NSString *)sha512

{
    
    return _getMessageDigest(self, CC_SHA256, CC_SHA256_DIGEST_LENGTH);
    
}

@end
