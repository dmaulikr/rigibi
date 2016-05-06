//
//  RSHelpView.m
//  Rigibi
//
//  Created by Roman Silin on 04/05/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSHelpView.h"

@implementation RSHelpView

+ (RSHelpView *)initWithSetupWithFrame:(CGRect)frame andDelegate:(id <RSGameVCDelegate>)delegate {
    RSHelpView *helpView = [[RSHelpView alloc] initWithFrame:frame];
    [helpView setDelegate:delegate];
    [helpView setBackgroundColor:[UIColor blackColor]];
    [helpView.closeButton setTitle:NSLocalizedString(@"DIALOG_IGOTIT", nil) forState:UIControlStateNormal];
    [helpView setupContentOfTutorial];
    [helpView setBackgroundColor:[UIColor colorFromHex:@"#101010"]];
    return helpView;
}

+ (NSString *)setupHTMLString:(NSString *)string {
    
    NSString *htmlString = @"<center><span style='font-family: Avenir; font-size: 18px; color: #ffffff'>";
    htmlString = [htmlString stringByAppendingString:string];
    htmlString = [htmlString stringByAppendingString:@"</span></center>"];
    return htmlString;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        if (self.frame.size.width < SCREEN_IPAD) {
            [_scrollView setBounces:YES];
            [_scrollView setScrollEnabled:YES];
            [_scrollView setAlwaysBounceVertical:YES];
            [_scrollView setShowsVerticalScrollIndicator:NO];
            
            UIView *container = [[UIView alloc] initWithFrame:self.frame];
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = container.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[self.backgroundColor CGColor], (id)[[UIColor clearColor] CGColor], nil];
                    gradient.startPoint = CGPointMake(0.5, 1-[self.delegate gridSize]/self.frame.size.height);
                    gradient.endPoint = CGPointMake(0.5, 1);
            [container.layer setMask:gradient];
            [self addSubview:container];
            [container addSubview:_scrollView];
        } else {
            [self addSubview:_scrollView];
        }
    }
    return _scrollView;
}

- (void)setupContentOfTutorial {
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect closeButtonFrame;
    closeButtonFrame.size.height = [self.delegate gridSize];
    closeButtonFrame.size.width = self.frame.size.width;
    closeButtonFrame.origin.x = 0;
    closeButtonFrame.origin.y = 0;
    [self.closeButton setFrame:closeButtonFrame];
    [self.closeButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [self.closeButton addTarget:self.delegate action:@selector(hideDialog) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitle:NSLocalizedString(@"DIALOG_IGOTIT", nil) forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState: UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState: UIControlStateHighlighted];
    [self.closeButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
    [self.closeButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.9] forState:UIControlStateNormal];

    FXBlurView *container = [[FXBlurView alloc] initWithFrame:closeButtonFrame];
    [container setTintColor:[UIColor clearColor]];
    [container addSubview:self.closeButton];
    [self addSubview:container];
    
    CGFloat paddingVertical = 16.f;
    CGFloat paddingHorizontal = (self.frame.size.width < SCREEN_IPAD)?16.f:128.f;
    CGFloat hexTableFontSize = (self.frame.size.width < SCREEN_IPHONE6)?12:14;
    
    CGRect text_01_Frame = self.scrollView.frame;
    text_01_Frame.origin.y = self.closeButton.frame.size.height;
    text_01_Frame.origin.y += (self.frame.size.width < SCREEN_IPAD)?paddingVertical:[self.delegate gridSize]/2;
    
    text_01_Frame.origin.x += paddingHorizontal;
    text_01_Frame.size.width = self.scrollView.frame.size.width - 2*paddingHorizontal;
    UILabel *tutorialLabel_01 = [[UILabel alloc] initWithFrame:text_01_Frame];
    NSString *htmlString = [RSHelpView setupHTMLString:NSLocalizedString(@"HEXHELP_01", nil)];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [tutorialLabel_01 setTextAlignment:NSTextAlignmentCenter];
    [tutorialLabel_01 setLineBreakMode:NSLineBreakByWordWrapping];
    [tutorialLabel_01 setNumberOfLines:0];
    [tutorialLabel_01 setAttributedText:attrString];
    [tutorialLabel_01 sizeToFit];
    text_01_Frame = tutorialLabel_01.frame;
    text_01_Frame.size.width = self.scrollView.frame.size.width - 2*paddingHorizontal;
    [tutorialLabel_01 setFrame:text_01_Frame];
    [self.scrollView addSubview:tutorialLabel_01];

    CGRect resultFrame = text_01_Frame;
    resultFrame.size.width = [self.delegate gridSize]*3;
    resultFrame.size.height = [self.delegate gridSize];
    resultFrame.origin.x = self.frame.size.width/2 - resultFrame.size.width/2;
    resultFrame.origin.y = tutorialLabel_01.frame.origin.y + tutorialLabel_01.frame.size.height  + paddingVertical;

    self.resultSquare = [[RSHexLabel alloc] initWithFrame:resultFrame];
    CAShapeLayer *maskLayerBottom = [CAShapeLayer layer];
    maskLayerBottom.path = [UIBezierPath bezierPathWithRoundedRect:self.resultSquare.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:[self.delegate radiusOfBorder]].CGPath;
    self.resultSquare.layer.mask = maskLayerBottom;
    [self.resultSquare setTextAlignment:NSTextAlignmentCenter];
    [self.resultSquare setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
    [self.resultSquare setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self.scrollView addSubview:self.resultSquare];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(randomAll)];
    [tapGR setDelegate:self];
    [self.resultSquare addGestureRecognizer:tapGR];
    [self.resultSquare setUserInteractionEnabled:YES];

    CGRect redSliderFrame = resultFrame;
    redSliderFrame.origin.y += resultFrame.size.height+paddingVertical;
    redSliderFrame.size.width = resultFrame.size.width;
    self.redSlider = [[UISlider alloc] initWithFrame:redSliderFrame];
    [self.redSlider sizeToFit];
    redSliderFrame = self.redSlider.frame;
    [self.redSlider setMinimumValue:1];
    [self.redSlider setMaximumValue:256];
    [self.redSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.redSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
    [self.redSlider setValue:self.redSlider.maximumValue];
    [self.redSlider setContinuous:YES];
    [self.redSlider addTarget:self action:@selector(updateColors) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.redSlider];
    
    CGRect greenSliderFrame = redSliderFrame;
    greenSliderFrame.origin.y += redSliderFrame.size.height+paddingVertical/2;
    self.greenSlider = [[UISlider alloc] initWithFrame:greenSliderFrame];
    [self.greenSlider setMinimumValue:1];
    [self.greenSlider setMaximumValue:256];
    [self.greenSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.greenSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
    [self.greenSlider setValue:self.greenSlider.maximumValue];
    [self.greenSlider setContinuous:YES];
    [self.greenSlider addTarget:self action:@selector(updateColors) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.greenSlider];

    CGRect blueSliderFrame = greenSliderFrame;
    blueSliderFrame.origin.y += greenSliderFrame.size.height+paddingVertical/2;
    self.blueSlider = [[UISlider alloc] initWithFrame:blueSliderFrame];
    [self.blueSlider setMinimumValue:1];
    [self.blueSlider setMaximumValue:256];
    [self.blueSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.blueSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
    [self.blueSlider setValue:self.blueSlider.maximumValue];
    [self.blueSlider setContinuous:YES];
    [self.blueSlider addTarget:self action:@selector(updateColors) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.blueSlider];

    CGRect redValueFrame = redSliderFrame;
    redValueFrame.origin.x = redValueFrame.origin.x + redSliderFrame.size.width;
    redValueFrame.size.width = [self.delegate gridSize];
    self.redValue = [[UILabel alloc] initWithFrame:redValueFrame];
    [self.redValue setTextAlignment:NSTextAlignmentCenter];
    [self.redValue setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
    [self.redValue setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:self.redValue];
    
    CGRect redLetterFrame = redValueFrame;
    redLetterFrame.origin.x = redSliderFrame.origin.x - redLetterFrame.size.width;
    UILabel *redLetter = [[UILabel alloc] initWithFrame:redLetterFrame];
    [redLetter setTextAlignment:NSTextAlignmentCenter];
    [redLetter setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
    [redLetter setTextColor:[UIColor whiteColor]];
    [redLetter setText:@"R"];
    [self.scrollView addSubview:redLetter];
    
    CGRect greenValueFrame = greenSliderFrame;
    greenValueFrame.origin.x = greenValueFrame.origin.x + greenSliderFrame.size.width;
    greenValueFrame.size.width = [self.delegate gridSize];
    self.greenValue = [[UILabel alloc] initWithFrame:greenValueFrame];
    [self.greenValue setTextAlignment:NSTextAlignmentCenter];
    [self.greenValue setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
    [self.greenValue setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:self.greenValue];
    
    CGRect greenLetterFrame = greenValueFrame;
    greenLetterFrame.origin.x = greenSliderFrame.origin.x - greenLetterFrame.size.width;
    UILabel *greenLetter = [[UILabel alloc] initWithFrame:greenLetterFrame];
    [greenLetter setTextAlignment:NSTextAlignmentCenter];
    [greenLetter setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
    [greenLetter setTextColor:[UIColor whiteColor]];
    [greenLetter setText:NSLocalizedString(@"RGB_G", nil)];
    [self.scrollView addSubview:greenLetter];
    
    CGRect blueValueFrame = blueSliderFrame;
    blueValueFrame.origin.x = blueValueFrame.origin.x + blueSliderFrame.size.width;
    blueValueFrame.size.width = [self.delegate gridSize];
    self.blueValue = [[UILabel alloc] initWithFrame:blueValueFrame];
    [self.blueValue setTextAlignment:NSTextAlignmentCenter];
    [self.blueValue setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
    [self.blueValue setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:self.blueValue];

    CGRect blueLetterFrame = blueValueFrame;
    blueLetterFrame.origin.x = blueSliderFrame.origin.x - blueLetterFrame.size.width;
    UILabel *blueLetter = [[UILabel alloc] initWithFrame:blueLetterFrame];
    [blueLetter setTextAlignment:NSTextAlignmentCenter];
    [blueLetter setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
    [blueLetter setTextColor:[UIColor whiteColor]];
    [blueLetter setText:@"B"];
    [self.scrollView addSubview:blueLetter];
    
    [self updateColors];
    
    CGRect text_02_Frame = text_01_Frame;
    text_02_Frame.origin.y = blueSliderFrame.origin.y + blueSliderFrame.size.height + paddingVertical;
    UILabel *tutorialLabel_02 = [[UILabel alloc] initWithFrame:text_02_Frame];
    htmlString = [RSHelpView setupHTMLString:NSLocalizedString(@"HEXHELP_02", nil)];
    attrString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [tutorialLabel_02 setTextAlignment:NSTextAlignmentCenter];
    [tutorialLabel_02 setLineBreakMode:NSLineBreakByWordWrapping];
    [tutorialLabel_02 setNumberOfLines:0];
    [tutorialLabel_02 setAttributedText:attrString];
    [tutorialLabel_02 sizeToFit];
    text_02_Frame = tutorialLabel_02.frame;
    text_02_Frame.size.width = self.scrollView.frame.size.width - 2*paddingHorizontal;
    [tutorialLabel_02 setFrame:text_02_Frame];
    [self.scrollView addSubview:tutorialLabel_02];
    
    CGRect hexTable = text_02_Frame;
    if (self.frame.size.width < SCREEN_IPAD) {
        hexTable.size.width = self.frame.size.width;
        hexTable.origin.x = 0;
    }
    hexTable.size.height = [self.delegate gridSize];
    hexTable.origin.y = text_02_Frame.origin.y + text_02_Frame.size.height + paddingVertical;
    NSArray *row1 = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
    NSArray *row2 = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F"];
    NSArray *cols = @[row1,row2];
    CGFloat cellWidth = hexTable.size.width / row1.count;
    CGFloat cellHeight = floor(hexTable.size.height / cols.count);
    hexTable.size.width = cellWidth*row1.count;
    if (self.frame.size.width >= SCREEN_IPAD) {
        hexTable.origin.x = self.scrollView.frame.size.width/2 - hexTable.size.width/2;
    }
    for (int row = 0; row < 2; row++) {
        for (NSString *col in cols[row]) {
            CGRect labelRect = CGRectMake(hexTable.origin.x+cellWidth*[cols[row] indexOfObject:col], hexTable.origin.y+cellHeight*row, cellWidth, cellHeight);
            UILabel *cell = [[UILabel alloc] initWithFrame:labelRect];
            [cell setBackgroundColor:[UIColor colorFromHex:([cols[row] indexOfObject:col] % 2 == 0)?@"#303030":@"#373737"]];
            [cell setTextColor:[UIColor colorFromHex:@"#ffff1f"]];
            [cell setFont:[UIFont fontWithName:@"Avenir-Black" size:hexTableFontSize]];
            [cell setTextAlignment:NSTextAlignmentCenter];
            [cell setText:col];
            [self.scrollView addSubview:cell];
        }
    }
    
    CGRect text_03_Frame = text_02_Frame;
    text_03_Frame.origin.y = hexTable.origin.y + hexTable.size.height + paddingVertical*1.5;
    UILabel *tutorialLabel_03 = [[UILabel alloc] initWithFrame:text_03_Frame];
    htmlString = [RSHelpView setupHTMLString:NSLocalizedString(@"HEXHELP_03", nil)];
    attrString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [tutorialLabel_03 setTextAlignment:NSTextAlignmentCenter];
    [tutorialLabel_03 setLineBreakMode:NSLineBreakByWordWrapping];
    [tutorialLabel_03 setNumberOfLines:0];
    [tutorialLabel_03 setAttributedText:attrString];
    [tutorialLabel_03 sizeToFit];
    text_03_Frame = tutorialLabel_03.frame;
    text_03_Frame.size.width = self.scrollView.frame.size.width - 2*paddingHorizontal;
    [tutorialLabel_03 setFrame:text_03_Frame];
    [self.scrollView addSubview:tutorialLabel_03];
    
    if (self.frame.size.width < SCREEN_IPAD) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, text_03_Frame.origin.y+text_03_Frame.size.height + paddingVertical)];
    } else {
        [self.scrollView setContentSize:self.frame.size];
    }
    
    [self bringSubviewToFront:container];
}

- (void)updateColors {

    self.redSlider.value = round(self.redSlider.value);
    self.greenSlider.value = round(self.greenSlider.value);
    self.blueSlider.value = round(self.blueSlider.value);
    
    int redValue = self.redSlider.value;
    int greenValue = self.greenSlider.value;
    int blueValue = self.blueSlider.value;
    
    [self.redValue setText:[NSString stringWithFormat:@"%i", (int)redValue-1]];
    [self.redSlider setTintColor:[UIColor colorFromHex:[NSString stringWithFormat:@"%02X0000", (int)redValue-1]]];
    [self.greenValue setText:[NSString stringWithFormat:@"%i", (int)greenValue-1]];
    [self.greenSlider setTintColor:[UIColor colorFromHex:[NSString stringWithFormat:@"00%02X00", (int)greenValue-1]]];
    [self.blueValue setText:[NSString stringWithFormat:@"%i", (int)blueValue-1]];
    [self.blueSlider setTintColor:[UIColor colorFromHex:[NSString stringWithFormat:@"0000%02X", (int)blueValue-1]]];

    [self.resultSquare setText:[NSString stringWithFormat:@"#%02X%02X%02X", redValue-1, greenValue-1, blueValue-1]];
    [self.resultSquare setBackgroundColor:[UIColor colorFromHex:self.resultSquare.text]];
}

- (void)randomAll {
    
    [self randomRed];
    [self randomGreen];
    [self randomBlue];
}

- (void)randomRed {
    
    [self setRandomValueToSlider:self.redSlider];
}

- (void)randomGreen {
    
    [self setRandomValueToSlider:self.greenSlider];
}

- (void)randomBlue {
    
    [self setRandomValueToSlider:self.blueSlider];
}

- (void)setRandomValueToSlider:(UISlider *)slider {
    
    float newValue = slider.value;
    while (slider.value == newValue) {
        newValue = (arc4random()%5)*64;
    }
    [slider setValue:newValue animated:YES];
    [self updateColors];
}


@end
