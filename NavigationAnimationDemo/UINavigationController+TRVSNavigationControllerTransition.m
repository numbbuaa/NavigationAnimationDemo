//
//  UINavigationController+TRVSNavigationControllerTranslation.m
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+TRVSNavigationControllerTransition.h"

#define W   ([UIScreen mainScreen].bounds.size.width)
#define H   ([UIScreen mainScreen].bounds.size.height - 20)
#define HEIGHT_OF_NAVBAR 46
#define HEIGHT_OF_TABBAR 49

static CALayer *kTRVSCurrentLayer = nil;
static CALayer *kTRVSNextLayer = nil;
static CALayer *kTRVSNavBarLayer = nil;
static CALayer *KTRVSContainerLayer = nil;
static CALayer *kTRVSTabBarLayer = nil;
static NSTimeInterval const kTransitionDuration = 0.3f;

@interface TRVSNavigationControllerTransitionAnimiationDelegate : NSObject
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
+ (TRVSNavigationControllerTransitionAnimiationDelegate *)sharedDelegate;
@end

@implementation TRVSNavigationControllerTransitionAnimiationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    [kTRVSCurrentLayer removeFromSuperlayer];
    kTRVSCurrentLayer = nil;
    [kTRVSNextLayer removeFromSuperlayer];
    kTRVSNextLayer = nil;
    [kTRVSNavBarLayer removeFromSuperlayer];
    kTRVSNavBarLayer = nil;
    [KTRVSContainerLayer removeFromSuperlayer];
    KTRVSContainerLayer = nil;
    [kTRVSTabBarLayer removeFromSuperlayer];
    kTRVSTabBarLayer = nil;
}

+ (TRVSNavigationControllerTransitionAnimiationDelegate *)sharedDelegate
{
    static dispatch_once_t onceToken;
    __strong static id _sharedDelegate = nil;
    dispatch_once(&onceToken, ^{
        _sharedDelegate = [[self alloc] init];
    });
    return _sharedDelegate;
}

@end


@implementation UINavigationController (TRVSNavigationControllerTransition)

- (void)pushViewControllerWithNavigationControllerTransition:(UIViewController *)viewController
{
    kTRVSCurrentLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    
    [self pushViewController:viewController animated:NO];
    
    kTRVSNextLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    kTRVSNextLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kTRVSCurrentLayer];
    [self.view.layer addSublayer:kTRVSNextLayer];
    
    [CATransaction flush];
    
    [kTRVSCurrentLayer addAnimation:[self _animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kTRVSNextLayer addAnimation:[self _animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
}

- (void)popViewControllerWithNavigationControllerTransition
{
    kTRVSCurrentLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    
    [self popViewControllerAnimated:NO];
    
    kTRVSNextLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    kTRVSNextLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kTRVSCurrentLayer];
    [self.view.layer addSublayer:kTRVSNextLayer];
    
    [CATransaction flush];
    
    [kTRVSCurrentLayer addAnimation:[self _animationWithTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kTRVSNextLayer addAnimation:[self _animationWithTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
}

- (void)pushViewControllerWithNavigationControllerTransitionAndBarAnimation:(UIViewController *)viewController
{
    kTRVSCurrentLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    
    [self pushViewController:viewController animated:NO];
    
    kTRVSNavBarLayer = [self _navbarLayerSnapshotWithTransform:CATransform3DIdentity];
    kTRVSNavBarLayer.frame = CGRectMake(0, -HEIGHT_OF_NAVBAR, W, HEIGHT_OF_NAVBAR);
    kTRVSTabBarLayer = [self _tabbarLayerSnapshotWithTransform:CATransform3DIdentity];
    kTRVSTabBarLayer.frame = CGRectMake(0, H, W, HEIGHT_OF_TABBAR);
    
    kTRVSNextLayer = [self _nextLayerSnapshotCurWithTransform:CATransform3DIdentity];
    kTRVSNextLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kTRVSCurrentLayer];
    [self.view.layer addSublayer:kTRVSNextLayer];
    [self.view.layer addSublayer:kTRVSNavBarLayer];
    [self.view.layer addSublayer:kTRVSTabBarLayer];
    
    [CATransaction flush];
    
    [kTRVSCurrentLayer addAnimation:[self _animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kTRVSNextLayer addAnimation:[self _animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kTRVSNavBarLayer addAnimation:[self _animationNavbarWithTranslation:-HEIGHT_OF_NAVBAR] forKey:nil];
    [kTRVSTabBarLayer addAnimation:[self _animationNavbarWithTranslation:HEIGHT_OF_TABBAR] forKey:nil];
}

- (void)popViewControllerWithNavigationControllerTransitionAndNavbarAnimation
{
    kTRVSCurrentLayer = [self _currentLayerSnapshotWithTransform:CATransform3DIdentity];
    kTRVSNavBarLayer = [self _navbarLayerSnapshotWithTransform:CATransform3DIdentity];
    kTRVSTabBarLayer = [self _tabbarLayerSnapshotWithTransform:CATransform3DIdentity];
    
    [self popViewControllerAnimated:NO];
    
    kTRVSNextLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    //    kTRVSNextLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    kTRVSNextLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, W, H};
    
    KTRVSContainerLayer = [CALayer layer];
    KTRVSContainerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    KTRVSContainerLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:KTRVSContainerLayer];
    [self.view.layer addSublayer:kTRVSCurrentLayer];
    [self.view.layer addSublayer:kTRVSNextLayer];
    [self.view.layer addSublayer:kTRVSNavBarLayer];
    [self.view.layer addSublayer:kTRVSTabBarLayer];
    
    [CATransaction flush];
    
    [kTRVSCurrentLayer addAnimation:[self _animationWithTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kTRVSNextLayer addAnimation:[self _animationWithTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kTRVSNavBarLayer addAnimation:[self _animationNavbarWithTranslation:HEIGHT_OF_NAVBAR] forKey:nil];
    [kTRVSTabBarLayer addAnimation:[self _animationNavbarWithTranslation:-HEIGHT_OF_TABBAR] forKey:nil];
}

- (CABasicAnimation *)_animationWithTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, translation, 0.f, 0.f)];
    animation.duration = kTransitionDuration;
    animation.delegate = [TRVSNavigationControllerTransitionAnimiationDelegate sharedDelegate];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)_animationNavbarWithTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, 0.f, -translation, 0.f)];
    animation.duration = kTransitionDuration;
    animation.delegate = [TRVSNavigationControllerTransitionAnimiationDelegate sharedDelegate];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CALayer *)_layerSnapshotWithTransform:(CATransform3D)transform
{
	if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
	else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
	
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    CALayer *snapshotLayer = [CALayer layer];
	snapshotLayer.transform = transform;
    snapshotLayer.anchorPoint = CGPointMake(1.f, 1.f);
    snapshotLayer.frame = self.view.bounds;
	snapshotLayer.contents = (id)snapshot.CGImage;
    return snapshotLayer;
}

- (CALayer *)_layerSnapshotWithTransform:(CATransform3D)transform ImageInRect:(CGRect)rect
{
    if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
	else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
	
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    UIImage *imageInRect = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(snapshot.CGImage, rect)];
	
    CALayer *snapshotLayer = [CALayer layer];
	snapshotLayer.transform = transform;
    snapshotLayer.anchorPoint = CGPointMake(1.f, 1.f);
    snapshotLayer.frame = rect;
	snapshotLayer.contents = (id)imageInRect.CGImage;
    return snapshotLayer;
    
}

- (CALayer *)_currentLayerSnapshotWithTransform:(CATransform3D)transform
{
    return [self _layerSnapshotWithTransform:transform ImageInRect:CGRectMake(0, HEIGHT_OF_NAVBAR, W, H - HEIGHT_OF_NAVBAR - HEIGHT_OF_TABBAR)];
}

- (CALayer *)_nextLayerSnapshotCurWithTransform:(CATransform3D)transform
{
    return [self _layerSnapshotWithTransform:transform ImageInRect:CGRectMake(0, HEIGHT_OF_NAVBAR, W, H - HEIGHT_OF_NAVBAR - HEIGHT_OF_TABBAR)];
}


- (CALayer *)_navbarLayerSnapshotWithTransform:(CATransform3D)transform
{
    return [self _layerSnapshotWithTransform:transform ImageInRect:CGRectMake(0, 0, W, HEIGHT_OF_NAVBAR)];
}

- (CALayer *)_tabbarLayerSnapshotWithTransform:(CATransform3D)transform
{
    return [self _layerSnapshotWithTransform:transform ImageInRect:CGRectMake(0, H - HEIGHT_OF_TABBAR, W, HEIGHT_OF_TABBAR)];
}

@end
