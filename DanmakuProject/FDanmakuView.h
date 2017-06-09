//
//  FDanmakuView.h
//  DanmakuProject
//
//  Created by __无邪_ on 2017/6/9.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDanmakuCell.h"
#import "FdanmakuModel.h"

@protocol FDanmakuDataSource,FDanmakuDelegate;


@interface FDanmakuView : UIView

@property (nonatomic, weak) id <FDanmakuDataSource>dataSource;
@property (nonatomic, weak) id <FDanmakuDelegate>delegate;

- (FDanmakuCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)insertModels:(NSArray<FdanmakuModel *> *)models;
- (void)startAnimation;



@end



@protocol FDanmakuDataSource <NSObject>
- (NSUInteger)numberOfRowsInBarrageView:(FDanmakuView *)barrageView;
- (FDanmakuCell *)barrageView:(FDanmakuView *)barrageView cellForModel:(FdanmakuModel *)model;
@end
@protocol FDanmakuDelegate <NSObject>
- (CGFloat)heightForItemInDanmakuView:(FDanmakuView *)danmakuView;
@end
