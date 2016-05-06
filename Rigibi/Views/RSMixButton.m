//
//  RSMixButton.m
//  Rigibi
//
//  Created by Roman Silin on 27/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSMixButton.h"

@implementation RSMixButton

- (void)setup {
    
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    [self setRadius:[self.delegate radiusOfBorder]];
    [self setCorners:corners];
    
    CGFloat borderWidth = self.delegate.gridSize/4;
    CGRect insideFrame = self.frame;
    insideFrame.origin.x = borderWidth;
    insideFrame.origin.y = borderWidth;
    insideFrame.size.width -= borderWidth*2;
    insideFrame.size.height -= borderWidth*2;
    self.insideView = [[RSRoundedView alloc] initWithFrame:insideFrame];
    [self.insideView setBackgroundColor:[UIColor blueColor]];
    corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    [self.insideView setRadius:[self.delegate radiusOfInside]];
    [self.insideView setCorners:corners];
    self.panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMove:)];
    [self.panGR setDelegate:self];
    [self.panGR setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:self.panGR];
    [self setEnabled:YES];
    [self addSubview:self.insideView];
    
    CGRect topFrame = insideFrame;
    topFrame.origin = CGPointMake(0, 0);
    topFrame.size.height = topFrame.size.width;
    self.topView = [[UIView alloc] initWithFrame:topFrame];
    [self.topView setBackgroundColor:self.topColor];
    [self.insideView addSubview:self.topView];
    
    CGRect bottomFrame = topFrame;
    bottomFrame.origin.y += topFrame.size.height;
    self.bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    [self.bottomView setBackgroundColor:self.bottomColor];
    [self.insideView addSubview:self.bottomView];
    
}

- (void)panGestureMove:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (!self.enabled) {
        return;
    }
    CGPoint location = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        self.startPanView = nil;
        for (UIView *colorView in self.insideView.subviews) {
            if (CGRectContainsPoint(colorView.frame, location)) {
                self.startPanView = colorView;
            }
        }
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        for (UIView *colorView in self.insideView.subviews) {
            if (CGRectContainsPoint(colorView.frame, location) && colorView != self.startPanView) {
                self.startPanView = nil;
                [self.delegate playSound:@"win"];
                [self.delegate userChoose:self];
                CGFloat buttonSize = [self.delegate gridSize];
                CGRect frameOfOkButton = CGRectMake(self.frame.size.width/2 - buttonSize/2, self.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize);
                self.okButton = [UIButton buttonWithType:UIButtonTypeSystem];
                [self.okButton setFrame:frameOfOkButton];
                [self.okButton setTintColor:[UIColor whiteColor]];
                [self.okButton setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
                [self.okButton setAlpha:0.0];
                [self addSubview:self.okButton];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.topView setBackgroundColor:self.backgroundColor];
                    [self.bottomView setBackgroundColor:self.backgroundColor];
                    [self.okButton setAlpha:1.0];
                }];
            }
        }
    }
}

@end
