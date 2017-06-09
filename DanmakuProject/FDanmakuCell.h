//
//  FDanmakuCell.h
//  DanmakuProject
//
//  Created by __无邪_ on 2017/6/9.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFDanmakuCellSpace 25

@protocol FDanmakuCellDelegate;


@interface FDanmakuCell : UIView

@property (nonatomic, weak) id <FDanmakuCellDelegate>delegate;
@property (nonatomic, strong) UILabel *labMessage;
@property (nonatomic, strong,readonly) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) NSInteger runway;

- (instancetype)initWithIdentifier:(NSString *)identifier;

- (void)runStart:(void(^)())startAnimationHandler
   finished:(void(^)())finishedAnimationHandler;
@end

@protocol FDanmakuCellDelegate <NSObject>
- (void)danmakuCell:(FDanmakuCell *)cell runwayIsAvailable:(NSInteger)runway;
@end
