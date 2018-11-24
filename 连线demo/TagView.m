//
//  TagView.m
//  连线demo
//
//  Created by yulin on 2018/11/23.
//  Copyright © 2018年 jackma. All rights reserved.
//

#import "TagView.h"
#import "TagButton.h"

@interface TagView()

@property (nonatomic) NSMutableArray *buttons;

@end

@implementation TagView

- (void)setTitles:(NSArray *)titles
{
    _titles = [titles copy];
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        TagButton *button = [TagButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.tag = i;
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = ceil(self.frame.size.height / self.buttons.count) - 5;
    CGFloat y = 0;
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        TagButton *button = self.buttons[i];
        button.frame = CGRectMake(0, y, width, height);
        y += height + 5;
    }
}

- (void)didClickButton:(TagButton *)button
{
    if (self.selectedButton == button) {
        [self cancelSelect];
        return;
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    if (self.didSelectButton) {
        self.didSelectButton(button);
    }
}

- (void)cancelSelect
{
    self.selectedButton.selected = NO;
    _selectedButton = nil;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

@end
