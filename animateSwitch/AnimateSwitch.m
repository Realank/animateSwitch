//
//  AnimateSwitch.m
//  animateSwitch
//
//  Created by Realank on 16/4/11.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "AnimateSwitch.h"
#define LINE_WIDTH 2

@interface AnimateSwitch ()

@property (nonatomic, weak) UIView *roundButton;
@property (nonatomic, weak) CAShapeLayer* buttonShapeLayer;
@property (nonatomic, assign) NSInteger step; //动画完成程度，0刚开始，100结束
@property (nonatomic,strong) CADisplayLink *timeLink;

@end

@implementation AnimateSwitch

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _on = NO;
        _step = 100;
        [self configUI];
    }
    
    return self;
}

- (void)configUI{

    self.layer.cornerRadius = self.bounds.size.height / 2;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = LINE_WIDTH;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.1;
    
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(triggeredButton)]];
    UISwipeGestureRecognizer* swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(triggeredButton)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGes];
    
    UIView *roundButton = [[UIView alloc]initWithFrame:[self roundButtonFrame]];
    _roundButton = roundButton;
    roundButton.backgroundColor = [UIColor whiteColor];
    roundButton.layer.cornerRadius = roundButton.bounds.size.width / 2;
    [self addSubview:roundButton];
    
    CAShapeLayer* buttonShapeLayer = [CAShapeLayer layer];
    buttonShapeLayer.frame = roundButton.bounds;
//    buttonShapeLayer.strokeColor = [UIColor redColor].CGColor;
    buttonShapeLayer.fillColor = [UIColor clearColor].CGColor;
    buttonShapeLayer.lineWidth = LINE_WIDTH * 3;
    buttonShapeLayer.lineCap = kCALineCapRound;
    buttonShapeLayer.lineJoin = kCALineJoinRound;
//    buttonShapeLayer.shadowColor = [UIColor blackColor].CGColor;
//    buttonShapeLayer.shadowOffset = CGSizeMake(0, 0);
//    buttonShapeLayer.shadowOpacity = 0.3;
    [roundButton.layer addSublayer:buttonShapeLayer];
    _buttonShapeLayer = buttonShapeLayer;
//    buttonShapeLayer.shouldRasterize = YES;
    [self animateUI];
    
}

- (CGRect)roundButtonFrame{
    CGFloat border = 2 * LINE_WIDTH;
    CGFloat r = self.bounds.size.height / 2 - border;
    CGFloat centerX = border + r;
    if (_on) {
        centerX = self.bounds.size.width - r - border;
    }
    CGFloat centerY = self.bounds.size.height / 2;
    
    return CGRectMake(centerX - r, centerY - r, r * 2, r * 2);
}

#pragma mark - action

- (void)triggeredButton {
    self.on = ! self.isOn;
}

- (void)setOn:(BOOL)on {
    _on = on;
    if (!self.timeLink) {
        _step = 0;
        _timeLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeStep)];
//        _timeLink.frameInterval = 9;
        [_timeLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
}

- (void)changeStep{
    _step += 7;
    if (_step > 100) {
        _step = 100;
        [_timeLink invalidate];
        _timeLink = nil;
    }
    [self animateUI];
}

#pragma mark - animate

- (void)animateUI {
    CGFloat percentOfOn = 0; // 如果为1 则为全开 如果为0 则为全关，其余为中间状态
    if (self.isOn) {
        percentOfOn = _step / 100.0;
    }else {
        percentOfOn = 1 - _step / 100.0;
    }
    [self changePathToRoundButtonWithPercent:percentOfOn];
    
    [self changeRoundButtonPositionWithPercent:percentOfOn];
    
    [self changeBackgroundColorWithPercent:percentOfOn];
    
}

- (void)changePathToRoundButtonWithPercent:(CGFloat)percentOfOn {
    
    CGFloat startPercentOfOn = 0.2;
    if (percentOfOn < startPercentOfOn) {
        percentOfOn = 0;
    }else if (percentOfOn < (1 - startPercentOfOn)){
        percentOfOn = (percentOfOn - startPercentOfOn) / (1 - 2*startPercentOfOn);
    }else {
        percentOfOn = 1;
    }
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGFloat r = self.buttonShapeLayer.bounds.size.width / 2.0;
    CGFloat width = r * 2 * 0.5;
    CGFloat startX = (r * 2 - width)/2.0;
    CGFloat endX = startX;
    CGFloat hookHeadHeight = r / 2 * percentOfOn;
    CGFloat startY = r - hookHeadHeight;
    CGFloat endY = r;
    [path moveToPoint: CGPointMake(startX, startY)];
    [path addLineToPoint:CGPointMake(endX, endY)];
    
    
    startX = endX;
    endX = startX + width;
    [path addLineToPoint:CGPointMake(endX, endY)];
    
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(r * 2 * 0.1 * percentOfOn, 0);
    self.buttonShapeLayer.affineTransform = CGAffineTransformRotate(transform, - M_PI_4 * percentOfOn);
    NSLog(@"percent:%f",percentOfOn);
    
    self.buttonShapeLayer.path = path.CGPath;
    
}

- (void)changeRoundButtonPositionWithPercent:(CGFloat)percentOfOn{
    

    
    CGRect roundButtonFrame = self.roundButton.frame;
    CGFloat border = 2 * LINE_WIDTH;
    CGFloat r = self.bounds.size.height / 2 - border;
    CGFloat startLeftX = border;
    CGFloat distance = (self.bounds.size.width - 2 * border - 2 * r) * percentOfOn;
    roundButtonFrame.origin.x = startLeftX + distance;
    self.roundButton.frame = roundButtonFrame;
}

- (void) changeBackgroundColorWithPercent:(CGFloat)percentOfOn {
    self.backgroundColor = [UIColor colorWithRed:0.8 * (1-percentOfOn) green:0.8 + 0.2 * percentOfOn blue:0.8 * (1-percentOfOn) alpha:1];
    _buttonShapeLayer.strokeColor = self.backgroundColor.CGColor;
}
@end
