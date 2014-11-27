//
//  WovenStar.m
//  WovenStar
//
//  Created by Sandy Lee on 10/16/14.
//  Copyright (c) 2014 iaomw. All rights reserved.
//

#define OuterRange (2*M_PI/3)
#define InnerRange (M_PI/3)

#import "WovenStar.h"

@interface WovenStar ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (strong, nonatomic) UIColor *foreColor;

@property (assign, nonatomic) CGFloat innerBaseAngle;
@property (assign, nonatomic) CGFloat outerBaseAngle;

@property (assign, nonatomic) CGFloat initialRadius;

@property (assign, nonatomic) CGFloat innerRadius;
@property (assign, nonatomic) CGFloat outerRadius;

@property (nonatomic, assign) CGFloat ratio;

@end

@implementation WovenStar

@synthesize eleLength = _eleLength;

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
        
        return 4;
    }
    
    return _duration;
}

- (UIColor*)foreColor {
    
    if (!_foreColor) {
        
        _foreColor = [UIColor whiteColor];
    }
    
    return _foreColor;
}

- (void)setEleLength:(CGFloat)eleLength {
    
    _eleLength = eleLength;
    
    _initialRadius = 0;
}

- (CGFloat)eleLength {
    
    if (!_eleLength) {
        
        _eleLength = 64;
    }
    
    return _eleLength;
}

- (CGFloat)eleWidth {
    
    if (!_eleWidth) {
        
        _eleWidth = 8;
    }
    
    return _eleWidth;
}

- (CGFloat)outerBaseAngle {
    
    if (!_outerBaseAngle) {
        
        _outerBaseAngle = (M_PI/12);
    }
    
    return _outerBaseAngle;
}

- (CGFloat)innerBaseAngle {
    
    if (!_innerBaseAngle) {
        
        _innerBaseAngle = self.outerBaseAngle+(M_PI/2);
    }
    
    return _innerBaseAngle;
}

- (CGFloat)initialRadius {
    
    if (!_initialRadius) {
        
        _initialRadius = self.eleLength*M_SQRT1_2;
    }
    
    return _initialRadius;
}

- (CGFloat)outerRadius {

    if (!_outerRadius) {
        
        _outerRadius = self.initialRadius;
    }
    
    return _outerRadius;
}

- (CGFloat)innerRadius {
    
    if (!_innerRadius) {
        
        _innerRadius = self.initialRadius;
    }
    
    return _innerRadius;
}

# pragma mark - Animation

- (void)update:(CADisplayLink *)displayLink
{
    NSTimeInterval duration = displayLink.duration;
    
    CGFloat ratio = duration/self.duration;
    
        self.ratio += ratio;
    
    if (self.ratio>1) {
        
        self.ratio -= 1;
        
//        self.outerBaseAngle = 0;
//        self.innerBaseAngle = 0;
        
        CGFloat temporary = self.outerBaseAngle;
        self.outerBaseAngle = self.innerBaseAngle;
        
        self.innerBaseAngle = temporary;
    }
    
    self.outerBaseAngle += ratio*OuterRange;
    self.innerBaseAngle -= ratio*InnerRange;
    
    CGFloat wave = sin(self.ratio*(M_PI));
    
    self.innerRadius = self.initialRadius*(1-wave) + wave*self.eleWidth/(2*cos(M_PI*5/12));

    CGFloat differ = fabsf(self.innerBaseAngle - self.outerBaseAngle);
    
    CGFloat hh = sin(differ)*self.innerRadius;
    
    CGFloat oo = sqrt(pow(self.eleLength, 2)-pow(hh, 2));
    CGFloat ii = cos(differ)*self.innerRadius;
    
    self.outerRadius = oo+ii;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat scale = self.contentScaleFactor;
    CGPoint center = CGPointMake(width/2, height/2);
    
    CGFloat innerAngle = self.innerBaseAngle; //+ M_PI*(i/6.0);
    CGSize innerDelta = CGSizeMake(self.innerRadius*cos(innerAngle), self.innerRadius*sin(innerAngle));
    CGPoint innerPoint = CGPointMake(center.x+innerDelta.width, center.y+innerDelta.height);
    CGFloat outerAngle = self.outerBaseAngle; //+ M_PI*(i/6.0);
    CGSize outerDelta = CGSizeMake(self.outerRadius*cos(outerAngle), self.outerRadius*sin(outerAngle));
    CGPoint outerPoint = CGPointMake(center.x+outerDelta.width, center.y+outerDelta.height);
    
    CGMutablePathRef rawPath = CGPathCreateMutable();
    CGPathMoveToPoint(rawPath, nil, innerPoint.x, innerPoint.y);
    CGPathAddLineToPoint(rawPath, nil, outerPoint.x, outerPoint.y);
    
    CGPoint lineCenter = CGPointMake((innerPoint.x+outerPoint.x)/2, (innerPoint.y+outerPoint.y)/2);
    
    CGVector entadVector = CGVectorMake(center.x-lineCenter.x, center.y-lineCenter.y);
    
    CGFloat entadLength = sqrt(pow(entadVector.dx, 2)+pow(entadVector.dy, 2));
    CGFloat entadSin = entadVector.dy/entadLength;
    CGFloat entadCos = entadVector.dx/entadLength;
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(entadCos*self.eleWidth/2,
                                                               entadSin*self.eleWidth/2);
    
    CGPathRef cookedPath = CGPathCreateCopyByStrokingPath(rawPath, &trans, self.eleWidth,
                                                          kCGLineCapButt, kCGLineJoinBevel, 1);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    [self.foreColor setFill];
    [self.backgroundColor setStroke];
    
    CGContextSetLineWidth(contextRef, 1);
    
    CGRect lastBox, midBox;
    
    for (int i = 0; i < 12; i++) {
        
        CGPathRef rotatedPath = createPathRotatedAroundCenter(cookedPath, center, M_PI*(i/6.0));
        
        lastBox = CGPathGetPathBoundingBox(rotatedPath);
        
        if ( i==5 ) { midBox = CGPathGetPathBoundingBox(rotatedPath); }
        if ( i==11 ) { lastBox = CGPathGetPathBoundingBox(rotatedPath); }
        
        CGContextAddPath(contextRef, rotatedPath);
        CGContextDrawPath(contextRef, kCGPathFillStroke);
        
        CGPathRelease(rotatedPath);
    }
    
    CGPathRelease(rawPath);
    CGPathRelease(cookedPath);
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *cropped = [self imageByCropping:snapshot toRect:midBox];
    
    UIGraphicsEndImageContext();
    
    contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(contextRef);
    
    [snapshot drawInRect:rect];
    
    CGContextTranslateCTM(contextRef, center.x, center.y);
    CGContextScaleCTM(contextRef, -1, -1);
    CGContextTranslateCTM(contextRef, -center.x, -center.y);
    
    [cropped drawInRect:midBox];
    
    [[UIColor colorWithWhite:.4 alpha:.4] setFill];
    CGContextFillRect(contextRef, midBox);
    
    CGContextRestoreGState(contextRef);
}

- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
    
    CGFloat scale = self.contentScaleFactor;
    
    rect.origin.x*=scale; rect.origin.y*=scale;
    rect.size.width*=scale; rect.size.height*=scale;
    
//    CGRect scaledRect = CGRectMake(rect.origin.x*scale, rect.origin.y*scale,
//                                   rect.size.width*scale, rect.size.height*scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return cropped;
}

//http://stackoverflow.com/questions/13738364/rotate-cgpath-without-changing-its-position

static CGPathRef createPathRotatedAroundCenter(CGPathRef path, CGPoint center, CGFloat radians) {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, radians);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateMutableCopyByTransformingPath(path, &transform);
}

@end
