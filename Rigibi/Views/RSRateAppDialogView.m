//
//  RSRateAppDialogView.m
//  Rigibi
//
//  Created by Roman Silin on 26/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSRateAppDialogView.h"

@implementation RSRateAppDialogView

- (CGFloat)gridSize {
    
    return [self.delegate gridSize];
}

- (CGSize)radiusOfBorder {
    
    return [self.delegate radiusOfBorder];
}

- (CGSize)radiusOfInside {
    
    return [self.delegate radiusOfInside];
}

- (void)playSound:(NSString *)soundName {
    
    [self.delegate playSound:soundName];
}

- (UILabel *)messageLabel {
    
    if (_messageLabel == nil) {
        
        CGRect frameOfMessage;
        frameOfMessage.size.width = self.frame.size.width;
        frameOfMessage.size.height = [self.delegate gridSize]*1.5;
        frameOfMessage.origin.x = 0;
        frameOfMessage.origin.y = self.noButton.frame.origin.y - frameOfMessage.size.height - 10;

        _messageLabel = [[UILabel alloc] initWithFrame:frameOfMessage];
        [_messageLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [_messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_messageLabel setNumberOfLines:0];
        [_messageLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UILabel *)noLabel {
    
    if (_noLabel == nil) {
        
        CGRect frameOfNoLabel;
        frameOfNoLabel.size.width = self.frame.size.width/2;
        frameOfNoLabel.size.height = self.messageLabel.frame.size.height;
        frameOfNoLabel.origin.x = self.noButton.frame.origin.x + self.noButton.frame.size.width/2 - frameOfNoLabel.size.width/2;
        frameOfNoLabel.origin.y = self.noButton.frame.origin.y + self.noButton.frame.size.height;
        
        _noLabel = [[UILabel alloc] initWithFrame:frameOfNoLabel];
        [_noLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
        [_noLabel setTextAlignment:NSTextAlignmentCenter];
        [_noLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_noLabel setNumberOfLines:0];
        [_noLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_noLabel];
    }
    return _noLabel;
}

- (UILabel *)yesLabel {
    
    if (_yesLabel == nil) {
        
        CGRect frameOfYesLabel;
        frameOfYesLabel.size.width = self.frame.size.width/2;
        frameOfYesLabel.size.height = self.messageLabel.frame.size.height;
        frameOfYesLabel.origin.x = self.yesButton.frame.origin.x + self.yesButton.frame.size.width/2 - frameOfYesLabel.size.width/2;
        frameOfYesLabel.origin.y = self.yesButton.frame.origin.y + self.yesButton.frame.size.height;
        
        _yesLabel = [[UILabel alloc] initWithFrame:frameOfYesLabel];
        [_yesLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
        [_yesLabel setTextAlignment:NSTextAlignmentCenter];
        [_yesLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_yesLabel setNumberOfLines:0];
        [_yesLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_yesLabel];
    }
    return _yesLabel;
}

- (RSMixButton *)noButton {

    if (_noButton == nil) {
        
        CGRect frameOfNoButton;
        frameOfNoButton.size.height = self.gridSize*2 + self.gridSize/4*2;
        frameOfNoButton.size.width = self.gridSize*1 + self.gridSize/4*2;
        frameOfNoButton.origin.x = self.frame.size.width/2 - self.gridSize*1.6 - self.gridSize/4;
        frameOfNoButton.origin.y = self.frame.size.height/2 - frameOfNoButton.size.height/2;
        
        _noButton = [[RSMixButton alloc] initWithFrame:frameOfNoButton];
        [_noButton setDelegate:self];
        [self addSubview:self.noButton];
    }
    return _noButton;
}

- (RSMixButton *)yesButton {
    
    if (_yesButton == nil) {
        
        CGFloat sizeOfBlock = [self.delegate gridSize];
        CGRect frameOfYesButton;
        frameOfYesButton.size.height = sizeOfBlock*2 + sizeOfBlock/4*2;
        frameOfYesButton.size.width = sizeOfBlock*1 + sizeOfBlock/4*2;
        frameOfYesButton.origin.x = self.frame.size.width/2 + sizeOfBlock*0.6 - sizeOfBlock/4;
        frameOfYesButton.origin.y = self.frame.size.height/2 - frameOfYesButton.size.height/2;
        
        _yesButton = [[RSMixButton alloc] initWithFrame:frameOfYesButton];
        [_yesButton setDelegate:self];
        [self addSubview:self.yesButton];
    }
    return _yesButton;
}


- (void)setup {
    
    [self setBackgroundColor:[UIColor blackColor]];

    [self.noButton setTopColor:[UIColor colorFromHex:@"000000"]];
    [self.noButton setBottomColor:[UIColor colorFromHex:@"00FFFF"]];
    [self.noButton setBackgroundColor:[UIColor colorFromHex:@"007F7F"]];
    [self.noButton setup];

    [self.yesButton setTopColor:[UIColor colorFromHex:@"FFFFFF"]];
    [self.yesButton setBottomColor:[UIColor colorFromHex:@"FF007F"]];
    [self.yesButton setBackgroundColor:[UIColor colorFromHex:@"FF7FBF"]];
    
    [self.yesButton setup];

    [self.messageLabel setText:NSLocalizedString(@"DIALOG_ENJOYINGRIGIBI", nil)];
    [self.noLabel setText:NSLocalizedString(@"DIALOG_NOT", nil)];
    [self.yesLabel setText:NSLocalizedString(@"DIALOG_YES", nil)];
}

- (void)userChoose:(RSMixButton *)sender {
    
    [self.yesButton setEnabled:NO];
    [self.noButton setEnabled:NO];
    self.dialogResult = (sender == self.yesButton)?YES:NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.dialogResult == YES) {
            [self.noButton setAlpha:0.0];
            [self.noLabel setAlpha:0.0];
        } else {
            [self.yesButton setAlpha:0.0];
            [self.yesLabel setAlpha:0.0];
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.messageLabel setAlpha:0.0];
            [self.noButton setAlpha:0.0];
            [self.yesButton setAlpha:0.0];
            [self.noLabel setAlpha:0.0];
            [self.yesLabel setAlpha:0.0];
        } completion:^(BOOL finished) {
            
            switch (self.dialogType) {
                case RSDialogEnjoying:
                {
                    [self setDialogType:(self.dialogResult)?RSDialogAppStore:RSDialogFeedback];
                    if (self.dialogResult == YES) {
                        [self.messageLabel setText:NSLocalizedString(@"DIALOG_HOWABOUTARATING", nil)];
                        [self.noLabel setText:NSLocalizedString(@"DIALOG_NOTHANKS", nil)];
                        [self.yesLabel setText:NSLocalizedString(@"DIALOG_YESSURE", nil)];
                    } else {
                        [self.messageLabel setText:NSLocalizedString(@"DIALOG_HOWABOUTAFEEDBACK", nil)];
                        [self.noLabel setText:NSLocalizedString(@"DIALOG_NOTHANKS", nil)];
                        [self.yesLabel setText:NSLocalizedString(@"DIALOG_YESSURE", nil)];;
                    } 
                    [self setNoButton:nil];
                    [self.noButton setTopColor:[UIColor colorFromHex:@"FF7F7F"]];
                    [self.noButton setBottomColor:[UIColor colorFromHex:@"007F7F"]];
                    [self.noButton setBackgroundColor:[UIColor colorFromHex:@"7F7F7F"]];
                    
                    [self.noButton setAlpha:0.0];
                    [self.noButton setup];
                    
                    [self setYesButton:nil];
                    [self.yesButton setTopColor:[UIColor colorFromHex:@"FFFF00"]];
                    [self.yesButton setBottomColor:[UIColor colorFromHex:@"FF7F00"]];
                    [self.yesButton setBackgroundColor:[UIColor colorFromHex:@"FFBF00"]];
                    [self.yesButton setAlpha:0.0];
                    [self.yesButton setup];
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.messageLabel setAlpha:1.0];
                        [self.noButton setAlpha:1.0];
                        [self.yesButton setAlpha:1.0];
                        [self.noLabel setAlpha:1.0];
                        [self.yesLabel setAlpha:1.0];
                    }];
                    break;
                }
                    
                case RSDialogAppStore:
                {
                    if (self.dialogResult == YES) {
                        [self rateApp];
                        [self.delegate hideDialog];
                        [YMMYandexMetrica reportEvent:evLIKEORRATE parameters:@{evLIKEANDRATE:@""} onFailure:nil];
                    } else {
                        [self.delegate hideDialog];
                        [YMMYandexMetrica reportEvent:evLIKEORRATE parameters:@{evLIKEANDIGNORE:@""} onFailure:nil];
                    }
                    break;
                }
                    
                case RSDialogFeedback:
                {
                    if (self.dialogResult == YES) {
                        [self askFeedback];
                        [YMMYandexMetrica reportEvent:evLIKEORRATE parameters:@{evDISLIKEANDFEEDBACK:@""} onFailure:nil];
                    } else {
                        [self.delegate hideDialog];
                        [YMMYandexMetrica reportEvent:evLIKEORRATE parameters:@{evDISLIKEANDIGNORE:@""} onFailure:nil];
                    }
                    break;
                }
            }
        }];
    }];

}

- (void)rateApp {
    
    [self.delegate rateApp];
}

- (void)askFeedback {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:NSLocalizedString(@"MAIL_THEME", nil)];
        [mailVC setToRecipients:[NSArray arrayWithObject:FEEDBACK_EMAIL]];
        [mailVC setMessageBody:NSLocalizedString(@"MAIL_BODY", nil) isHTML:NO];
        [self.delegate presentViewController:mailVC animated:YES completion:nil];
    } else {
        NSString *errorTitle = NSLocalizedString(@"ERROR_TITLE", nil);
        NSString *errorMessage = NSLocalizedString(@"ERROR_MAIL", nil);
        errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@"*RIGIBI_URL*" withString:RIGIBI_URL];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: errorTitle
                                  message:errorMessage
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [self.delegate hideDialog];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
    [self.delegate hideDialog];
}

@end
