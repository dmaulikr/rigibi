//
//  RSHexLabel.m
//  Rigibi
//
//  Created by Roman Silin on 08/05/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSHexLabel.h"

@implementation RSHexLabel

- (void)setText:(NSString *)text {

    UIColor *oldColor = [UIColor colorFromHex:self.text];
    [super setText:text];
    UIColor *newColor = [UIColor colorFromHex:text];
    
    const CGFloat *componentsOld = CGColorGetComponents(oldColor.CGColor);
    const CGFloat *componentsNew = CGColorGetComponents(newColor.CGColor);
    CGFloat rOld = componentsOld[0];
    CGFloat rNew = componentsNew[0];
    CGFloat gOld = componentsOld[1];
    CGFloat gNew = componentsNew[1];
    CGFloat bOld = componentsOld[2];
    CGFloat bNew = componentsNew[2];
    
    CGFloat middleOld = (rOld+gOld+bOld)/3;
    CGFloat middleNew = (rNew+gNew+bNew)/3;
    CGFloat magicLimit = 0.08;
    
    BOOL darkTransition = (middleOld >= magicLimit && middleNew < magicLimit);
    BOOL lightTransition = (middleOld <= magicLimit && middleNew > magicLimit);
    
    if (self.animated && (lightTransition || darkTransition)) {
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setTextColor:(middleNew < magicLimit)?[UIColor colorWithWhite:1 alpha:0.3]:[UIColor colorWithWhite:0 alpha:0.7]];
        } completion:nil];
    } else {
        [self setTextColor:(middleNew < magicLimit)?[UIColor colorWithWhite:1 alpha:0.3]:[UIColor colorWithWhite:0 alpha:0.7]];
    }
}

@end
