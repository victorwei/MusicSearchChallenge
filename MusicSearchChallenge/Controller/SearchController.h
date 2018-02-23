//
//  SearchController.h
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/21/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@interface SearchController : NSObject


/**
 Creates a singleton instance of our SearchController.
*/
+(id)shared;

/**
 Search function that takes in a search term and uses NSURLSession to grab the data.
 The method uses a block to return the data in the form of a NSArray.  Must use a block to return the data since NSURLSession is an asynchronous task and implicitly runs on a background thread.
*/
- (void)searchMusicForTerm:(NSString *)termm completionHandler:(void(^)(NSArray *results))completion;


/**
 Function that takes in a artist and song term and uses NSURLSession to grab the data (lyrics).
 The method uses a block to return the data in the form of a NSString.  Must use a block to return the data since NSURLSession is an asynchronous task and implicitly runs on a background thread.
 */
- (void)returnLyricsFor:(NSString *)song andArtist:(NSString *)artist completionHandler:(void(^)(NSString *lyrics))completion;

@end
