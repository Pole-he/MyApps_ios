//
//  PoSplastController.m
//  MyApps
//
//  Created by Nathan-he on 14-3-4.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoSplastController.h"
#import "Default.h"
#import "tabbarViewController.h"
@interface PoSplastController ()

@end

@implementation PoSplastController

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
    
    UIImage *lauchImg = nil;
    if (iPhone5) {
        lauchImg = [UIImage imageNamed:@"Default-568h-blur@2x.png"];
    } else {
        lauchImg = [UIImage imageNamed:@"Default-blur@2x.png"];
    }
    UIImageView *bgView = [[UIImageView alloc] initWithImage:lauchImg];
    [self.view addSubview:bgView];
    [bgView setFrame:self.view.bounds];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [self.view addSubview:label];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(lauchingTimeOver:) userInfo:nil repeats:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lauchingTimeOver:(NSTimer *)timer{
    
    //判断是否第一次启动,是否需要引导界面
    
    BOOL isFirstLauching = NO;
    
    
    
    if (isFirstLauching) {
        
    } else {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            
            __weak tabbarViewController *menuTab = [tabbarViewController sharedInstance];
            [self presentViewController:menuTab animated:YES completion:nil];
        }];
        
    }
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
@end
