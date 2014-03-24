//
//  PoTableViewHeader.m
//  MyApps
//
//  Created by Nathan-he on 14-2-20.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoTableViewHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation PoTableViewHeader

- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code

        
        [self configUserInterface];
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        
        
    }
    
    return self;
    
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
   // [_timer setFireDate:[NSDate distantPast]];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}


-(void)configAdvert:(NSArray *)imgArray

{
    [self AdImg:imgArray];
    [self setCurrentPage:_PageControl.currentPage];
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)configUserInterface{
    
    
    _sv=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 177)];
    
    _sv.delegate=self;
    
    _sv.showsHorizontalScrollIndicator=NO;
    
    _sv.showsVerticalScrollIndicator=NO;
    
    _sv.pagingEnabled=YES;
    
    [self addSubview:_sv ];
    
    
    
    _PageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(320/2-15, _sv.frame.size.height-23 , 30, 30)];
    
    [self addSubview:_PageControl ];
    
    
    
    
    
    
}

-(void)AdImg:(NSArray*)arr{
    
    [_sv setContentSize:CGSizeMake(320*[arr count], 144)];
    
    _PageControl.numberOfPages=[arr count];
    
    
    
    for ( int i=0; i<[arr count]; i++) {
        
        NSString *url=[arr objectAtIndex:i];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 177)];
        
        // [img addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
        
        [_sv addSubview:img];
        [img setImageWithURL:url];
        //[img setImage:[UIImage imageNamed:@"jiazai_test@2x.png"] forState:UIControlStateNormal];
        
//        UIImageFromURL( [NSURL URLWithString:url], ^( UIImage * image )
//                       
//                       {
//                           
//                           [img setBackgroundImage:image forState:UIControlStateNormal];
//                           
//                       }, ^(void){
//                           
//                       });
        
    }
    
    
    
}


void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )

{
    
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   
                   {
                       
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           
                           if( image != nil )
                               
                           {
                               
                               imageBlock( image );
                               
                           } else {
                               
                               errorBlock();
                               
                           }
                           
                       });
                       
                   });
    
}

#pragma mark - 5秒换图片

- (void) handleTimer: (NSTimer *) timer

{
    
    if (TimeNum % 5 == 0 ) {
        
        
        
        if (!Tend) {
            
            _PageControl.currentPage++;
            
            if (_PageControl.currentPage==_PageControl.numberOfPages-1) {
                
                Tend=YES;
                
            }
            
        }else{
            
            _PageControl.currentPage--;
            
            if (_PageControl.currentPage==0) {
                
                Tend=NO;
                
            }
            
        }
        
        
        
        [UIView animateWithDuration:0.8 //速度0.7秒
         
                         animations:^{//修改坐标
                             
                             _sv.contentOffset = CGPointMake(_PageControl.currentPage*320,0);
                             
                         }];
        
        
        
        
        
    }
    
    TimeNum ++;
    
}


#pragma mark - scrollView && page

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _PageControl.currentPage=scrollView.contentOffset.x/320;
    
    [self setCurrentPage:_PageControl.currentPage];
    
    
    
    
    
}

- (void) setCurrentPage:(NSInteger)secondPage {
    
    
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [_PageControl.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [_PageControl.subviews objectAtIndex:subviewIndex];
        
        //这里犯了一个小错误，如果不加类型判断的话会报错找不到setimage方法的错，所以一定要
        
       // 判断是uiview还是uiimageview
        
        if ([subview isKindOfClass:[UIImageView class]]) {
            
            CGSize size;
            
            size.height = 12/2;
            
            size.width = 12/2;
            
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                         
                                         size.width,size.height)];
            
            if (subviewIndex == secondPage)
                
                [subview setImage:[UIImage imageNamed:@"a.png"]];
            
            else
                
                [subview setImage:[UIImage imageNamed:@"d.png"]];
            
        }
        
        
        
        
        
    }
    
}

@end
