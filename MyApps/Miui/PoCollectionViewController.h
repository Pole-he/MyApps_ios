//
//  PoCollectionViewController.h
//  MyApps
//
//  Created by Nathan-he on 14-2-25.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface PoCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger page;
    NSMutableArray *_miuiList;
}

@property (retain , nonatomic) UICollectionView *collectionView;
@end
