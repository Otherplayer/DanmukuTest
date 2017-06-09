//
//  FdanmakuModel.m
//  DanmakuProject
//
//  Created by __无邪_ on 2017/6/9.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "FdanmakuModel.h"

@implementation FdanmakuModel

- (CGFloat)cellWidth{
    
    UIFont *font = [FdanmakuModel font];
    CGFloat msgWidth = [self.message sizeWithAttributes:@{NSFontAttributeName : font}].width;
    
    return  msgWidth + 40;
    
}

+ (UIFont *)font{
    return [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
}

@end
