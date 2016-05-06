//
//  RSGameZoneView.m
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSGameZoneView.h"

@implementation RSGameZoneView

- (void)panGestureMove:(UIPanGestureRecognizer *)gestureRecognizer {

    CGPoint location = [gestureRecognizer locationInView:self];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        // Нажатие на цветной блок (стратовый)
        self.firstBlock = nil;
        for (RSColorView *colorView in self.subviews) {
            if (CGRectContainsPoint(colorView.frame, location)) {
                self.firstBlock = colorView.block;
            }
        }
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        if (self.firstBlock == nil) {
            return;
        }
        // Наведение на соседний по горизонтали/вертикали цветной блок
        for (RSColorView *colorView in self.subviews) {
            if (![colorView isKindOfClass:[RSColorView class]]) {
                continue;
            }
            if (CGRectContainsPoint(colorView.frame, location) && colorView.block != self.firstBlock) {
                
                RSColorBlock *hoverBlock = colorView.block;
                int deltaX = hoverBlock.position.x - self.firstBlock.position.x;
                int deltaY = hoverBlock.position.y - self.firstBlock.position.y;

                if ((abs(deltaX) == 1 && deltaY == 0) ||
                    (abs(deltaY) == 1 && deltaX == 0)) {
                    
                    self.secondBlock = hoverBlock;
                    if (DEVMODE) {
                        if ([self.delegate dev_recSolutionMode]) {
                            [self.delegate dev_recSolutionFrom:self.firstBlock to:self.secondBlock];
                        }
                        if ([self.delegate dev_unmixMode]) {
                            [self.delegate dev_unmixColorBlock:self.firstBlock toColorBlock:self.secondBlock];
                            break;
                        }
                    }
                    if (![self.firstBlock.color.hexFromColor isEqualToString:self.secondBlock.color.hexFromColor]) {
                        [self.delegate saveMixHistory];
                    }
                    [self mixBlock:self.firstBlock with:self.secondBlock];
                    [self.delegate setSolutionStep:0];
                    [self setFirstBlock:self.secondBlock];
                    [self setSecondBlock:nil];
                }
                [self.delegate updateUI];
                break;
            }
        }
    }
}

- (void)mixBlock:(RSColorBlock *)firstBlock with:(RSColorBlock *)secondBlock {
    
    if (!firstBlock || !secondBlock) {
        NSLog(@"mixColors error: nil-colors");
        return;
    }
    if ([firstBlock.color.hexFromColor isEqualToString:secondBlock.color.hexFromColor]) {
        return;
    }
    
    UIColor *newColor = [[self.delegate gameLevel].palette mixColors:@[firstBlock.color, secondBlock.color]];
    
    // Добавляем к текущей группе общих блоков новые блоки
    NSMutableArray *mutualColorGroup = [[NSMutableArray alloc] init];
    [mutualColorGroup addObjectsFromArray:firstBlock.mutualColorGroup];
    [mutualColorGroup addObjectsFromArray:secondBlock.mutualColorGroup];

    // Обновляем цвета новой общей группы блоков
    for (NSValue *positionValue in mutualColorGroup) {
        RSColorBlock *block = [[[self delegate] gameLevel] blockOnPosition:[positionValue CGPointValue]];
        [block setColor:newColor];
        [block setMutualColorGroup:mutualColorGroup];
    }
    
    [[self.delegate gameLevel] updateMutualBlocks];
    if (![self.delegate checkForSolve]) {
        [self.delegate playSound:@"mix"];
    };
    [self updateView];
}

- (BOOL)isBlockInCenter:(RSColorBlock *)block {

    int levelWidth = [self.delegate gameLevel].size.width;
    int levelHeight = [self.delegate gameLevel].size.height;
    int centerPositionX = floor(levelWidth/2);
    int centerPositionY = floor(levelHeight/2);

    if (levelWidth % 2 == 0 && levelHeight % 2 == 0) {
        return NO;
    }
    if (block.position.x == centerPositionX && block.position.y == centerPositionY) {
        return YES;
    }
    if (levelWidth % 2 == 0 && block.position.x+1 == centerPositionX && block.position.y == centerPositionY) {
        return YES;
    }
    if (levelHeight % 2 == 0 && block.position.y+1 == centerPositionY && block.position.x == centerPositionX) {
        return YES;
    }
    return NO;
}

- (void)updateView {

    [UIView animateWithDuration:0.3 animations:^{
        for (RSColorView *colorView in self.subviews) {
            if ([colorView isKindOfClass:[RSColorView class]]) {
                BOOL hideHex = [self isBlockInCenter:colorView.block];
                if (![[self.delegate gameLevel] isSovled]) {
                    hideHex = NO;
                } else if ([[self.delegate gameLevel] isSovledRight]) {
                    hideHex = YES;
                };
                [colorView.hexLabel setAlpha:([self.delegate hexShowed] && !hideHex)?1:0];
                [colorView updateView];
            }
        }
    }];
}

- (void)setupWithGameLevel:(RSGameLevel *)gameLevel {
    
    [self setBackgroundColor:gameLevel.targetColor];
    
    // Размещение цветных блоков в игровой зоне
    for (RSColorBlock *block in gameLevel.blocks) {
        
        NSInteger tag = [gameLevel.blocks indexOfObject:block] + 1;
        RSColorView *colorView = (RSColorView *)[self viewWithTag:tag];
        
        if (!colorView) {
            
            CGFloat borderWidth = self.delegate.gridSize/4;
            CGRect frameOfColor = CGRectZero;
            frameOfColor.size.width = self.delegate.gridSize;
            frameOfColor.size.height = self.delegate.gridSize;
            frameOfColor.origin.x = borderWidth + block.position.x * self.delegate.gridSize;
            frameOfColor.origin.y = borderWidth + block.position.y * self.delegate.gridSize;
            
            colorView = [[RSColorView alloc] initWithFrame:frameOfColor];
            [colorView setDelegate:self.delegate];
            [colorView setTag:[gameLevel.blocks indexOfObject:block] + 1];
            
            if (DEVMODE) {
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(dev_doubleTapOnBlock:)];
                doubleTap.numberOfTapsRequired = 2;
                [colorView addGestureRecognizer:doubleTap];
            }
            [colorView.hexLabel setAlpha:([self.delegate hexShowed])?1:0];
            [self addSubview:colorView];
        }
        [colorView setBlock:block];
    }
    [self.delegate checkForSolve];
}

@end
