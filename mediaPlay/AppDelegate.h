//
//  AppDelegate.h
//  mediaPlay
//
//  Created by SKOTC on 2017/12/5.
//  Copyright © 2017年 CAOMEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

