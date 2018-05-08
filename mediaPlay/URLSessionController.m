//
//  URLSessionController.m
//  mediaPlay
//
//  Created by SKOTC on 2018/4/27.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import "URLSessionController.h"
#import "URLSessionManager.h"
@interface URLSessionController ()

@property URLSessionManager * sessionManager;

@end

@implementation URLSessionController

- (void)viewDidLoad {
        
       [super viewDidLoad];
       // Do any additional setup after loading the view.
        self.sessionManager = [URLSessionManager shareURLSessionManager];
        [self creatUI];
}


-(void)creatUI{
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"开始下载"  forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setBackgroundColor:[UIColor grayColor]];
        [button1 addTarget:self action:@selector(StartDownload) forControlEvents:UIControlEventTouchUpInside];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view).with.offset(100);
                make.centerX.equalTo(self.view);
                make.size.equalTo(self.view).sizeOffset(CGSizeMake(100, 50));
        }];
        [self.view addSubview:button1];
        
        
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setTitle:@"暂停下载"  forState:UIControlStateNormal];
        [button2 setBackgroundColor:[UIColor grayColor]];
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(PauseDownload) forControlEvents:UIControlEventTouchUpInside];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
           
                make.top.equalTo(button1).offset(20);
                make.centerX.equalTo(button1);
                make.size.equalTo(self.view).sizeOffset(CGSizeMake(100, 50));
        }];
        [self.view addSubview:button2];

        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button3 setBackgroundColor:[UIColor grayColor]];
        [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(button2).offset(20);
                make.centerX.equalTo(button2);
                make.size.equalTo(self.view).sizeOffset(CGSizeMake(100, 50));
        }];
        [button3 setTitle:@"恢复下载"  forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(ResumeDownload) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button3];
        
}


-(void)StartDownload{
        
        [self.sessionManager startDownloadWithBackgroundSessionAndFileUrl:@"http://sw.bos.baidu.com/sw-search-sp/software/797b4439e2551/QQ_mac_5.0.2.dmg"];
}

-(void)PauseDownload{
        
        [self.sessionManager pauseDownloadWithBackgroundSession];
}

-(void)ResumeDownload{
        
        [self.sessionManager cintinueDownload];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
