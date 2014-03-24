//
//  PoViewController.m
//  MyApps
//
//  Created by Pole-he on 13-12-29.
//  Copyright (c) 2013年 Pole-he. All rights reserved.
//

#import "PoViewController.h"

@interface PoViewController ()

@end

@implementation PoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    button.backgroundColor = [UIColor blueColor];
    button.showsTouchWhenHighlighted = true;
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *aString = [NSString stringWithFormat:data];
    UIWebView *web = [[UIWebView alloc] init];
    NSString *sc = [NSString stringWithFormat:@"decodeURIComponent('%@')",aString];
    NSString *st = [web stringByEvaluatingJavaScriptFromString:sc];
    NSLog(st);
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"请求finish");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr =[NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable
                                                                    format:NULL
                                                          errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}
@end
