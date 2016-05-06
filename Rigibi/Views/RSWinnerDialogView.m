//
//  RSWinnerDialogView.m
//  Rigibi
//
//  Created by Roman Silin on 26/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSWinnerDialogView.h"

@implementation RSWinnerDialogView

- (void)setup {
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    CGRect cupFrame;
    cupFrame.size = CGSizeMake(100, 100);
    cupFrame.origin.x = self.frame.size.width/2 - cupFrame.size.width/2;
    cupFrame.origin.y = self.frame.size.height/2 - cupFrame.size.height;
    
    UIButton *cupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cupButton setFrame:cupFrame];
    [cupButton setImage:[UIImage imageNamed:@"cup"] forState:UIControlStateNormal];
    [cupButton addTarget:self action:@selector(playWin) forControlEvents:UIControlEventTouchUpInside];
    [cupButton setTintColor:[UIColor whiteColor]];
    [self addSubview:cupButton];
    
    CGRect topLabelFrame = self.frame;
    topLabelFrame.size.height = 100;
    topLabelFrame.origin.y = cupFrame.origin.y - topLabelFrame.size.height;
    UILabel *topLabel = [[UILabel alloc] initWithFrame:topLabelFrame];
    [topLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [topLabel setNumberOfLines:4];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setText:NSLocalizedString(@"DIALOG_YOUARETHEWINNER", nil)];
    [self addSubview:topLabel];

    CGRect bottomLabelFrame = topLabelFrame;
    bottomLabelFrame.size.height = 25;
    bottomLabelFrame.origin.y = cupFrame.origin.y + cupFrame.size.height;
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:bottomLabelFrame];
    [bottomLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [bottomLabel setNumberOfLines:1];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setText:NSLocalizedString(@"DIALOG_THANKSFORPLAYING", nil)];
    [self addSubview:bottomLabel];
    
    CGRect rateButtonFrame = cupFrame;
    rateButtonFrame.origin.y = bottomLabelFrame.origin.y + bottomLabelFrame.size.height;
    rateButtonFrame.origin.x = self.frame.size.width/2 - rateButtonFrame.size.width;
    self.rateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rateButton setFrame:rateButtonFrame];
    [self.rateButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [self.rateButton addTarget:self action:@selector(rateApp) forControlEvents:UIControlEventTouchUpInside];
    [self.rateButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.rateButton];
    
    CGRect shareButtonFrame = rateButtonFrame;
    shareButtonFrame.origin.x = self.frame.size.width/2;
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shareButton setFrame:shareButtonFrame];
    [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareWin) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.shareButton];
    
    CGRect closeButtonFrame = self.frame;
    closeButtonFrame.size.height = [self.delegate gridSize];
    closeButtonFrame.origin.y = self.frame.size.height - 1.5*closeButtonFrame.size.height;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setFrame:closeButtonFrame];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [closeButton setTitle:NSLocalizedString(@"DIALOG_IGOTIT", nil) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState: UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState: UIControlStateHighlighted];
    [closeButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    
    self.twinkleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(twinkle)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)twinkle {

    CGRect blockFrame;
    CGFloat sizeOfBlock = [self.delegate gridSize];
    blockFrame.size = CGSizeMake(sizeOfBlock, sizeOfBlock);
    NSInteger blocksOnX = ceil(self.frame.size.width/sizeOfBlock);
    NSInteger positionX = arc4random()%blocksOnX;
    blockFrame.origin.x = blockFrame.size.width * positionX;
    NSInteger blocksOnY = ceil(self.frame.size.height/sizeOfBlock);
    NSInteger positionY = arc4random()%blocksOnY;
    blockFrame.origin.y = blockFrame.size.height * positionY;
    UIView *blockView = [[UIView alloc] initWithFrame:blockFrame];
    [blockView setBackgroundColor:[UIColor randomColor]];
    [blockView setAlpha:0.0];
    [self insertSubview:blockView atIndex:0];
    [UIView animateWithDuration:2.0 animations:^{
        [blockView setAlpha:0.5f];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:2.0 animations:^{
            [blockView setAlpha:0.0f];
        } completion:^(BOOL finished){
            [blockView removeFromSuperview];
        }];
    }];
    
}

- (void)shareWin {
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    [sharingItems addObject:NSLocalizedString(@"SHARE_WIN", nil)];
    [sharingItems addObject:[NSURL URLWithString:RIGIBI_URL]];
    [sharingItems addObject:[UIImage imageNamed:@"winner"]];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];

    if ([activityVC respondsToSelector:(@selector(setCompletionWithItemsHandler:))]) {
        UIView *sourceView = [[UIView alloc] init];
        CGRect sourceFrame = self.shareButton.frame;
        sourceFrame.origin.y += sourceFrame.size.height;
        sourceFrame.size = CGSizeZero;
        [sourceView setFrame:sourceFrame];
        activityVC.popoverPresentationController.sourceView = sourceView;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (completed) {
                [YMMYandexMetrica reportEvent:evWIN parameters:@{evWINSHARE:activityType} onFailure:nil];
            }
        }];
    } else {
        [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
            if (completed) {
                [YMMYandexMetrica reportEvent:evWIN parameters:@{evWINSHARE:activityType} onFailure:nil];
            }
        }];
    }
    [self.delegate presentViewController:activityVC animated:YES completion:nil];
}

- (void)rateApp {

    [self.delegate rateApp];
    [YMMYandexMetrica reportEvent:evWIN parameters:@{evWINRATE:@""} onFailure:nil];
}

- (void)close {
    
    [self.delegate hideDialog];
}

- (void)playWin {
    
    [self.delegate playSound:@"gameover"];
}

@end
