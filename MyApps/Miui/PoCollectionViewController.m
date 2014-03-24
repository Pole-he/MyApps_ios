//
//  PoCollectionViewController.m
//  MyApps
//
//  Created by Nathan-he on 14-2-25.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoCollectionViewController.h"
#import "Default.h"
#import "ASIHTTPRequest.h"
#import "PoCollectionCell.h"

//图片浏览
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
NSString *const MJCollectionViewCellIdentifier = @"Cell";

@implementation PoCollectionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(160,143);
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];

    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = UIColorFromRGB(0xe8e8e0);;
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    //[self.collectionView setCollectionViewLayout:flowLayout];
    [self.view addSubview: self.collectionView];
    
    // 1.注册
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[PoCollectionCell class] forCellWithReuseIdentifier:@"Cell1"];
    
    _miuiList = [[NSMutableArray alloc]init];
    
    page = 0;
    // 3.集成刷新控件
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
}

- (void)getData:(PoCollectionViewController *) vc withObject:(MJRefreshBaseView *)refreshView
{
    
    NSString *_url = [self getUrl];
    NSURL *url = [NSURL URLWithString:_url];
    __unsafe_unretained ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        NSArray* arrayResult = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        // NSArray *arrayResult = [dic objectForKey:@""];
        //一下为自定义解析， 自己想怎么干就怎么干
        if(page==0)
        {
            [_miuiList removeAllObjects];
            
        }
        [_miuiList addObjectsFromArray:arrayResult];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        //        int h = [[UIScreen mainScreen] bounds].size.height;
        //        int w = [[UIScreen mainScreen] bounds].size.width;
        //        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        //        [tableView setDelegate:self];
        //        [tableView setDataSource:self];
        //        [self.view addSubview: tableView];
        
    }];
    [request setFailedBlock:^{
       // NSError *error = [request error];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
    }];
    [request startAsynchronous];
}

- (void)addFooter
{
    __unsafe_unretained PoCollectionViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        page = page +40;
        [self getData:vc withObject:refreshView];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        //        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained PoCollectionViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectionView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        page=0;
        [self getData:vc withObject:refreshView];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        //        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                //切换到：普通状态
                break;
                
            case MJRefreshStatePulling:
                //切换到：松开即可刷新的状态
                break;
                
            case MJRefreshStateRefreshing:
                //切换到：正在刷新状态
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell1";
    static BOOL isRegNib = NO;
    if (!isRegNib) {
        [collectionView registerNib:[UINib nibWithNibName:@"PoCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        isRegNib = YES;
    }
    PoCollectionCell *cell = (PoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *first =[_miuiList[indexPath.row] objectForKey:@"downloadUrlRoot"];
    NSString *second=[_miuiList[indexPath.row] objectForKey:@"desktopLocator"];
    NSString *new = [NSString stringWithFormat:@"%@jpeg/w320q80/%@",first,second];// 图片的url
    [cell setPic:new];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _miuiList.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self tapImage:collectionView withIndex:indexPath];

}
//定义每个UICollectionView 的 margin

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//
//{
//    
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//    
//}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectionView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

-(NSString *) getUrl
{
    NSString *url=[NSString stringWithFormat:@"http://market.xiaomi.com/thm/millionwp/items?offset=%d&len=40",page];
    return url;
}

- (void)tapImage:(UICollectionView *) view withIndex:(NSIndexPath *) index
{
    int count = _miuiList.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *first =[_miuiList[i] objectForKey:@"downloadUrlRoot"];
        NSString *second=[_miuiList[i] objectForKey:@"lockscreenLocator"];
        NSString *url = [NSString stringWithFormat:@"%@jpeg/w640q80/%@",first,second];// 图片的url
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        if(i==index.row)
        photo.srcImageView =((PoCollectionCell *)[view cellForItemAtIndexPath:index]).imageView1;// 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
@end
