//
//  DetailsViewController.m
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/22/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import "DetailsViewController.h"
#import "SearchController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImgView;

@end

@implementation DetailsViewController

/*
 Note: If I had more time, I would probably align the lyrics label to start at the top aligned with the picture on the right for a cleaner look.  I'd probably implement some type of solution similar to the link below: https://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel given more time.
*/

- (void)viewDidLoad {
    [super viewDidLoad];
  
  // Set UILabels
  _songLabel.text = [NSString stringWithFormat:@"Lyrics For: %@ ", _data.song];
  _artistLabel.text = [NSString stringWithFormat:@"Artist: %@ ", _data.artist];
  _albumLabel.text = [NSString stringWithFormat:@"Album: %@ ", _data.album];
  _albumImgView.image = _data.imgArtwork;
  
  
  // Check to see if the Song object already contains the lyrics.  If it does, just grab the lyrics from the Song object.  If it doesn't, use the SearchController lyrics method to grab the data.
  if (_data.lyrics != nil) {
    _lyricsLabel.text = _data.lyrics;
  } else {
    [[SearchController shared] returnLyricsFor:_data.song andArtist:_data.artist completionHandler:^(NSString *lyrics) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        // The NSString contains escaping characters that show up in the label for an unknown reason at the time.  I manually replaced those escaping characters so the lyrics are formatted a bit more properly.
        NSString *formatted = [lyrics stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        _lyricsLabel.text = formatted;
        _data.lyrics = formatted;
        
      });
    }];
  }
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
