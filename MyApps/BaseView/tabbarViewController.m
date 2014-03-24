//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarViewController.h"
#import "tabbarView.h"
#import "PoTableViewController.h"
#import "PSViewController.h"
#import "PoCollectionViewController.h"
#import "PoMusicTableViewController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345
static tabbarViewController *_tabController = nil;
@interface tabbarViewController ()

@end

@implementation tabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat orginHeight = self.view.frame.size.height- 50;
    if (iPhone5) {
        orginHeight = self.view.frame.size.height- 50 + addHeight;
    }
    _tabbar = [[tabbarView alloc]initWithFrame:CGRectMake(0,  orginHeight, 320, 50)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    

    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-40);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];

}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    PoTableViewController *first = [[PoTableViewController alloc]initWithNibName:nil bundle:nil];
    first.controller = self;
    
    PSViewController *second = [[PSViewController alloc]initWithNibName:nil bundle:nil];
    
    PoCollectionViewController *third =[[PoCollectionViewController alloc] init];
    
    PoMusicTableViewController *four =[[PoMusicTableViewController alloc] init];
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", first, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", second, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", third, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", four, @"viewController",@"主页",@"title", nil],nil];
    return tabBarItems;
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return(toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (tabbarViewController *)sharedInstance{
    if (_tabController == nil) {
        _tabController = [[tabbarViewController alloc] init];
    }
    return _tabController;
}
@end
