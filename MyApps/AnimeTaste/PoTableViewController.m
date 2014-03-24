//
//  PoTableVIewController.m
//  MyApps
//
//  Created by Nathan-he on 14-2-16.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoTableViewController.h"
#import "MJRefresh.h"
#import "AnimeItemCell.h"
#import "ASIHTTPRequest.h"
#import "CommonCrypto/CommonDigest.h"
#import "PoTableViewHeader.h"
#import "PoPlayVideoViewViewController.h"
#import "Default.h"
#import "PoAnimeTasteDetailController.h"
NSString *const MJTableViewCellIdentifier = @"Cell";

@interface PoTableViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger page;
}
@end

@implementation PoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
    self.view.backgroundColor = UIColorFromRGB(0xe8e8e0);;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview: self.tableView];
    
    
    // 1.注册
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    _animeList = [[NSMutableArray alloc]init];
    
    page = 0;
    // 3.集成刷新控件
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
}


- (void)getData:(PoTableViewController *) vc withObject:(MJRefreshBaseView *)refreshView
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
            [_animeList removeAllObjects];
            NSMutableArray *_headerList = [[NSMutableArray alloc] init];
            NSArray* headerResult = [dic objectForKey:@"feature"];
            for (id header in headerResult) {
                [_headerList addObject: [header objectForKey:@"DetailPic"] ];
            }
            
            PoTableViewHeader *advertHeaderView=[[PoTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 177)];
            [advertHeaderView configAdvert:_headerList];
            self.tableView.tableHeaderView=advertHeaderView;
            
        }
        NSArray* arrayResult =[dic objectForKey:@"list"];
        for (int i=0; i<arrayResult.count; i++) {
            // 初始化试卷模型
            NSDictionary* resultDic = [arrayResult objectAtIndex:i];
            
            PoAnimeTasteItem *paperModel = [[PoAnimeTasteItem alloc]initWithItemID:[resultDic objectForKey:@"Id"] itemName:[resultDic objectForKey:@"Name"] itemVideoUrl:[resultDic objectForKey:@"VideoUrl"] itemVideoSource:[resultDic objectForKey:@"VideoSource"] itemAuthor:[resultDic objectForKey:@"Author"] itemBrief:[resultDic objectForKey:@"Brief"] itemHomePic:[resultDic objectForKey:@"HomePic"] itemDetailPic:[resultDic objectForKey:@"DetailPic"]];
            // 添加试卷模型到试卷列表中
            [_animeList addObject:paperModel];
        }
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        //        int h = [[UIScreen mainScreen] bounds].size.height;
        //        int w = [[UIScreen mainScreen] bounds].size.width;
        //        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        //        [tableView setDelegate:self];
        //        [tableView setDataSource:self];
        //        [self.view addSubview: tableView];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
    }];
    [request startAsynchronous];
}

- (void)addFooter
{
    __unsafe_unretained PoTableViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        page = page +1;
        [self getData:vc withObject:refreshView];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        //        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained PoTableViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
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
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _animeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. cell标识符，使cell能够重用
    static NSString *paperCell = @"itemCell";
    
    // 2. 注册自定义Cell的到TableView中，并设置cell标识符为paperCell
    static BOOL isRegNib = NO;
    if (!isRegNib) {
        [tableView registerNib:[UINib nibWithNibName:@"AnimeItemCell" bundle:nil] forCellReuseIdentifier:paperCell];
        isRegNib = YES;
    }
    
    // 3. 从TableView中获取标识符为paperCell的Cell
    AnimeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:paperCell];
    // 4. 设置单元格属性
    [cell setupCell:_animeList[indexPath.row]];
    
    return cell;
    
}

/**
 3、设置行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"get cell height at %d", [indexPath row]);
    //    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    UITableViewCell *cell=[self tableView: tableView cellForRowAtIndexPath: indexPath];
    //
    //    CGFloat height=cell.textLabel.frame.size.height+cell.detailTextLabel.frame.size.height;
    //    NSLog(@"cell height is %.f at %d", height, [indexPath row]);
    return 110.0;
    
}

-(NSString *) getUrl
{
    NSString *url=[NSString stringWithFormat:@"api_key=ios&page=%d&timestamp=13883014188ce32e9a0072037578899a53e155441f",page];
    NSString *get = [[NSString alloc] initWithFormat:@"http://i.animetaste.net/api/animelist_v2/?api_key=ios&timestamp=1388301418&page=%d&access_token=%@" ,page,[self md5:url]];
    return get;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity: CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x" , result[i]];
    }
    return [output lowercaseString];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PoPlayVideoViewViewController *secondView = [[PoPlayVideoViewViewController alloc] initWithNibName:NULL bundle:[NSBundle mainBundle]];
//    //设置SecondViewController中的值
//    secondView.url = ((PoAnimeTasteItem *)_animeList[indexPath.row]).VideoUrl;
//    //跳转界面
//    [self.controller presentModalViewController:secondView animated:YES];
    UINavigationController *navigationController=[[UINavigationController alloc]init];
    PoAnimeTasteDetailController *view = [[PoAnimeTasteDetailController alloc] initWithNibName:@"PoAnimeTasteDetailController" bundle:[NSBundle mainBundle]];
    view.controller=self.controller;
    view.item = _animeList[indexPath.row];
    [navigationController pushViewController:view animated:NO];
    [self.controller presentModalViewController:navigationController animated:YES];
}
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    [_header free];
    [_footer free];
}

@end

