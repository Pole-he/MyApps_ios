//
//  PoDetailMoreViewController.m
//  MyApps
//
//  Created by Nathan-he on 14-3-5.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoDetailMoreViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PoAnimeTasteItem.h"

@interface PoDetailMoreViewController ()

@end

@implementation PoDetailMoreViewController


-(void)layoutSubviews
{
    [self.ivPlayMore setImageWithURL:[NSURL URLWithString:_data.HomePic]];
    [self.titleMore setText:_data.Name];
    [self.contentMore setText:_data.Brief];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
}

-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
    if(_detailView!=nil)
    {
        PoAnimeTasteDetailController *parentController =  _detailView.parentViewController;
        

        
        
        [_detailView dismissViewControllerAnimated:NO completion:^{
            PoAnimeTasteDetailController *detail = [[PoAnimeTasteDetailController alloc] initWithNibName:@"PoAnimeTasteDetailController" bundle:[NSBundle mainBundle]];
            detail.item = _data;
            detail.controller=_detailView.controller;
            UINavigationController *navigationController=[[UINavigationController alloc]init];
            [navigationController pushViewController:detail animated:NO];
//            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [_detailView.controller presentModalViewController:navigationController animated:YES ];
           
      } ];
    }
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
