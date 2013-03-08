//
//  DetailViewController.m
//  NavigationAnimationDemo
//
//  Created by numbbuaa on 13-3-8.
//  Copyright (c) 2013年 numbbuaa. All rights reserved.
//

#import "DetailViewController.h"
#import "UINavigationController+TRVSNavigationControllerTransition.h"

@interface DetailViewController ()

- (void)back;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.bounds = CGRectMake(0, 0, 150, 30);
    btn.center = CGPointMake(160, 200);
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController popViewControllerWithNavigationControllerTransition];
}

@end
