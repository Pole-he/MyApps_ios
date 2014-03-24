//
//  PoPlayVideoViewViewController.m
//  MyApps
//
//  Created by Nathan-he on 14-2-20.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoPlayVideoViewViewController.h"
@interface PoPlayVideoViewViewController ()
@end

@implementation PoPlayVideoViewViewController
@synthesize url;
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
    
    
    NSURL *myURL = [[NSURL alloc] initWithString:url];
    [self playMovieAtURL:myURL];
//    NSLog(url);
//    url = [url stringByReplacingOccurrencesOfString:@"type//" withString:[NSString stringWithFormat:@"type/hd2/ts/%@/useKeyframe/0/", [self getDate]]];
//    NSLog(url);
//    self.moviePlayer = [[PoMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
//    
//    self.moviePlayer.movieSourceType=MPMovieSourceTypeStreaming;//网络文件要设置为stream
//    
//    [self.moviePlayer play];
//    
//    self.moviePlayer.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [self.view addSubview:self.moviePlayer.view];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}
-(void)playMovieAtURL:(NSURL*)theURL
{
    playerView = [[PoMoviePlayerViewController alloc] initWithContentURL:theURL];
    playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.movieSourceType=MPMovieSourceTypeStreaming;//网络文件要设置为stream
    [self.view addSubview:playerView.view];
     [playerView.moviePlayer play];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//    self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5);
//    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerView.moviePlayer];
   
    [self presentMoviePlayerViewControllerAnimated:playerView];
}

// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{

    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [self dismissModalViewControllerAnimated:YES];
}

//-(void)videoPlayBackDidFinish:(NSNotification*)notification  {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self.moviePlayer stop];
//    self.moviePlayer = nil;
//    NSLog(@"走进来了");
//    [self dismissMoviePlayerViewControllerAnimated];
//    [self dismissModalViewControllerAnimated:YES];
//}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}



//当前时间和70年时间比对获取10位数字
- (NSString *)getDate
{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];//取当前时间值
    long long int date = (long long int)time;//转成long long
    NSString *date10=[NSString stringWithFormat:@"%lld",date/1000];//输出当前时间值
    
    return @"1392881084";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return YES;
//}
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    [self performSelector:@selector(fixStatusBar) withObject:nil afterDelay:0];
//}
//
//- (void)fixStatusBar {
//    [[UIApplication sharedApplication] setStatusBarOrientation:[self interfaceOrientation] animated:NO];
//}
@end
