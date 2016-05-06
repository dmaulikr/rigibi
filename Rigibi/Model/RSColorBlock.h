//
//  RSColorBlock.h
//  Rigibi
//
//  Created by Roman Silin on 17.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

@interface RSColorBlock : NSObject

@property (nonatomic) CGPoint position; // Позиция блока в игровой зоне
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSMutableArray *mutualColorGroup; // Позиции CGPoint соседних блоков с тем эже цветом

@end
