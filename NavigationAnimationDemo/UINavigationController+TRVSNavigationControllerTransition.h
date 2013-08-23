//
//  UINavigationController+TRVSNavigationControllerTranslation.h
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TRVSNavigationControllerTransition)

- (void)pushViewControllerWithNavigationControllerTransition:(UIViewController *)viewController;

- (void)popViewControllerWithNavigationControllerTransition;

/**
 *	@brief	push到下一级页面（带navbar和tabbar的动画）
 *
 *	@param 	viewController 	下一级页面的视图控制器
 */
- (void)pushViewControllerWithNavigationControllerTransitionAndBarAnimation:(UIViewController *)viewController;

/**
 *	@brief	pop到上一级页面（带导航条动画）
 */
- (void)popViewControllerWithNavigationControllerTransitionAndBarAnimation;

@end
