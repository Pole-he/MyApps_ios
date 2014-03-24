//
//  PoAnimeTasteDetailController.m
//  MyApps
//
//  Created by Nathan-he on 14-3-5.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoAnimeTasteDetailController.h"
#import "Default.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ASIHTTPRequest.h"
#import "PoDetailMoreViewController.h"
#import "PoPlayVideoViewViewController.h"
@interface PoAnimeTasteDetailController ()
{
    NSMutableArray *_animeList;
    UIView *viewBg1;
    
    NSMutableArray *_arr;
}
@end

@implementation PoAnimeTasteDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _animeList = [[NSMutableArray alloc]init];
        
        _arr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x323232); // 修改背景颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_back_res"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    
    
	NSString *title=_item.Name;
    
    NSString *author=_item.Author;
    
    NSString *content=_item.Brief;
    
    //可以精确计算字符串的换行，高宽等
    CGSize titleSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
                       constrainedToSize:CGSizeMake(240, MAXFLOAT)
                           lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize authorSize = [author sizeWithFont:[UIFont systemFontOfSize:17.0f]
                         constrainedToSize:CGSizeMake(240, MAXFLOAT)
                             lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                         constrainedToSize:CGSizeMake(240, MAXFLOAT)
                             lineBreakMode:UILineBreakModeCharacterWrap];
    //titile
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(15, 10, titleSize.width, titleSize.height);
    titleLabel.textColor = UIColorFromRGB(0x323232);
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    //author
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.frame = CGRectMake(15, 20+titleSize.height, authorSize.width, authorSize.height);
    authorLabel.textColor = UIColorFromRGB(0x323232);
    authorLabel.text = author;
    authorLabel.font = [UIFont systemFontOfSize:17.0f];
    authorLabel.numberOfLines = 0;
    authorLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    //分割线
    UIView *divider = [[UIView alloc] init];
    divider.frame=CGRectMake(15, 30+titleSize.height+authorSize.height, 260, 0.5);
    divider.backgroundColor = UIColorFromRGB(0xaaaaaa);
    
    //content
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(15, 40+titleSize.height+authorSize.height, contentSize.width, contentSize.height);
    contentLabel.textColor = UIColorFromRGB(0x909090);
    contentLabel.text = content;
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    UIView *viewBg = [[UIView alloc] init];
    viewBg.frame = CGRectMake(15, 193, 290, 50+titleSize.height+authorSize.height+contentSize.height);
    viewBg.backgroundColor=[UIColor whiteColor];
    
    [viewBg addSubview:titleLabel];
    [viewBg addSubview:authorLabel];
    [viewBg addSubview:divider];
    [viewBg addSubview:contentLabel];
    
    UILabel *tip=[[UILabel alloc]init];
    tip.text=@"相关推荐";
    tip.font=[UIFont boldSystemFontOfSize:15.0f];
    tip.frame =CGRectMake(15, 15, 260, 20);
    
    viewBg1 = [[UIView alloc] init];
    viewBg1.frame = CGRectMake(15, 193+viewBg.frame.size.height+15, 290, 50+titleSize.height+authorSize.height+contentSize.height);
    viewBg1.backgroundColor=[UIColor whiteColor];
    
    [viewBg1 addSubview:tip];
    
    
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width ,  viewBg1.frame.origin.y+viewBg1.frame.size.height+20);
    
    [self.scrollView setContentSize:newSize];
    
    [self.scrollView addSubview:viewBg];
    [self.scrollView addSubview:viewBg1];
    
    [self.coverDetail setImageWithURL:[NSURL URLWithString:_item.DetailPic]];
    
    [self getData];
    
    self.ivPlay.userInteractionEnabled=YES;
    [self.ivPlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play:)]];
    
}
-(void)play:(UITapGestureRecognizer *)gestureRecognizer
{
        PoPlayVideoViewViewController *secondView = [[PoPlayVideoViewViewController alloc] initWithNibName:NULL bundle:[NSBundle mainBundle]];
        //设置SecondViewController中的值
        secondView.url = _item.VideoUrl;
        //跳转界面
        [self presentModalViewController:secondView animated:YES];
}
- (void)getData
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
        NSArray* arrayResult =[dic objectForKey:@"list"];
        for (int i=0; i<arrayResult.count; i++) {
            // 初始化试卷模型
            NSDictionary* resultDic = [arrayResult objectAtIndex:i];
            
            PoAnimeTasteItem *paperModel = [[PoAnimeTasteItem alloc]initWithItemID:[resultDic objectForKey:@"Id"] itemName:[resultDic objectForKey:@"Name"] itemVideoUrl:[resultDic objectForKey:@"VideoUrl"] itemVideoSource:[resultDic objectForKey:@"VideoSource"] itemAuthor:[resultDic objectForKey:@"Author"] itemBrief:[resultDic objectForKey:@"Brief"] itemHomePic:[resultDic objectForKey:@"HomePic"] itemDetailPic:[resultDic objectForKey:@"DetailPic"]];
            // 添加试卷模型到试卷列表中
            [_animeList addObject:paperModel];
            
            PoDetailMoreViewController *more=
            [[[NSBundle mainBundle] loadNibNamed:@"PoDetailMoreViewController" owner:self options:nil] objectAtIndex:0];
            more.data =paperModel;
            more.detailView = self;
            CGRect rect = more.frame;
            rect.origin.y=50+i*(more.frame.size.height+10);
            rect.origin.x=15;
            [more setFrame:rect];
            [viewBg1 addSubview:more];
          //  [_arr addObject:more];
        }
        
        CGRect bgRect=viewBg1.frame;
        bgRect.size.height = 380;
        [viewBg1 setFrame:bgRect];
        CGSize newSize = CGSizeMake(self.view.frame.size.width ,  viewBg1.frame.origin.y+viewBg1.frame.size.height+20);
        
        [self.scrollView setContentSize:newSize];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error:%@",error);
    }];
    [request startAsynchronous];
}

-(NSString *) getUrl
{
    return @"http://i.animetaste.net/api/animelist_v3/?api_key=ios&timestamp=1394007330&order=random&limit=5&access_token=74dcded195d40b65facd089d75dbf54f";
}

- (IBAction)back:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return(toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
