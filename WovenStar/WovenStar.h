//
//  WovenStar.h
//  WovenStar
//
//  Created by Sandy Lee on 10/16/14.
//  Copyright (c) 2014 iaomw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WovenStar : UIView

@property (getter=isPaused, nonatomic) BOOL paused;

@property (assign, nonatomic) CGFloat duration;

@property (assign, nonatomic) CGFloat eleLength;
@property (assign, nonatomic) CGFloat eleWidth;

- (void)setForeColor:(UIColor *)foreColor andBackColor:(UIColor*)backColor;

@end
