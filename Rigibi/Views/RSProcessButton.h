//
//  RSProcessButton.h
//  Rigibi
//
//  Created by Roman Silin on 17.03.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSProcessButton : UIButton

@property (weak, nonatomic) id <RSGridSizeDelegate> delegate;
@property (nonatomic) BOOL process;
@property (nonatomic) float timeForFade;
@property (strong, nonatomic) UIView *tempView;
@property (strong, nonatomic) UIImageView *processView;
@property (strong, nonatomic) UIImage *processImage;

@end
