//
//  NSString+Extension.h
//  BaBaSuPei
//
//  Created by FengXingTianXia on 14-12-2.
//  Copyright (c) 2014年 BJFXTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  <#Description#>
 *
 *  @param string  <#string description#>
 *  @param font    <#font description#>
 *  @param maxSize <#maxSize description#>
 *
 *  @return <#return value description#>
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)sizeWithfont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  替换字符
 *
 *  @param curString   需要转换的字符串
 *  @param frontLength 不需要转换的头部的字符串长度
 *  @param endLength   不需要转换的尾部的字符串长度
 *  @param character   中间需要替换成的字符
 *
 *  @return 替换后的新新字符串
 */
+ (NSString *)replaceMiddleStringWithCurrentString:(NSString *)curString frontLength:(NSUInteger)frontLength endLength:(NSUInteger)endLength character:(NSString *)character;
- (NSString *)replaceMiddleStringWithCurrentString:(NSString *)curString frontLength:(NSUInteger)frontLength endLength:(NSUInteger)endLength character:(NSString *)character;

/**
 *  删除指定字符串
 *
 *  @param CityNameString 传入城市名称
 *
 *  @return 返回删除后正常的名称
 */
+ (NSString *)DeleteStringFromeCityNameString:(NSMutableString *)CityNameString;


/**
 *  判断是否为手机号
 *
 *  @param mobile <#mobile description#>
 *
 *  @return 返回BOOL 值
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**
 *  判断是否为邮箱
 *
 *  @param email 传入的邮箱字符串
 *
 *  @return 返回是否
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  字母格式验证
 *
 *  @param identityCard <#identityCard description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isZimu:(NSString *)str;

/**
 *  身份证格式验证
 *
 *  @param identityCard <#identityCard description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
- (NSString *)trimSpace ;

- (BOOL)isValidNumber ;



@end
