//
//  ViewController.m
//  WovenStar
//
//  Created by Sandy Lee on 10/16/14.
//  Copyright (c) 2014 iaomw. All rights reserved.
//

#import "ViewController.h"

#import "WovenStar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    WovenStar *ws = [[WovenStar alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [ws setPaused:NO];
    
    [ws setCenter:self.view.center];
    
    [self.view addSubview:ws];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
