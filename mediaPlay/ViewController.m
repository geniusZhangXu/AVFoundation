//
//  ViewController.m
//  mediaPlay
//
//  Created by SKOTC on 2017/12/5.
//  Copyright © 2017年 CAOMEI. All rights reserved.
//

#import "ViewController.h"
#import "mediaPlayController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        
        
        if ([segue.identifier isEqualToString:@"mediaPlayerController"]) {
                
            mediaPlayController * destination = segue.destinationViewController;
            destination.MovieURL = [NSURL URLWithString:@"http://pic.ibaotu.com/00/34/48/06n888piCANy.mp4"];
        }
}


-(IBAction)unwindSegue:(UIStoryboardSegue *)sender{
        
        NSLog(@"unwindSegue %@", sender);
}


- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end
