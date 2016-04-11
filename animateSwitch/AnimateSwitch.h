//
//  AnimateSwitch.h
//  animateSwitch
//
//  Created by Realank on 16/4/11.
//  Copyright © 2016年 realank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock_T)(BOOL isOn);

@interface AnimateSwitch : UIView

@property (nonatomic, assign, getter=isOn) BOOL on;

- (instancetype)initWithFrame:(CGRect)frame andActionBlock:(ActionBlock_T)actionBlock;

@end
