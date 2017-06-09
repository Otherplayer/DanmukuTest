//
//  FDanmakuCell.m
//  DanmakuProject
//
//  Created by __无邪_ on 2017/6/9.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "FDanmakuCell.h"

@interface FDanmakuCell ()<CAAnimationDelegate>
@property (copy, nonatomic) void (^startAnimationBlock)();
@property (copy, nonatomic) void (^finishAnimationBlock)();
@end

@implementation FDanmakuCell

- (instancetype)initWithIdentifier:(NSString *)identifier{
    self = [super init];
    if (self) {
        _reuseIdentifier = identifier;
        
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
        self.animationDuration = 0.f;
        self.runway = -1;
        self.labMessage = [[UILabel alloc] initWithFrame:self.bounds];
        self.labMessage.textColor = [UIColor blackColor];
        self.labMessage.textAlignment = NSTextAlignmentCenter;
        self.labMessage.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:self.labMessage];
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.labMessage setFrame:self.bounds];
}

- (void)runStart:(void(^)())startAnimationHandler finished:(void(^)())finishedAnimationHandler{
    
    CGRect frame             = self.frame;
    CGFloat totalWidth = CGRectGetWidth(frame) + frame.origin.x;
    CGFloat speed = 40.f;
    CGFloat dur = totalWidth / speed;
    CGFloat spent = (CGRectGetWidth(frame) + kFDanmakuCellSpace) / speed;
    [NSTimer scheduledTimerWithTimeInterval:spent repeats:NO block:^(NSTimer * _Nonnull timer) {
        [_delegate danmakuCell:self runwayIsAvailable:self.runway];
    }];
    
    [self.layer removeAnimationForKey:@"shooter"];
    
    [self setAnimationDuration:dur];
    [self setStartAnimationBlock:startAnimationHandler];
    [self setFinishAnimationBlock:finishedAnimationHandler];
    
    CABasicAnimation *move   = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromPoint        = CGPointMake(frame.origin.x + CGRectGetWidth(frame)/2.f, frame.origin.y + CGRectGetHeight(frame)/2.f);
    CGPoint toPoint          = CGPointMake(- CGRectGetWidth(frame), frame.origin.y + CGRectGetHeight(frame)/2.f);
    move.fromValue           = [NSValue valueWithCGPoint:fromPoint];
    move.toValue             = [NSValue valueWithCGPoint:toPoint];
    move.duration            = dur;
    move.delegate            = self;
    move.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    move.removedOnCompletion = NO;// 取消反弹
    [self.layer addAnimation:move forKey:@"shooter"];
    
}





#pragma mark - CAAnimationDelegate

/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim{
    if (self.startAnimationBlock) {
        self.startAnimationBlock();
    }
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.finishAnimationBlock) {
        self.finishAnimationBlock();
    }
}



@end
