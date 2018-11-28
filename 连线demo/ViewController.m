//
//  ViewController.m
//  连线demo
//
//  Created by yulin on 2018/11/23.
//  Copyright © 2018年 jackma. All rights reserved.
//

#import "ViewController.h"
#import "TagView.h"
#import "TagButton.h"
#import "TagLayer.h"

@interface ViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) TagView *leftTagView;
@property (nonatomic) TagView *rightTagView;
@property (nonatomic) NSMutableArray<TagLayer *> *layers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *leftTitles = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        [leftTitles addObject:@(i).stringValue];
    }
    NSMutableArray *rightTitles = [NSMutableArray array];
    for (NSInteger i = 50; i < 100; i++) {
        [rightTitles addObject:@(i).stringValue];
    }
    
    CGFloat width = 100;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(0, leftTitles.count * 60);
    
    TagView *leftTagView = [[TagView alloc] init];
    leftTagView.frame = CGRectMake(8, 100, width, 50 * leftTitles.count);
    leftTagView.titles = leftTitles;
    self.leftTagView = leftTagView;
    
    TagView *rightTagView = [[TagView alloc] init];
    rightTagView.frame = CGRectMake(self.view.frame.size.width - 8 - width, 100, width, 50 * rightTitles.count);
    rightTagView.titles = rightTitles;
    self.rightTagView = rightTagView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = CGPointMake(self.view.frame.size.width * 0.5, 100);
    [button setTitle:@"放大" forState:UIControlStateNormal];
    [button setTitle:@"缩小" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:leftTagView];
    [self.scrollView addSubview:rightTagView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:button];
    
    __weak typeof(self) wself = self;
    __weak typeof(TagView) *wleftTagView = leftTagView;
    __weak typeof(TagView) *wrightTagView = rightTagView;
    
    leftTagView.didSelectButton = ^(UIButton * _Nonnull button) {
        [wself lineWithLeftTagView:wleftTagView rightTagView:wrightTagView];
    };
    
    rightTagView.didSelectButton = ^(UIButton * _Nonnull button) {
        [wself lineWithLeftTagView:wleftTagView rightTagView:wrightTagView];
    };
}

- (void)didClickButton:(UIButton *)button
{
    button.selected = !button.isSelected;
    
    CGFloat width = button.selected ? 150 : 100;
    
    CGRect lframe = self.leftTagView.frame;
    lframe.size.width = width;
    self.leftTagView.frame = lframe;
    
    CGRect rframe = self.rightTagView.frame;
    rframe.size.width = width;
    rframe.origin.x = self.view.frame.size.width - 8 - width;
    self.rightTagView.frame = rframe;
    
    [self.leftTagView setNeedsLayout];
    [self.rightTagView setNeedsLayout];
    [self.leftTagView layoutIfNeeded];
    [self.rightTagView layoutIfNeeded];
    
    [self.layers enumerateObjectsUsingBlock:^(TagLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *linepPath = [self linePathWithLeftButton:obj.leftTagButton rightButton:obj.rightTagButton];
        obj.path = linepPath.CGPath;
    }];
}

- (void)lineWithLeftTagView:(TagView *)leftTagView rightTagView:(TagView *)rightTagView
{
    TagButton *leftButton = leftTagView.selectedButton;
    TagButton *rightButton = rightTagView.selectedButton;
    
    if (!leftButton || !rightButton) {
        return;
    }
    
    [self lineWithLeftButton:leftButton rightButton:rightButton];
    
    [leftTagView cancelSelect];
    [rightTagView cancelSelect];
}

- (UIBezierPath *)linePathWithLeftButton:(TagButton *)leftButton rightButton:(TagButton *)rightButton
{
    CGPoint leftPoint = CGPointMake(CGRectGetMaxX(leftButton.frame), CGRectGetMidY (leftButton.frame));
    CGPoint rightPoint = CGPointMake(CGRectGetMinX(rightButton.frame), CGRectGetMidY(rightButton.frame));
    leftPoint = [leftButton.superview convertPoint:leftPoint toView:self.scrollView];
    rightPoint = [rightButton.superview convertPoint:rightPoint toView:self.scrollView];
    UIBezierPath *linePath = [self linePathWithLeftPoint:leftPoint rightPoint:rightPoint];
    return linePath;
}

- (void)lineWithLeftButton:(TagButton *)leftButton rightButton:(TagButton *)rightButton
{
    UIBezierPath *linePath = [self linePathWithLeftButton:leftButton rightButton:rightButton];
    TagLayer *lineLayer = [self lineWithPath:linePath];
    
    [self.scrollView.layer addSublayer:lineLayer];
    
    if (leftButton.lineLayer) {
        [self.layers removeObject:leftButton.lineLayer];
        [leftButton.lineLayer removeFromSuperlayer];
    }
    if (rightButton.lineLayer) {
        [self.layers removeObject:rightButton.lineLayer];
        [rightButton.lineLayer removeFromSuperlayer];
    }
    
    leftButton.lineLayer = lineLayer;
    rightButton.lineLayer = lineLayer;
    lineLayer.leftTagButton = leftButton;
    lineLayer.rightTagButton = rightButton;
    [self.layers addObject:lineLayer];
}

- (UIBezierPath *)linePathWithLeftPoint:(CGPoint)leftPoint rightPoint:(CGPoint)rightPoint
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:leftPoint];
    [linePath addLineToPoint:rightPoint];
    return linePath;
}

- (TagLayer *)lineWithPath:(UIBezierPath *)path
{
    TagLayer *lineLayer = [TagLayer layer];
    
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    lineLayer.path = path.CGPath;
    lineLayer.fillColor = nil;
    
    return lineLayer;
}

#pragma mark - Getter

- (NSMutableArray *)layers
{
    if (!_layers) {
        _layers = [[NSMutableArray alloc] init];
    }
    return _layers;
}

@end
