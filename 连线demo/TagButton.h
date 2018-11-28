//
//  TagButton.h
//  连线demo
//
//  Created by yulin on 2018/11/23.
//  Copyright © 2018年 jackma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagLayer;

NS_ASSUME_NONNULL_BEGIN

@interface TagButton : UIButton

@property (nonatomic, weak) TagLayer *lineLayer;

@end

NS_ASSUME_NONNULL_END
