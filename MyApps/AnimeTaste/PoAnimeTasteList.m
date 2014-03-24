//
//  PoAnimeTasteList.m
//  MyApps
//
//  Created by Nathan-he on 14-2-9.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoAnimeTasteList.h"
#import "AnimeItemCell.h"
@interface PoAnimeTasteList ()

@end
@implementation PoAnimeTasteList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    _animeList = [[NSMutableArray alloc]init];
    [self jsonParse];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview: tableView];

}

- (void)jsonParse{
    
    //初始化网络路径。
    NSString* path  = @"http://i.animetaste.net/api/animelist_v2/?api_key=ios&timestamp=1388301418&page=0&access_token=aca6614f91249893d60213e8bef92ac8";
    //初始化 url
    NSURL* url = [NSURL URLWithString:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    //将请求到的字符串写到缓冲区。
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    //一下为自定义解析， 自己想怎么干就怎么干
  //  NSLog(aString);
    NSArray* arrayResult =[dic objectForKey:@"list"];
    for (int i=0; i<arrayResult.count; i++) {
        // 初始化试卷模型
        PoAnimeTasteItem *paperModel = [[PoAnimeTasteItem alloc]initWithItemID:arrayResult[i][0] itemName:arrayResult[i][1] itemVideoUrl:arrayResult[i][3] itemVideoSource:arrayResult[i][5] itemAuthor:arrayResult[i][6] itemBrief:arrayResult[i][8] itemHomePic:arrayResult[i][9] itemDetailPic:arrayResult[i][10]];
        // 添加试卷模型到试卷列表中
        [_animeList addObject:paperModel];
    }
//    NSDictionary* resultDic = [arrayResult objectAtIndex:0];
//    NSDictionary* geometryDic = [resultDic objectForKey:@"Brief"];
//    NSLog(@"Brief: %@,  resultDic:%@",geometryDic,resultDic);
//    NSDictionary* locationDic = [geometryDic objectForKey:@"location"];
//    NSNumber* lat = [locationDic objectForKey:@"lat"];
//    NSNumber* lng = [locationDic objectForKey:@"lng"];
//    NSLog(@"lat = %@, lng = %@",lat,lng);
    
}

///**
// 3、设置行的高度
// */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 88.0f;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _animeList.count;
//}
//
///**
// 4、返回指定的 row 的 cell
// */
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    // 1. cell标识符，使cell能够重用
//    static NSString *paperCell = @"itemCell";
//    
//    // 2. 注册自定义Cell的到TableView中，并设置cell标识符为paperCell
//    static BOOL isRegNib = NO;
//    if (!isRegNib) {
//        [tableView registerNib:[UINib nibWithNibName:@"AnimeItemCell" bundle:nil] forCellReuseIdentifier:paperCell];
//        isRegNib = YES;
//    }
//    
//    // 3. 从TableView中获取标识符为paperCell的Cell
//    AnimeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:paperCell];
//    
//    // 4. 设置单元格属性
//    [cell setupCell:_animeList[indexPath.row]];
//    
//    return cell;
//}

@end
