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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = 100;
    
    TagView *leftTagView = [[TagView alloc] init];
    leftTagView.frame = CGRectMake(8, 100, width, 200);
    leftTagView.titles = @[@"1", @"2", @"3", @"4"];
    
    TagView *rightTagView = [[TagView alloc] init];
    rightTagView.frame = CGRectMake(self.view.frame.size.width - 8 - width, 100, width, 200);
    rightTagView.titles = @[@"5", @"6", @"7", @"8"];
    
    [self.view addSubview:rightTagView];
    [self.view addSubview:leftTagView];
    
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

- (void)lineWithLeftTagView:(TagView *)leftTagView rightTagView:(TagView *)rightTagView
{
    TagButton *leftButton = leftTagView.selectedButton;
    TagButton *rightButton = rightTagView.selectedButton;
    
    if (!leftButton || !rightButton) {
        return;
    }
    
    CGPoint leftPoint = CGPointMake(CGRectGetMaxX(leftButton.frame), CGRectGetMidY (leftButton.frame));
    CGPoint rightPoint = CGPointMake(CGRectGetMinX(rightButton.frame), CGRectGetMidY(rightButton.frame));
    leftPoint = [leftButton.superview convertPoint:leftPoint toView:self.view];
    rightPoint = [rightButton.superview convertPoint:rightPoint toView:self.view];
    
    CAShapeLayer *lineLayer = [self lineWithLeftPoint:leftPoint rightPoint:rightPoint];
    
    [self.view.layer addSublayer:lineLayer];
    
    [leftButton.lineLayer removeFromSuperlayer];
    [rightButton.lineLayer removeFromSuperlayer];
    
    [leftTagView cancelSelect];
    [rightTagView cancelSelect];
    
    leftButton.lineLayer = lineLayer;
    rightButton.lineLayer = lineLayer;
}

- (CAShapeLayer *)lineWithLeftPoint:(CGPoint)leftPoint rightPoint:(CGPoint)rightPoint
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:leftPoint];
    [linePath addLineToPoint:rightPoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil;
    
    return lineLayer;
}

@end
