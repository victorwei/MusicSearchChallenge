//
//  ViewController.m
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/21/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import "ViewController.h"
#import "MusicResultsCell.h"
#import "SearchController.h"
#import "DetailsViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

NSString *cellId = @"cellId";
NSArray *dataSource;
//NSCache *cache;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)setup {
  
  _searchBar.delegate = self;
  [self setupTableView];
  
}

- (void)setupTableView {
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  UINib *nib = [UINib nibWithNibName:@"MusicResultsCell" bundle:nil];
  [_tableView registerNib:nib forCellReuseIdentifier:cellId];
  
}




// MARK: - UITableView Delegate/DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  MusicResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
  
  Song *listing = dataSource[indexPath.row];
  
  // Set the labels
  cell.artistLabel.text = [NSString stringWithFormat:@"Artist: %@", listing.artist];
  cell.songLabel.text = [NSString stringWithFormat:@"Song: %@", listing.song];
  cell.albumLabel.text = [NSString stringWithFormat:@"Album: %@", listing.album];
  
  if (listing.imgArtwork != nil) {
    cell.albumImgView.image = listing.imgArtwork;
  } else {
    
    // Set the image
    NSURL *imageURL = [NSURL URLWithString:listing.artwork];
    [[[NSURLSession sharedSession]dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
      if (error != nil) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
      
      UIImage *artworkImg = [[UIImage alloc] initWithData:data];
      listing.imgArtwork = artworkImg;
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        // Make sure that the image we are adding to is to the correct cell, in case user scrolls too fast.
        MusicResultsCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        currentCell.albumImgView.image = artworkImg;
      });
      
    }] resume];
  }
  return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return [self.view frame].size.width / 5;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
  Song *selectedItem = dataSource[indexPath.row];
  
  DetailsViewController *detailsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailsVC"];
  detailsVC.data = selectedItem;
  
  [self.navigationController pushViewController:detailsVC animated:YES];
  
}

// Alert used for any message
- (void) showAlertFor:(NSString* )message {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
  [alertController addAction:okAction];
  [self presentViewController:alertController animated:YES completion:nil];
  
}


// MARK: - UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  
  NSString *searchTerm = searchBar.text;

  // Get the songs data from the search bar.  When we get the results back, set the result to the datasource and reload the tableview.
  [[SearchController shared] searchMusicForTerm:searchTerm completionHandler:^(NSArray *results) {
    
    if ([results count] == 0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertFor: [NSString stringWithFormat:@"No Results found for %@", searchTerm]];
      });
      
    }
    
    dataSource = results;
    
    // Updates to UI must be done on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
    });
  }];
  
}


@end
