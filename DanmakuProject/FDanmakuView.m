//
//  FDanmakuView.m
//  DanmakuProject
//
//  Created by __无邪_ on 2017/6/9.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "FDanmakuView.h"

#define kMainWidth  [[UIScreen mainScreen] bounds].size.width
#define kMainHeight [[UIScreen mainScreen] bounds].size.height
#define FDanmakuWS(weakSelf)          __weak __typeof(&*self)weakSelf = self;

@interface FDanmakuView ()<FDanmakuCellDelegate>
@property (nonatomic, strong)NSMutableArray *reuseCells;
@property (nonatomic, strong)NSMutableArray *cells;
@property (nonatomic, strong)NSMutableSet   *availableRunways;
@property (nonatomic, strong)NSMutableArray *datas;

@end


@implementation FDanmakuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.datas = [[NSMutableArray alloc] init];
        self.reuseCells = [[NSMutableArray alloc] init];
        self.cells = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma mark - Public

- (void)insertModels:(NSArray<FdanmakuModel *> *)models{
    [self.datas addObjectsFromArray:models];
}

- (FDanmakuCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    FDanmakuCell *availableCell = nil;
    if (self.reuseCells.count) {
        availableCell = self.reuseCells.firstObject;
        [availableCell removeFromSuperview];
        [self.reuseCells removeObjectAtIndex:0];
    }
    return availableCell;
}

#pragma mark - FDanmakuCellDelegate
- (void)danmakuCell:(FDanmakuCell *)cell runwayIsAvailable:(NSInteger)runway{
    @synchronized (self) {
        [self.availableRunways addObject:@(runway)];
    }
    [self startAnimation];
}
#pragma mark -
- (void)startAnimation{
    
    FDanmakuWS(weakSelf);
    //取出需要展示的数据
    NSArray *items = [self subArrayWithNumber:[self rows]];
    
    for (FdanmakuModel *model in items) {
        FDanmakuCell *currentCell = [self.dataSource barrageView:self cellForModel:model];
        //在哪展示
        currentCell.delegate = self;
        NSInteger runway = [self availableRunway];
        if (runway != -1) {
            NSLog(@"%@",@(runway));
        }
        if (runway == -1) {//无可用轨道
            [self.datas addObject:model];
        }else{
            [currentCell setRunway:runway];
            [currentCell setFrame:[self frame:runway width:[model cellWidth]]];
            if (![self.subviews containsObject:currentCell]) {
                [self addSubview:currentCell];
            }
            
            [currentCell runStart:^{
                [weakSelf.cells addObject:currentCell];
            } finished:^{
                [weakSelf.reuseCells addObject:currentCell];
                [weakSelf.cells removeObject:currentCell];
            }];
        }
    }
    
}

- (CGRect)frame:(NSInteger)runway width:(CGFloat)width{
    CGFloat height = [self.delegate heightForItemInDanmakuView:self];
    return CGRectMake(self.frame.size.width, height * runway, width, height);
}
- (NSInteger)availableRunway{
    @synchronized (self) {
        if (self.availableRunways.count > 0) {
            NSNumber *runway = [self.availableRunways anyObject];
            if ([self.availableRunways containsObject:runway]) {
                [self.availableRunways removeObject:runway];
            }
            return runway.integerValue;
        }
    }
    return -1;
}

- (NSInteger)rows{
    return [self.dataSource numberOfRowsInBarrageView:self];
}


- (NSArray *)subArrayWithNumber:(NSInteger)number{
    if (self.datas.count) {
        if (self.datas.count >= number) {
            NSArray *subArray = [self.datas subarrayWithRange:NSMakeRange(0, number)];
            [self removeModels:subArray];
            return subArray;
        }else {
            NSArray *array = [[NSArray alloc] initWithArray:self.datas];
            [self removeModels:array];
            return array;
        }
    }
    return @[];
}

- (void)removeModels:(NSArray *)objs{
    for (FdanmakuModel *obj in objs) {
        if ([self.datas containsObject:obj]) {
            [self.datas removeObject:obj];
            continue;
        }
    }
}

- (NSMutableSet *)availableRunways{
    if (!_availableRunways) {
        _availableRunways = [[NSMutableSet alloc] init];
        for (int i = 0; i < [self rows]; i++) {
            [self.availableRunways addObject:@(i)];
        }
    }
    return _availableRunways;
}









@end
