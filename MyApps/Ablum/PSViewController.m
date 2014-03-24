//
//  PSViewController.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSViewController.h"
#import "PSBroView.h"
#import "MJRefresh.h"
#import "ASIHTTPRequest.h"
#import "CommonCrypto/CommonDigest.h"
#import "Default.h"
//图片浏览
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
//static BOOL isDeviceIPad() {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        return YES;
//    }
//#endif
//    return NO;
//}

@interface PSViewController ()

{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) PSCollectionView *collectionView;

@end

@implementation PSViewController

@synthesize
items = _items,
collectionView = _collectionView;

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    
    self.collectionView = nil;
}

- (void)getData:(PSViewController *) vc withObject:(MJRefreshBaseView *)refreshView
{
    
    NSString *_url = [self getUrl];
    NSURL *url = [NSURL URLWithString:_url];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        //一下为自定义解析， 自己想怎么干就怎么干
        if(page==0)
        {
            [self.items removeAllObjects];
            
        }
        [self.items addObjectsFromArray: [[dic objectForKey:@"data"] objectForKey:@"pictures"]];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
    }];
    [request startAsynchronous];
}

- (void)addFooter
{
    __unsafe_unretained PSViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        page = page +20;
        [self getData:vc withObject:refreshView];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        //        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained PSViewController *vc = self;
    
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
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectionView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    
    self.collectionView = nil;
    self.items = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe8e8e0);;
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.collectionView];
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.numColsPortrait = 2;
    self.collectionView.numColsLandscape = 3;
    
    page = 0;
    // 3.集成刷新控件
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
    //    if (isDeviceIPad()) {
    //        self.collectionView.numColsPortrait = 4;
    //        self.collectionView.numColsLandscape = 5;
    //    } else {
    //        self.collectionView.numColsPortrait = 2;
    //        self.collectionView.numColsLandscape = 3;
    //    }
    
    //    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    //    loadingLabel.text = @"Loading...";
    //    loadingLabel.textAlignment = UITextAlignmentCenter;
    //    self.collectionView.loadingView = loadingLabel;
    
    // [self loadDataSource];
    
}

- (void)loadDataSource {
    // Request
    NSString *URLPath = [NSString stringWithFormat:@"http://m.xiangce.baidu.com/mobileapp/get-square-tag-pictures?guid=dbf0faa5-95ed-4b16-8841-44cd47132d70&mac=d8:b3:77:37:27:7b&version=3.0.0&appid=322480&secret_key=vwBvT6iAcuWzB3XQ1WfE1gmLcwNMoTmd&api_key=h0bDq3isAqnyIHuD3Y0IeeKG&language=zh&version=3.0.0&mac=d8:b3:77:37:27:7b&imei=356440046688758&tag_id=30&stream_start=0&stream_size=20&picture_quality=middle"];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                self.items = [[res objectForKey:@"data"] objectForKey:@"pictures"];
                [self dataSourceDidLoad];
            } else {
                [self dataSourceDidError];
            }
        } else {
            [self dataSourceDidError];
        }
    }];
}

-(NSString *) getUrl
{
    NSString *url=[NSString stringWithFormat:@"http://m.xiangce.baidu.com/mobileapp/get-square-tag-pictures?guid=dbf0faa5-95ed-4b16-8841-44cd47132d70&mac=d8:b3:77:37:27:7b&version=3.0.0&appid=322480&secret_key=vwBvT6iAcuWzB3XQ1WfE1gmLcwNMoTmd&api_key=h0bDq3isAqnyIHuD3Y0IeeKG&language=zh&version=3.0.0&mac=d8:b3:77:37:27:7b&imei=356440046688758&tag_id=30&stream_start=%d&stream_size=20&picture_quality=middle",page];
    return url;
}
- (void)dataSourceDidLoad {
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    [self.collectionView reloadData];
}

#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [self.items count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    if (!v) {
        v = [[PSBroView alloc] initWithFrame:CGRectZero];
    }
    [v fillViewWithObject:item];
    
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    return [PSBroView heightForViewWithObject:item inColumnWidth:self.collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    //    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You can do something when the user taps on a collectionViewCell here

    [self tapImage:((PSBroView *)view).imageView  withIndex:index];
}


- (void)tapImage:(UIImageView *) view withIndex:(NSInteger) index
{
    int count = _items.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [_items[i] objectForKey:@"picture_big_url"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        if(i==index)
        photo.srcImageView =view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
