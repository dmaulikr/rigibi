//
//  UIButton+Rigibi.m
//  Rigibi
//
//  Created by Roman Silin on 16.03.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "UIButton+Rigibi.h"

@implementation UIButton (Rigibi)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    
    UIView *colorView = [[UIView alloc] initWithFrame:self.frame];
    colorView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:colorImage forState:state];
}

@end
