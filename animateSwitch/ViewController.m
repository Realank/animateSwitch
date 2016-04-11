//
//  ViewController.m
//  animateSwitch
//
//  Created by Realank on 16/4/11.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"
#import "AnimateSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AnimateSwitch *mySwitch1 = [[AnimateSwitch alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    [self.view addSubview:mySwitch1];
    
    AnimateSwitch *mySwitch2 = [[AnimateSwitch alloc]initWithFrame:CGRectMake(100, 300, 100, 50)];
    [self.view addSubview:mySwitch2];
    
    AnimateSwitch *mySwitch3 = [[AnimateSwitch alloc]initWithFrame:CGRectMake(100, 500, 50, 25)];
    [self.view addSubview:mySwitch3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
