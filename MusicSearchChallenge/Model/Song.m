//
//  Song.m
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/22/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import "Song.h"

@implementation Song

- (id) initWithAritst:(NSString *)artist album:(NSString *)album song:(NSString *)song andArtwork:(NSString *)artwork
{
  self = [super init];
  if (self)
  {
    // I wrapped everything in if/else statements in case the parameters were null.  Better to show empty space than (null).
    
    if (artist != nil) {
      self.artist = artist;
    } else {
      self.artist = @"";
    }
    
    if (album != nil){
      self.album = album;
    } else {
      self.album = @"";
    }
    
    if (song != nil){
      self.song = song;
    } else {
      self.song = @"";
    }
    
    if (artwork != nil){
      self.artwork = artwork;
    } else {
      self.artwork = @"";
    }
//    self.album = album;
//    self.song = song;
//    self.artwork = artwork;
  }
  return self;
}


@end
