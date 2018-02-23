//
//  AppDelegate.h
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/21/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

