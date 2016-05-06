//
//  RSProcessButton.m
//  Rigibi
//
//  Created by Roman Silin on 17.03.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSProcessButton.h"

@implementation RSProcessButton

- (float)timeForFade {
    
    if (!_timeForFade) {
        _timeForFade = 0.2;
    }
    return _timeForFade;
}

- (UIImage *)processImage {
    
    if (!_processImage) {
        _processImage = [UIImage imageNamed:@"process"];
    }
    return _processImage;
}

- (UIImageView *)processView {
    
    if (!_processView) {
        CGRect frameOfProcess = CGRectMake(0, 0, self.delegate.gridSize/2, self.delegate.gridSize/2);
        frameOfProcess.origin.x = (self.frame.size.width/2 - frameOfProcess.size.width/2);
        frameOfProcess.origin.y = (self.frame.size.height/2 - frameOfProcess.size.height/2);
        _processView = [[UIImageView alloc] initWithFrame:frameOfProcess];
        _processView.contentMode = UIViewContentModeCenter;
        [_processView setImage:self.processImage];
        [self.tempView addSubview:_processView];
    }
    return _processView;
}

- (UIView *)tempView {
    
    if (!_tempView) {
        _tempView = [[UIView alloc] initWithFrame:self.bounds];
        [_tempView setBackgroundColor:self.backgroundColor];
        [_tempView setHidden:YES];
        [self addSubview:_tempView];
    }
    return _tempView;
}

- (void)setProcess:(BOOL)process {
    
    _process = process;
    
    if (process) {
        
        [self.tempView setAlpha:0.0];
        [self.tempView setHidden:NO];
        [self.processView setAlpha:0.0];
        [self rotateProcess];
        [UIView animateWithDuration:self.timeForFade animations:^{
            [self.tempView setAlpha:1.0];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:self.timeForFade animations:^{
                [self.processView setAlpha:1.0];
            }];
        }];
        
    } else {

        [UIView animateWithDuration:self.timeForFade animations:^{
            [self.processView setAlpha:0.0];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:self.timeForFade animations:^{
                [self.tempView setAlpha:0.0];
            } completion:^(BOOL finished){
                [self.tempView setHidden:YES];
            }];
        }];
    }
}

- (void)rotateProcess {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.processView setTransform:CGAffineTransformRotate(self.processView.transform, M_PI_2)];
    } completion:^(BOOL finished){
        if (finished && self.process) {
            [self rotateProcess];
        }
    }];
}

@end
