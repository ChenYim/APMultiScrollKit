//
//  APUIKit.m
//  APKit
//
//  Created by ChenYim on 16/7/4.
//  Copyright © 2016年 ChenYim. All rights reserved.
//

#import "APUIKit.h"

@implementation APUIKit

//for frame
+ (CGFloat)getScreenWidth
{
    if (IPAD_DEVICE)
    {
        return SCREEN_WIDTH;
    }
    else
    {
        if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
            ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight))
        {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        return [[UIScreen mainScreen] bounds].size.width;
    }
}

+ (CGFloat)getScreenHeight
{
    if (IPAD_DEVICE)
    {
        return SCREEN_HEIGHT;
    }
    else
    {
        if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight))
        {
            return [[UIScreen mainScreen] bounds].size.width;
        }
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

+ (CGSize)sourceOfIPhone6PWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat scale = height / width;
    CGFloat screenWidth = [self getScreenWidth];
    CGFloat newWidth = width / 414 * screenWidth;
    CGFloat newHeight = newWidth * scale;
    return CGSizeMake(newWidth, newHeight);
}

+ (CGSize)sourceOfIPhone6Width:(CGFloat)width height:(CGFloat)height
{
    CGFloat scale = height / width;
    CGFloat screenWidth = [self getScreenWidth];
    CGFloat newWidth = width / 375 * screenWidth;
    CGFloat newHeight = newWidth * scale;
    return CGSizeMake(newWidth, newHeight);
}

+ (CGSize)sourceOfIPhone4Or5Or5sWidth:(CGFloat)width
                               height:(CGFloat)height
{
    CGFloat scale = height / width;
    CGFloat screenWidth = [self getScreenWidth];
    CGFloat newWidth = width / 320 * screenWidth;
    CGFloat newHeight = newWidth * scale;
    return CGSizeMake(newWidth, newHeight);
}

+ (CGFloat)sourceOfIPhone6PScale
{
    CGFloat scale = [self getScreenWidth] / 414.0f;
    return scale;
}

+ (CGFloat)sourceOfIPhone6Scale
{
    CGFloat scale = [self getScreenWidth] / 375.0f;
    return scale;
}

+ (CGFloat)sourceOfIPhone4Or5Or5sScale
{
    CGFloat scale = [self getScreenWidth] / 320.0f;
    return scale;
}

@end

@implementation UIColor(APUIKit)

- (NSArray<NSNumber *> *)ap_RGBAValues
{
    CGFloat R, G, B, A;
    
    CGColorRef colorRef = [self CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(colorRef);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
        A = components[3];
    }
    return @[@(R), @(G), @(B), @(A)];
}

- (float)ap_R
{
    NSNumber *red = [[self ap_RGBAValues] objectAtIndex:0];
    return [red floatValue];
}

- (float)ap_G
{
    NSNumber *green = [[self ap_RGBAValues] objectAtIndex:1];
    return [green floatValue];
}

- (float)ap_B
{
    NSNumber *blue = [[self ap_RGBAValues] objectAtIndex:2];
    return [blue floatValue];
}

- (float)ap_A
{
    NSNumber *alpha = [[self ap_RGBAValues] objectAtIndex:3];
    return [alpha floatValue];
}

+ (UIColor *)ap_colorWithHexStr:(NSString *)hexColorStr alpha:(CGFloat)opacity
{
    NSString *cString = [[hexColorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    range.location = 2;
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    range.location = 4;
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:opacity];
}

@end