//
//  RSRoundedView.m
//  Rigibi
//
//  Created by Roman Silin on 15.03.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSRoundedView.h"

@implementation RSRoundedView

- (void)drawRect:(CGRect)rect {

    CAShapeLayer * maskLayer = [CAShapeLayer layer];    
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners:self.corners cornerRadii:self.radius].CGPath;
    self.layer.mask = maskLayer;
}

@end
