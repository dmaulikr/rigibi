//
//  UIColor+Rigibi.h
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

@interface UIColor (Rigibi)

+ (UIColor *)randomColor;
- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

+ (UIColor *)colorFromHex:(NSString*)hexValue;
- (NSString *)hexFromColor;

@end
