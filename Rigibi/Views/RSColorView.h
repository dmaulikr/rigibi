//
//  RSColorView.h
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSColorBlock.h"
#import "RSHexLabel.h"

@interface RSColorView : UIView

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) RSHexLabel *hexLabel;
@property (strong, nonatomic) RSColorBlock *block;
@property (weak, nonatomic) id <RSGameVCDelegate> delegate;
@property (nonatomic) BOOL selected;

- (void)updateView;
    
@end
