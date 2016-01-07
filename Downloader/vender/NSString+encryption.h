//
//  NSString+encryption.h
//  Chat
//
//  Created by 赛峰 施 on 15/8/20.
//  Copyright (c) 2015年 CZS Team 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encryption)
+ (NSString *)md5ForString:(NSString *)value;
+ (NSString *)base64StringFromData:(NSData *)data;
+ (NSData *)dataFromBase64String:(NSString *)aString;
+ (NSString *)decode:(NSData *)data;
@end
