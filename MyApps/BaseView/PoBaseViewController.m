//
//  PoBaseViewController.m
//  MyApps
//
//  Created by Nathan-he on 14-2-21.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoBaseViewController.h"
#import "PSViewController.h"
#import "PoTableViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
@interface PoBaseViewController ()

@property (nonatomic, strong) PoTableViewController *oneView;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end


@implementation PoBaseViewController

@synthesize oneView = _oneView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x067AB5); // 修改背景颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger"] style:UIBarButtonItemStyleDone target:self action:@selector(onBurger:)];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
}

- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"star"],
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"star"],
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"star"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    [sidebar dismiss];
//    switch (index) {
//        case 0:
//            PoTableViewController *oneViewController = [[PoTableViewController alloc] init];
//            // secondViewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:oneViewController];
//            [self setRootViewController:navigationController];
//            break;
//        case 1:
//            PSViewController *secondViewController = [[PSViewController alloc] init];
//            // secondViewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
//            [self setRootViewController:navigationController];
//            break;
//        default:
//            break;
//    }
    if(index==0)
    {
        
        PoTableViewController *secondViewController = [[PoTableViewController alloc] init];
        // secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [self setRootViewController:navigationController];
    }
    if (index == 3) {
       
        PSViewController *secondViewController = [[PSViewController alloc] init];
       // secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [self setRootViewController:navigationController];
    }
     [sidebar dismiss];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

- (void)setRootViewController:(UIViewController *)viewController
{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = viewController;

}
@end
