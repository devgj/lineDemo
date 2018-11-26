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

@property (nonatomic) UIScrollView *scrollView;

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
    
    TagView *rightTagView = [[TagView alloc] init];
    rightTagView.frame = CGRectMake(self.view.frame.size.width - 8 - width, 100, width, 50 * rightTitles.count);
    rightTagView.titles = rightTitles;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:leftTagView];
    [self.scrollView addSubview:rightTagView];
    
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
    leftPoint = [leftButton.superview convertPoint:leftPoint toView:self.scrollView];
    rightPoint = [rightButton.superview convertPoint:rightPoint toView:self.scrollView];
    
    CAShapeLayer *lineLayer = [self lineWithLeftPoint:leftPoint rightPoint:rightPoint];
    
    [self.scrollView.layer addSublayer:lineLayer];
    
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
