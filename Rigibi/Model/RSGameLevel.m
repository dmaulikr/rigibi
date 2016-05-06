//
//  RSGameLevel.m
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSGameLevel.h"

@implementation RSGameLevel

+ (RSGameLevel *)emptyLevelWithSize:(CGSize )size pallete:(RSPalette *)palette andTargetColor:(UIColor *)targetColor {
    
    if (!size.width || !size.height) {
        
        // Случайный размер, исключая 1х1
        int sizeX = arc4random()%BLOCKS_IN_ROW + 1;
        int sizeY;
        if (sizeX == 1) {
            sizeY = arc4random()%(BLOCKS_IN_ROW - 1) + 2;
        } else {
            sizeY = arc4random()%BLOCKS_IN_ROW + 1;
        }
        size = CGSizeMake(sizeX, sizeY);
    }
    
    if (palette == nil) {
        palette = [RSPalette paletteWithStep:RGBSTEP];
    }
    
    RSGameLevel *gameLevel = [[RSGameLevel alloc] init];
    [gameLevel setSize:size];
    [gameLevel setPalette:palette];
    [gameLevel setTargetColor:targetColor];
    NSInteger blocksCount = gameLevel.size.width * gameLevel.size.height;
    
    // Расстановка блоков без цветов
    gameLevel.blocks = [[NSMutableArray alloc] init];
    for (int index = 0; index < blocksCount; index++) {
        
        CGPoint positionOfBlock = CGPointZero;
        positionOfBlock.x = index;
        positionOfBlock.y = 0;
        while (positionOfBlock.x > size.width - 1) {
            positionOfBlock.x = positionOfBlock.x - size.width;
            positionOfBlock.y ++;
        }
        RSColorBlock *block = [[RSColorBlock alloc] init];
        block.position = positionOfBlock;
        [gameLevel.blocks addObject:block];
    }
    return gameLevel;
}

+ (RSGameLevel *)generateLevelwithSize:(CGSize )size pallete:(RSPalette *)palette andTargetColor:(UIColor *)targetColor {
    RSGameLevel *gameLevel = [self emptyLevelWithSize:size pallete:palette andTargetColor:targetColor];
    [gameLevel generatePuzzle];
    [gameLevel updateMutualBlocks];
    return gameLevel;
}

- (void)generatePuzzle {
    
    // Разложение цвета-решения на мозайку
    // Используется в качестве болванки для создания уровней в DEVMODE
    
    RSColorBlock *startBlock = [self.blocks objectAtIndex:arc4random()%self.blocks.count];
    [startBlock setColor:self.targetColor];
    NSMutableArray *readyBlocks = [[NSMutableArray alloc] init];
    [readyBlocks addObject:startBlock];
    
    while (readyBlocks.count < self.blocks.count) {
        RSColorBlock *firstBlock = nil;
        RSColorBlock *nextBlock = nil;
        
        for (int i = 0; i < self.blocks.count; i++) {
            RSColorBlock *readyBlock = [readyBlocks objectAtIndex:arc4random()%readyBlocks.count];
            NSMutableArray *allowedDirections = [[NSMutableArray alloc] init];
            
            for (int direction = 0; direction < 4; direction++) {
                CGPoint position = [RSGameLevel positionOnDirection:direction fromPosition:readyBlock.position];
                if ((position.x < 0) ||
                    (position.y < 0) ||
                    (position.x > self.size.width-1) ||
                    (position.y > self.size.height-1)) {
                    continue;
                } else if (![readyBlocks containsObject:[self blockOnPosition:position]]) {
                    
                    [allowedDirections addObject:[NSNumber numberWithInteger:direction]];
                }
            }
            
            if ([allowedDirections count]) {
                int randomIndex = arc4random()%allowedDirections.count;
                NSInteger nextDirection = [[allowedDirections objectAtIndex:randomIndex] integerValue];
                CGPoint nextPosition = [RSGameLevel positionOnDirection:nextDirection fromPosition:readyBlock.position];
                nextBlock = [self blockOnPosition:nextPosition];
                firstBlock = readyBlock;
                break;
            }
        }
        
        if (nextBlock) {
            NSArray *unmixPares = [self.palette unmixColor:firstBlock.color];
            NSArray *unmixColors = [unmixPares objectAtIndex:arc4random()%[unmixPares count]];
            [firstBlock setColor:[unmixColors firstObject]];
            [nextBlock setColor:[unmixColors lastObject]];
            [readyBlocks addObject:nextBlock];
        }
    }
}

+ (CGPoint )positionOnDirection:(RSDirection )direction fromPosition:(CGPoint )position {
    
    if (direction == RSDirectionTop) {
        position.y--;
    } else if (direction == RSDirectionRight) {
        position.x++;
    } else if (direction == RSDirectionDown) {
        position.y++;
    } else if (direction == RSDirectionLeft) {
        position.x--;
    }
    
    return position;
}

+ (RSGameLevel *)copyGameLevel:(RSGameLevel *)gameLevel {
    
    // Копирование уровня, используется для изоляции изменений текущего уровня от оригинального массива уровней
    RSGameLevel *copyGameLevel = [[RSGameLevel alloc] init];
    copyGameLevel.size = gameLevel.size;
    copyGameLevel.targetColor = gameLevel.targetColor;
    copyGameLevel.palette = gameLevel.palette;
    copyGameLevel.solutionSteps = gameLevel.solutionSteps;
    copyGameLevel.blocks = [[NSMutableArray alloc] init];

    for (RSColorBlock *originalBlock in gameLevel.blocks) {
        RSColorBlock *copyBlock = [[RSColorBlock alloc] init];
        copyBlock.position = originalBlock.position;
        copyBlock.color = originalBlock.color;
        copyBlock.mutualColorGroup = [RSGameLevel copyMutualColorGroup:originalBlock.mutualColorGroup];
        [copyGameLevel.blocks addObject:copyBlock];
    }
    return copyGameLevel;
    
}

+ (NSMutableArray *)copyMutualColorGroup:(NSMutableArray *)mutualColorGroup {
    
    // Копирование массива общих блоков
    NSMutableArray *copyMutualColorGroup = [[NSMutableArray alloc] init];
    for (NSValue *positionValue in mutualColorGroup) {
        NSValue *copyPositionValue = [NSValue valueWithCGPoint:[positionValue CGPointValue]];
        [copyMutualColorGroup addObject:copyPositionValue];
    }
    return copyMutualColorGroup;
}

- (void)updateMutualBlocks {
    
    // Проходит по всему уровню и обновляет информацию об общих блоках
    for (RSColorBlock *block in self.blocks) {
        
        NSInteger index = [self.blocks indexOfObject:block];
        NSMutableArray *mutualColorGroup = [[NSMutableArray alloc] init];
        [mutualColorGroup addObject:[NSValue valueWithCGPoint:block.position]];
        
        RSColorBlock *topBlock = (block.position.y > 0)?[self.blocks objectAtIndex:(index - self.size.width)]:nil;
        if (topBlock && [topBlock.color.hexFromColor isEqualToString:block.color.hexFromColor]) {
            [mutualColorGroup addObjectsFromArray:topBlock.mutualColorGroup];
        } else { topBlock = nil; }
        
        RSColorBlock *leftBlock = (block.position.x > 0)?[self.blocks objectAtIndex:(index - 1)]:nil;
        if (leftBlock && [leftBlock.color.hexFromColor isEqualToString:block.color.hexFromColor]) {
            [mutualColorGroup addObjectsFromArray:leftBlock.mutualColorGroup];
        } else { leftBlock = nil; }
        
        mutualColorGroup = [[[NSSet setWithArray:mutualColorGroup] allObjects] mutableCopy];
        [block setMutualColorGroup:mutualColorGroup];
        
        if (leftBlock) {
            for (NSValue *positionValue in leftBlock.mutualColorGroup) {
                RSColorBlock *nearbyBlock = [self blockOnPosition:[positionValue CGPointValue]];
                [nearbyBlock setMutualColorGroup:mutualColorGroup];
            }
        }
        if (topBlock) {
            for (NSValue *positionValue in topBlock.mutualColorGroup) {
                RSColorBlock *nearbyBlock = [self blockOnPosition:[positionValue CGPointValue]];
                [nearbyBlock setMutualColorGroup:mutualColorGroup];
            }
        }
        
    }
}

- (UIColor *)targetColor {
    
    // Цвет, к которому должен придти игрок
    if (_targetColor == nil) {
        _targetColor = [self.palette randomTargetColor];
    }
    return _targetColor;
}

- (RSColorBlock *)blockOnPosition:(CGPoint)position {
    
    // Возвращает блок по координатам
    RSColorBlock *blockOnPosition = nil;
    for (RSColorBlock *block in self.blocks) {
        if (block.position.x == position.x && block.position.y == position.y) {
            blockOnPosition = block;
            break;
        }
    }
    return blockOnPosition;
}

- (BOOL)isSovledRight {

    // Решен ли уровен?
    for (RSColorBlock *block in self.blocks) {
        if (![block.color.hexFromColor isEqualToString:self.targetColor.hexFromColor]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isSovled {

    RSColorBlock *firstBlock = [self.blocks firstObject];
    for (RSColorBlock *block in self.blocks) {

        if (![block.color.hexFromColor isEqualToString:firstBlock.color.hexFromColor]) {
            return NO;
        }
    }
    return YES;
}

- (void)solveLevel {
    
    // Решает полностью уровень    
    for (RSColorBlock *block in self.blocks) {
        [block setColor:self.targetColor];
    }
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeCGSize:self.size forKey:@"size"];
    [encoder encodeObject:self.palette forKey:@"palette"];
    [encoder encodeObject:self.targetColor forKey:@"targetColor"];
    [encoder encodeObject:self.blocks forKey:@"blocks"];
    [encoder encodeObject:self.solutionSteps forKey:@"solution"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if (self != nil)
    {
        self.size = [decoder decodeCGSizeForKey:@"size"];
        self.palette = [decoder decodeObjectForKey:@"palette"];
        self.targetColor = [decoder decodeObjectForKey:@"targetColor"];
        self.blocks = [decoder decodeObjectForKey:@"blocks"];
        self.solutionSteps = [decoder decodeObjectForKey:@"solution"];
    }
    return self;
}

@end
