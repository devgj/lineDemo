//
//  TagView.h
//  连线demo
//
//  Created by yulin on 2018/11/23.
//  Copyright © 2018年 jackma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagButton;

NS_ASSUME_NONNULL_BEGIN

@interface TagView : UIView

@property (nonatomic, readonly) TagButton *selectedButton;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) void (^didSelectButton)(TagButton *button);
- (void)cancelSelect;

@end

NS_ASSUME_NONNULL_END
