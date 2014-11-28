//
//  ViewController.m
//  WovenStar
//
//  Created by Sandy Lee on 10/16/14.
//  Copyright (c) 2014 iaomw. All rights reserved.
//

#import "ViewController.h"

#import "WovenStar.h"

@interface ViewController () {
    
    IBOutlet UISwitch *liveSwitch;

    IBOutlet UISlider *durationSlider;
    
    IBOutlet UISlider *eleWidthSilder;
    IBOutlet UISlider *eleLengthSilder;
    
    WovenStar *ws;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ws = [[WovenStar alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [ws setForeColor:[UIColor colorWithRed:44.0/255 green:72.0/255 blue:108.0/255 alpha:1]
        andBackColor:[UIColor whiteColor]];
    
    [ws setCenter:self.view.center];
    
    [self.view addSubview:ws];
    
    [ws setPaused:NO];
}

- (IBAction)slide:(UISlider*)sender {
    
    if (sender==durationSlider) {
        
        ws.duration = sender.value;
        
    } else if (sender==eleWidthSilder) {
        
        ws.eleWidth = sender.value;
        
    } else if (sender==eleLengthSilder) {
        
        ws.eleLength = sender.value;
    }
}

- (IBAction)liveSwitched:(UISwitch*)sender {
    
    ws.paused = !sender.on;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
