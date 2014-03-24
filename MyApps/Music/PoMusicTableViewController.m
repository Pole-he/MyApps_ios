//
//  PoMusicTableViewController.m
//  MyApps
//
//  Created by Nathan-he on 14-2-26.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoMusicTableViewController.h"
#import "MJRefresh.h"
#import "PoMusicCell.h"
#import "ASIHTTPRequest.h"
#import "Default.h"
#import "ASIFormDataRequest.h"

#define SongUrl @"http://ting.hotchanson.com/v2/songs/download?song_id=%@";

static NSString *const PoMusic = @"PoMusicCell";
@interface PoMusicTableViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger page;
    NSMutableArray *ids;
    NSDictionary *dictionary;
    NSIndexPath *_indexPath;
}

@end

@implementation PoMusicTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blur1"]];
//    self.tableView.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blur1.jpg"]];
    // 1.注册
//    [self.tableView registerClass:[PoMusicCell class] forCellReuseIdentifier:PoMusic];
    self.tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
    self.view.backgroundColor = UIColorFromRGB(0xe8e8e0);;
    
    self.tableView.backgroundColor = UIColorFromRGB(0xe8e8e0);
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview: self.tableView];
    _musicList = [[NSMutableArray alloc]init];
    _songList = [[NSMutableArray alloc] init];
    ids =[[NSMutableArray alloc]init];

    page = -1;
    // 3.集成刷新控件
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
}
- (void)getData:(PoMusicTableViewController *) vc withObject:(MJRefreshBaseView *)refreshView
{
    
    NSString *_url = [self getUrl];
    NSURL *url = [NSURL URLWithString:_url];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        //一下为自定义解析， 自己想怎么干就怎么干
        if(page==-1)
        {
            [_musicList removeAllObjects];
            [ids removeAllObjects];
            [ids addObjectsFromArray:[dic objectForKey:@"data"]];
            page+=1;
            [self getData:vc withObject:refreshView];
            
            
        }else{
            [_musicList addObjectsFromArray:[dic objectForKey:@"data"]];
            [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        }
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
    
    if(page!=-1)
    {
        [request setPostValue:[self getMsgIds] forKey:@"msg_ids"];
        
    }
   [request startAsynchronous];
    
}

- (void)addFooter
{
    __unsafe_unretained PoMusicTableViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
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
    __unsafe_unretained PoMusicTableViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        page=-1;
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

-(NSString *) getMsgIds
{
    NSString *str = [[NSString alloc]init];
    for (int i =page; i<page+20;i++) {
        str=[str stringByAppendingFormat:@"%@, ",ids[i]];
    }
    str = [str substringToIndex:str.length-2];
    str =[NSString stringWithFormat:@"[%@]",str];
    return str;
}

-(NSString *) getUrl
{
    NSString *url=@"";
    if(page==-1){
        //@"http://v1.ard.q.itlily.com/share/get_celebrities"
        url =@"http://v1.ard.q.itlily.com/share/celebrities";
    }else{
        url =@"http://v1.ard.q.itlily.com/share/user_timeline";
    }
    //@"http://v1.ard.q.itlily.com/share/user_timeline"
    return url;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"get cell height at %d", [indexPath row]);
    //    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    UITableViewCell *cell=[self tableView: tableView cellForRowAtIndexPath: indexPath];
    //
    //    CGFloat height=cell.textLabel.frame.size.height+cell.detailTextLabel.frame.size.height;
    //    NSLog(@"cell height is %.f at %d", height, [indexPath row]);
    //  return 216.0;
    NSDictionary *dataDic = [_musicList objectAtIndex:indexPath.row];
    CGSize size = [[dataDic objectForKey:@"tweet"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (_musicList.count == indexPath.row+1) {
        return 236+size.height+55;
    }else{
        return 236+size.height+45;
    }
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PoMusicCell";
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // 1. cell标识符，使cell能够重用
    // static NSString *paperCell = @"itemCell";
    
   
    // 2. 注册自定义Cell的到TableView中，并设置cell标识符为paperCell
//    static BOOL isRegNib = NO;
//    if (!isRegNib) {
//        [tableView registerNib:[UINib nibWithNibName:@"PoMusicCell" bundle:nil] forCellReuseIdentifier:PoMusic];
//        isRegNib = YES;
//    }
//     PoMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:PoMusic];
//
    // 3. 从TableView中获取标识符为paperCell的Cell
    

    
    PoMusicCell *cell = (PoMusicCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (PoMusicCell *)[nibArray objectAtIndex:0];
        [cell configurePlayerButton];
        [cell setBackground];
    }
    
    // 4. 设置单元格属性
    // [cell setupCell:_animeList[indexPath.row]];
    // cell.backgroundColor = [UIColor brownColor];
    
    [cell setData:_musicList[indexPath.row]];
     cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];

    if(_audioPlayer)
    {
//        _indexPath = [NSIndexPath indexPathForRow:_audioPlayer.button.num inSection:_audioPlayer.button.num];
//        NSLog(@"%@",_indexPath);
//        CGRect rectInTableView = [tableView rectForRowAtIndexPath: _indexPath];
//        
//        
//        CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
//        NSLog(@"%f",rect.origin.y);
        
//        CGRect rect = [_audioPlayer.button.superview convertRect:_audioPlayer.button.frame fromView:self.view];
//        NSLog(@"%f",rect.origin.y);
       // NSLog(@"%@",_audioPlayer.button.superview);
        if(cell.audioButton == _audioPlayer.button)
        {
            [_audioPlayer reset:cell.title.text];
        }
        
        if(indexPath.row == _audioPlayer.button.num)
        {
//            cell.audioButton.image = [UIImage imageNamed:@"icon_music_circle_pause.png"];
//            [cell.audioButton setNeedsDisplay];
            [cell.audioButton playSpin];
        }else
        {
//            cell.audioButton.image=[UIImage imageNamed:@"icon_music_circle_play.png"];
//            [cell.audioButton setProgress:0];
            [cell.audioButton resetSpin];
        }
        
    }
    
    //重新布局
    CGSize size = [[_musicList[indexPath.row] objectForKey:@"tweet"] sizeWithFont:cell.content.font constrainedToSize:CGSizeMake(cell.content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    CGRect cellFrameContent = [cell.content frame];
    cellFrameContent.size.height=size.height+10;
    [cell.content setFrame:cellFrameContent];
    
    CGRect cellFrame = [cell frame];

    cell.content.text = [_musicList[indexPath.row] objectForKey:@"tweet"];


    CGRect cellFramebg = [cell.translateBg frame];
    cellFramebg.size.height=227+size.height+45;
    [cell.translateBg setFrame:cellFramebg];
    
    CGRect controller = [cell.controllerBar frame];
    controller.origin.y =cellFrameContent.origin.y+cellFrameContent.size.height+5;
    [cell.controllerBar setFrame:controller];
    
    if (_musicList.count == indexPath.row+1) {
        cellFrame.size.height = 236+size.height+55;
    }else{
        cellFrame.size.height = 236+size.height+45;
    }
    [cell setFrame:cellFrame];
    
    return cell;
}

- (void)playAudio:(AudioButton *)button
{
    NSInteger index = button.tag;
    NSDictionary *item = [_musicList objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button] && index ==_audioPlayer.button.num) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        
        _audioPlayer.button = button;
        NSString *url=[[NSString alloc]init];
        if([item objectForKey:@"songlist"])
        {
            NSArray *array = [item objectForKey:@"songlist"];
            for(NSDictionary *dic in array)
            {
                url = [url stringByAppendingString:[dic objectForKey:@"song_id"]];
                url = [url stringByAppendingString:@","];
            }
            url = [url substringToIndex:url.length-1];
        }else{
            url = [[item objectForKey:@"song"]objectForKey:@"song_id"];
        }
        _audioPlayer.button.num = index;
        _audioPlayer.button.identify= [item objectForKey:@"songlistname"];
        [_audioPlayer reset:[item objectForKey:@"songlistname"]];
        [self getSongUrl:url];
//        _audioPlayer.url = [NSURL URLWithString:@"http://y1.eoews.com/assets/ringtones/2012/5/18/34049/oiuxsvnbtxks7a0tg6xpdo66exdhi8h0bplp7twp.mp3"];
//        
//        [_audioPlayer play];
    }
}

-(void) getSongUrl:(NSString *)songId
{
    _audioPlayer.url = [NSURL URLWithString:@""];
    NSString *urlStr = [NSString stringWithFormat:@"http://ting.hotchanson.com/v2/songs/download?song_id=%@", songId];
    NSURL *url = [NSURL URLWithString:urlStr];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        [_songList removeAllObjects];
        // Use when fetching text data
        NSString *responseString = [request responseString];
        
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        NSArray *song = dic[@"data"];
        for (NSDictionary *dictionary in song) {
            NSArray * url_list = [dictionary objectForKey:@"url_list"];
            if(url_list.count==1)
            {
                [_songList addObject:[url_list[0] objectForKey:@"url"] ];
            }else
            {
                [_songList addObject:[url_list[1] objectForKey:@"url"] ];
            }
        }
        _audioPlayer.url = [NSURL URLWithString:_songList[0]];
        [_audioPlayer play];

    }];
    [request setFailedBlock:^{
        NSError *error = [request error];

    }];
    
    [request startAsynchronous];
}

- (void)dealloc
{
    [_header free];
    [_footer free];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
