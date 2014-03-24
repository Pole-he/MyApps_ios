//
//  PoMoviePlayerViewController.m
//  MyApps
//
//  Created by Nathan-he on 14-2-20.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoMoviePlayerViewController.h"

@interface PoMoviePlayerViewController ()

@end

@implementation PoMoviePlayerViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
}

@end
