//
//  ViewController.m
//  NavigationAnimationDemo
//
//  Created by numbbuaa on 13-3-8.
//  Copyright (c) 2013年 numbbuaa. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "UINavigationController+TRVSNavigationControllerTransition.h"

@interface ViewController ()

- (void)go2detail;

@end

@implementation ViewController

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
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"首页";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.bounds = CGRectMake(0, 0, 150, 30);
    btn.center = CGPointMake(160, 200);
    [btn setTitle:@"Go to Detail" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(go2detail) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)go2detail
{
    DetailViewController *vc = [[DetailViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController pushViewControllerWithNavigationControllerTransition:vc];
}

@end
