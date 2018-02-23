//
//  SearchController.m
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/21/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import "SearchController.h"
#import "Song.h"

@interface SearchController ()

@end


@implementation SearchController

NSString *appleSearch = @"https://itunes.apple.com/search?term=";
NSString *lyricsSearch = @"http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json";


+ (id)shared {
  static SearchController *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^ {
    shared = [[self alloc] init];
  });
  return shared;
}

- (id) init {
  return self;
}


- (void)searchMusicForTerm:(NSString *)term completionHandler:(void(^)(NSArray *results))completion {
  
  // Get the correct string by adding the search term to the API string and URL encode it
  NSString *fullUrl = [[NSString stringWithFormat:@"%@%@", appleSearch, term] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  
  NSURL *url = [NSURL URLWithString:fullUrl];
  
  [[[NSURLSession sharedSession] dataTaskWithURL:url
                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                 
                                 // Display errors if there are any
                                 if (error != nil) {
                                   NSLog(@"Error: %@ %@", error, [error userInfo]);
                                   return;
                                 }
                                 
                                 // Convert the data to a JSON file
                                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                 
                                 // Error handling if data conversion to json failed
                                 if (!json) {
                                   NSLog(@"There was an issue getting converting the data to JSON format!");
                                   return;
                                 }
                                 
                                 NSArray *result = [self returnSongsFromJSON:json];
                                 completion(result);
                                 
  }] resume];
}

/**
 Parse the NSDictionary to data.  Iterates through the data and creates Song classes and adds them to a NSMutableArray.
 Returns an empty array if there are no results.  Returns array full of Song objects otherwise.
*/

- (NSArray *)returnSongsFromJSON:(NSDictionary *)json {
  
  NSMutableArray *songs = [[NSMutableArray alloc]init];
  
  NSArray *results = json[@"results"];
  
  if ([results count] == 0) {
    return [[NSArray alloc] initWithArray:songs];
  }
  
  for (NSDictionary *single in results) {
    
    NSString *artist = single[@"artistName"];
    NSString *album = single[@"collectionName"];
    NSString *song = single[@"trackName"];
    NSString *artwork = single[@"artworkUrl60"];
    
    Song *result = [[Song alloc]initWithAritst:artist album:album song:song andArtwork:artwork];
    
    [songs addObject:result];
  }
  
  return [[NSArray alloc] initWithArray:songs];
}



- (void)returnLyricsFor:(NSString *)song andArtist:(NSString *)artist completionHandler:(void(^)(NSString *lyrics))completion {
  
  // Get the correct string by adding the search term to the API string and URL encode it
  NSString *fullUrl = [[NSString stringWithFormat:@"http://lyrics.wikia.com/api.php?func=getSong&artist=%@&song=%@&fmt=json", artist, song] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  
  NSURL *url = [NSURL URLWithString:fullUrl];
  
  [[[NSURLSession sharedSession] dataTaskWithURL:url
                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                 
                                 // Display errors if there are any
                                 if (error != nil) {
                                   NSLog(@"Error: %@ %@", error, [error userInfo]);
                                   return;
                                 }
                                 
                                 // The data format given back by this API gave was not in an JSON easy format so I ended up manually parsing it.  This isn't the best practice, but given the time constraint I decided to just do this instead.  I first tried to use JSON serialization, but all the new line characters made it impossible.  Instead, I decided to just convert the data into a String format and parse it manually.  Since the format for wiki api seems to be consistent, I split the string into an array separated by the newline character.  Based on the consistent format, I could assume that the lyrics was always in index 3.  Afterwards, I just parsed out the first characters before the lyrics, and the ending characters.  I assume there must be an easier way to convert this into JSON data, with more time I could probably find out the solution.
                                 
                                 NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                 NSString *jsonReady = [stringData substringFromIndex:7];
                                 
                                 NSArray *test = [jsonReady componentsSeparatedByString:@"\n"];
                                 
                                 // Make sure there are at least 4 indexes in the array otherwise the bottom line of code will crash.
                                 if ([test count] < 4) {
                                   completion(@"Lyrics not found");
                                   return;
                                 }
                                 
                                 NSString *lyrics = [test[3] substringFromIndex:10];
                                 lyrics = [lyrics substringToIndex:[lyrics length] -2];
                                 
                                 completion(lyrics);
                                 
                               }] resume];
  
}



@end
