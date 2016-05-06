//
//  RSPalette.m
//  Rigibi
//
//  Created by Roman Silin on 22.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSPalette.h"

@implementation RSPalette

#pragma mark Palettes

+ (RSPalette *)paletteWithStep:(float)stepRGB {
    
    // Испозьзуем ограниченную палитру, чтобы решить загадку смог не только компьютер, но и хомо сапиенс
    RSPalette *palette = [[RSPalette alloc] init];
    [palette setStepRGB:stepRGB];
    return palette;
}

- (NSArray *)colors {

    if (!_colors) {
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (float r = 0; r <= 1; r = r + self.stepRGB) {
            for (float g = 0; g <= 1; g = g + self.stepRGB) {
                for (float b = 0; b <= 1; b = b + self.stepRGB) {
                    [mutableArray addObject:[UIColor colorWithRed:r green:g blue:b alpha:1.0]];
                }
            }
        }
        _colors = mutableArray;
    }
    return _colors;
    
}

- (NSArray *)targetColors {
    
    // В целевые цвета попадают только те, что можно расложить хотя бы еще на два
    // для избежания генерации уже решеных уровней
    if (!_targetColors) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.colors];
        
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (UIColor *color in self.colors) {
            if ([self unmixColor:color].count == 1) {
                [toRemove addObject:color];
            }
        }
        [mutableArray removeObjectsInArray:toRemove];
        _targetColors = mutableArray;
    }
    return _targetColors;
}

- (UIColor *)randomTargetColor {
    
    return [self.targetColors objectAtIndex:arc4random()%self.targetColors.count];
}

- (UIColor *)randomColor {
    
    return [self.colors objectAtIndex:arc4random()%self.colors.count];
}

#pragma mark Color mixing

- (UIColor *)mixColors:(NSArray *)colors {
    
    if (colors.count < 2) {
        NSLog(@"mixColors: colors.count < 2");
        return nil;
    }

    // Смешивание цветов происходит по усредненным позициям Red, Green и Blue
    CGFloat proportion = 1 / (float)colors.count;
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1;
    
    for (UIColor *color in colors) {
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        red += proportion*r; green += proportion*g; blue += proportion*b;
    }
    // Подгоняем под HEX, иначе могут быть погрешности отображения на экране
    NSString *colorHex = [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] hexFromColor];
    UIColor *color = [UIColor colorFromHex:colorHex];
    return color;
}

- (NSArray *)unmixColor:(UIColor *)color {

    // Функция возвращает все возможные вариации разложения цвета в рамках текущей палитры
    NSMutableArray *resultVariants = [[NSMutableArray alloc] init];
    
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    CGFloat r1, g1, b1;
    CGFloat r2, g2, b2;
    [resultVariants addObject:@[color, color]];
    
    int rOffsetsCount = (int) (MIN(1.0 - r, r) / self.stepRGB);
    int gOffsetsCount = (int) (MIN(1.0 - g, g) / self.stepRGB);
    int bOffsetsCount = (int) (MIN(1.0 - b, b) / self.stepRGB);

    for (float rOffset = 0; rOffset <= rOffsetsCount; rOffset += self.stepRGB) {
        r1 = r + rOffset;
        r2 = r - rOffset;
        for (float gOffset = 0; gOffset <= gOffsetsCount; gOffset += self.stepRGB) {
            g1 = g + gOffset;
            g2 = g - gOffset;
            for (float bOffset = 0; bOffset <= bOffsetsCount; bOffset += self.stepRGB) {
                b1 = b + bOffset;
                b2 = b - bOffset;
                if (!(rOffset == 0 && gOffset == 0 && bOffset == 0)) {
                    UIColor *color1 = [UIColor colorWithRed:r1 green:g1 blue:b1 alpha:a];
                    UIColor *color2 = [UIColor colorWithRed:r2 green:g2 blue:b2 alpha:a];
                    [resultVariants addObject:@[color1, color2]];
                    [resultVariants addObject:@[color2, color1]];
                }
            }
        }
    }
    resultVariants = [[[NSSet setWithArray:resultVariants] allObjects] mutableCopy];
    return resultVariants;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeFloat:self.stepRGB forKey:@"stepRGB"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if (self != nil)
    {
        self.stepRGB = [decoder decodeFloatForKey:@"stepRGB"];
    }
    return self;
}

@end
