//
//  TagLayer.h
//  连线demo
//
//  Created by wugaojun on 2018/11/28.
//  Copyright © 2018年 jackma. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class TagButton;

NS_ASSUME_NONNULL_BEGIN

@interface TagLayer : CAShapeLayer

@property (nonatomic, weak) TagButton *leftTagButton;
@property (nonatomic, weak) TagButton *rightTagButton;

@end

NS_ASSUME_NONNULL_END
