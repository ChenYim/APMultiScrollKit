//
//  APUIKit.h
//  APKit
//
//  Created by ChenYim on 16/7/4.
//  Copyright © 2016年 ChenYim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APUIKit : NSObject

//for frame
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;
+ (CGSize)sourceOfIPhone6PWidth:(CGFloat)width height:(CGFloat)height;
+ (CGSize)sourceOfIPhone6Width:(CGFloat)width height:(CGFloat)height;
+ (CGSize)sourceOfIPhone4Or5Or5sWidth:(CGFloat)width
                               height:(CGFloat)height;
+ (CGFloat)sourceOfIPhone6PScale;
+ (CGFloat)sourceOfIPhone6Scale;
+ (CGFloat)sourceOfIPhone4Or5Or5sScale;
@end

@interface UIColor(APUIKit)

- (float)ap_R;
- (float)ap_G;
- (float)ap_B;
- (float)ap_A;
- (NSArray<NSNumber *> *)ap_RGBAValues;

+ (UIColor *)ap_colorWithHexStr:(NSString *)hexColorStr alpha:(CGFloat)opacity;

@end