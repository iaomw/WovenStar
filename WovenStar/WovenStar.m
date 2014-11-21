//
//  WovenStar.m
//  WovenStar
//
//  Created by Sandy Lee on 10/16/14.
//  Copyright (c) 2014 iaomw. All rights reserved.
//

#import "WovenStar.h"

#define Range M_PI+M_PI/3

@interface WovenStar ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (strong, nonatomic) UIColor *foreColor;

@property (assign, nonatomic) CGFloat innerBaseAngle;
@property (assign, nonatomic) CGFloat outerBaseAngle;

@property (assign, nonatomic) CGFloat innerRadius;
@property (assign, nonatomic) CGFloat outerRadius;

@property (nonatomic, assign) CGFloat ratio;

@end

@implementation WovenStar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {}
    
    return self;
}

- (void)setForeColor:(UIColor *)foreColor andBackColor:(UIColor*)backColor {
    
    self.foreColor = foreColor;
    
    self.backgroundColor = backColor;
}

# pragma mark - Getter&Setter

- (CGFloat)innerBaseAngle {
    
    if (!_innerBaseAngle) {
        
        _innerBaseAngle = (M_PI/12)+(M_PI/2);
    }
    
    return _innerBaseAngle;
}



- (CGFloat)outerBaseAngle {
    
    if (!_outerBaseAngle) {
        
        _outerBaseAngle = (M_PI/12);
    }
    
    return _outerBaseAngle;
}

- (void)setPaused:(BOOL)paused {
    
    [self.displayLink setPaused:paused];
}

- (CADisplayLink*)displayLink {
    
    if (!_displayLink) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return _displayLink;
}

- (CGFloat)duration {
    
    if (!_duration) {
        
        return 2.2;
    }
    
    return _duration;
}

- (UIColor*)foreColor {
    
    if (!_foreColor) {
        
        _foreColor = [UIColor whiteColor];
    }
    
    return _foreColor;
}

- (CGFloat)sideLength {
    
    if (!_sideLength) {
        
        _sideLength = 64;
    }
    
    return _sideLength;
}

# pragma mark - Animation

- (void)update:(CADisplayLink *)displayLink
{
    NSTimeInterval duration = displayLink.duration;
    
    CGFloat ratio = duration/self.duration;
    
        self.ratio += ratio;
    
    if (self.ratio>1) {
        
        self.ratio = ratio;
        
        self.innerBaseAngle = 0;
        self.outerBaseAngle = 0;
    }
    
    CGFloat rotateDelta = Range*ratio;
    
    self.innerBaseAngle += rotateDelta;
    self.outerBaseAngle -= rotateDelta;
    
    CGFloat wave = sin(self.ratio*(2*M_PI));

    self.innerRadius = self.sideLength*pow(2, 1.0/2)/2 + (1-wave)*self.sideLength/2;
    self.outerRadius = self.sideLength*pow(2, 1.0/2)/2 + wave*self.sideLength/2;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGPoint center = CGPointMake(width/2, height/2);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(contextRef);
    CGContextClearRect(contextRef, rect);
    
    CGContextSetLineWidth(contextRef, 4);
    
    CGContextAddArc(contextRef, center.x, center.y, 4, 0, M_PI*2, YES);
    
    for (int i =0; i<12; i++) {
        
        CGFloat angle = self.innerBaseAngle + M_PI*(i/6.0);
        
        CGSize delta = CGSizeMake(self.outerRadius*cos(angle), self.outerRadius*sin(angle));
        
        CGContextMoveToPoint(contextRef, center.x+delta.width, center.y-delta.height);
        
        angle = self.outerBaseAngle + M_PI*(i/6.0);
        
        delta = CGSizeMake(self.innerRadius*cos(angle), self.innerRadius*sin(angle));
        
        CGContextAddLineToPoint(contextRef, center.x+delta.width, center.y-delta.height);
        
        UIColor *color = [UIColor colorWithRed:(1.0/i) green:1 blue:1.0/i alpha:0.7];
        
        CGContextSetStrokeColorWithColor(contextRef, color.CGColor);
        
        CGContextStrokePath(contextRef);
    }
    
    CGContextRestoreGState(contextRef);
}

@end
