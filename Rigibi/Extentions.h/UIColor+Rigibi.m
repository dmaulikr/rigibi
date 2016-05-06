//
//  UIColor+Rigibi.m
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "UIColor+Rigibi.h"

@implementation UIColor (Rigibi)

#pragma mark Color generator

+ (UIColor*)randomColor {
    
    unsigned int baseInt = arc4random() % 16777216;
    NSString *hex = [NSString stringWithFormat:@"%06X", baseInt];
    return [self colorFromHex:hex];
    
}

- (UIColor *)lighterColor {
    
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor {
    
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.8
                               alpha:a];
    return nil;
}

+ (UIColor *)colorFromHex:(NSString*)hexValue {
    
    UIColor *defaultResult = [UIColor blackColor];
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3) {
        componentLength = 1;
    }
    else if ([hexValue length] == 6) {
        componentLength = 2;
    }
    else {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}

- (NSString *)hexFromColor {
    
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hex = [NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hex;
    
}

@end
