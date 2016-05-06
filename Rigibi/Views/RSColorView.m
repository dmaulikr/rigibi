//
//  RSColorView.m
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSColorView.h"
#import "RSPalette.h"
#import "RSGameLevel.h"

@implementation RSColorView

- (UILabel *)hexLabel {
    
    if (!_hexLabel) {
        CGRect hexFrame = self.frame;
        hexFrame.origin.x = 0;
        hexFrame.origin.y = 0;
        _hexLabel = [[RSHexLabel alloc] initWithFrame:hexFrame];
        [_hexLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:12]];
        [_hexLabel setTextAlignment:NSTextAlignmentCenter];
        [_hexLabel setAlpha:0];
        [_hexLabel setAnimated:YES];
        [self insertSubview:_hexLabel aboveSubview:self.backgroundView];
    }
    return _hexLabel;
}

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [_backgroundView setBackgroundColor:self.block.color];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)setBlock:(RSColorBlock *)block {

    _block = block;
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundView setBackgroundColor:block.color];
    }];
    [self updateView];
}

- (void)updateView {
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundView setBackgroundColor:self.block.color];
    }];
    [self.hexLabel setText:[NSString stringWithFormat:@"%@",self.block.color.hexFromColor]];
}

- (void)drawRect:(CGRect)rect {
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    BOOL topLeft = (self.block.position.x == 0 && self.block.position.y == 0);
    BOOL topRight = (self.block.position.x == [self.delegate gameLevel].size.width-1 && self.block.position.y == 0);
    BOOL bottomRight = (self.block.position.x == [self.delegate gameLevel].size.width-1 && self.block.position.y == [self.delegate gameLevel].size.height-1);
    BOOL bottomLeft = (self.block.position.x == 0 && self.block.position.y == [self.delegate gameLevel].size.height-1);
    
    UIRectCorner rectCorners = 0;
    if (topLeft) {rectCorners = UIRectCornerTopLeft;}
    if (topRight) {rectCorners += UIRectCornerTopRight;}
    if (bottomLeft) {rectCorners += UIRectCornerBottomLeft;}
    if (bottomRight) {rectCorners += UIRectCornerBottomRight;}
    
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners:rectCorners cornerRadii:CGSizeMake(8.0, 8.0)].CGPath;
    self.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulseAnimation.duration = .5;
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.2];
        pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulseAnimation.autoreverses = YES;
        pulseAnimation.repeatCount = FLT_MAX;
        [self.layer addAnimation:pulseAnimation forKey:@"scale"];
    } else if (self.layer.animationKeys.count) {
        
        [self.layer removeAllAnimations];
    }
}

@end
