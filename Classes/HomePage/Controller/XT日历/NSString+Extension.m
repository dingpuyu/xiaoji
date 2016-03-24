//
//  NSString+Extension.m
//  BaBaSuPei
//
//  Created by FengXingTianXia on 14-12-2.
//  Copyright (c) 2014年 BJFXTX. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    CGSize size;
    NSDictionary *dict = @{NSFontAttributeName:font};
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        size = [string boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }else{
        size =[string sizeWithFont:font constrainedToSize:maxSize];
    }
    return  size;
}

- (CGSize)sizeWithfont:(UIFont *)font maxSize:(CGSize)maxSize
{
    CGSize size;
    NSDictionary *dict = @{NSFontAttributeName:font};
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        size = [self boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }else{
        size =[self sizeWithFont:font constrainedToSize:maxSize];
    }
    return  size;
}


- (NSString *)replaceMiddleStringWithCurrentString:(NSString *)curString frontLength:(NSUInteger)frontLength endLength:(NSUInteger)endLength character:(NSString *)character
{
    if (curString.length > 0) {
        NSUInteger stringLength = curString.length;
        // 从开始位置截取到指定位置但是不包含指定位置的字符串
        NSString *frontString = [curString substringToIndex:frontLength];
        // 从指定的字符串开始到尾部的字符串
        NSString *endString = [curString substringFromIndex:(stringLength-endLength)];
        NSMutableString *replaceString = [NSMutableString string];
        NSInteger count = stringLength-frontLength - endLength;
        if (count > 0) {
            for (NSUInteger i = 0; i < count; i++) {
                [replaceString appendString:character];
            }
            NSString *newString = [NSString stringWithFormat:@"%@%@%@",frontString,replaceString,endString];
            
            return newString;
        }else{
            return curString;
        }
        if (stringLength > (frontLength+endLength)) {
            for (int i = 0; i < (stringLength-(frontLength+endLength)); i++) {
                [replaceString appendString:character];
                }
            }
        }
    return curString;
}

+ (NSString *)replaceMiddleStringWithCurrentString:(NSString *)curString frontLength:(NSUInteger)frontLength endLength:(NSUInteger)endLength character:(NSString *)character
{
    NSString * newString = [curString replaceMiddleStringWithCurrentString:curString frontLength:frontLength endLength:endLength character:character];
    return newString;
}


+(NSString *)DeleteStringFromeCityNameString:(NSMutableString *)CityNameString;
{
    
    NSMutableString *str = [NSMutableString stringWithString:CityNameString];
    NSArray *array = @[@"省",@"市",@"区",@"县"];
    NSRange range;
    for (NSString *rangString in array) {
        
        range = [str rangeOfString:rangString];
        while (range.location!= NSNotFound)
        {
            [str deleteCharactersInRange:range];
            range = [str rangeOfString:rangString];
        }
    }
    
    return [NSString stringWithString:str];
    
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    // 手机号以13，15，18，147开头，八个 \d 数字字符
    NSString *phoneRegex    = @"^((13[0-9])|(147)|170|176|177|178|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
- (NSString *)trimSpace {
    
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
}

+ (BOOL)isZimu:(NSString *)str
{
    NSString *emailRegex = @"[A-Za-z]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

- (BOOL)isValidNumber {
    
    NSString *str = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
    
}



@end
