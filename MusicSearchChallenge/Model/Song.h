//
//  Song.h
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/22/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Song : NSObject

// MARK: - Properties
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *artwork;
@property (nonatomic, strong) UIImage *imgArtwork;
@property (nonatomic, strong) NSString *lyrics;


- (id) initWithAritst:(NSString *)artist album:(NSString *)album song:(NSString *)song andArtwork:(NSString *)artwork;
  


@end
