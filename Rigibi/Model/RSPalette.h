//
//  RSPalette.h
//  Rigibi
//
//  Created by Roman Silin on 22.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSPalette : NSObject

@property (nonatomic) float stepRGB;
@property (strong, nonatomic) NSArray *targetColors;
@property (strong, nonatomic) NSArray *colors;


+ (RSPalette *)paletteWithStep:(float)stepRGB;

- (UIColor *)mixColors:(NSArray *)colors;
- (NSArray *)unmixColor:(UIColor *)color;

- (UIColor *)randomTargetColor;
- (UIColor *)randomColor;

@end
