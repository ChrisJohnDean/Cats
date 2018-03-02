//
//  ViewController.m
//  Cats
//
//  Created by Chris Dean on 2018-03-01.
//  Copyright © 2018 Chris Dean. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSCache *photoCache;
@property (nonatomic) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.photoCache = [[NSCache alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    [self makeNetworkRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeNetworkRequest {
    
    NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=2df8dcd49025d033f6efa200e8ec7b47&tags=cat";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            return;
        }
        [self parseResponseData:data];
    }];
    [dataTask resume];
}

- (void)parseResponseData:(NSData*)data {
    
    NSError *error = nil;
    NSDictionary *flickrDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error != nil) {
        NSLog(@"Error %@", error);
        return;
    }
    
    NSDictionary *photos = flickrDict[@"photos"];
    NSArray *photosArray = photos[@"photo"];
    
    for(NSDictionary *photo in photosArray) {
        Photo *myPhoto = [[Photo alloc] initWithDict:photo];
        [self.photos addObject:myPhoto];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myCollectionView reloadData];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *photoCell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    Photo *photo = self.photos[indexPath.row];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = photo.url.absoluteString;
    
    //Checks if photo has already been cached in photoCache
    if([self.photoCache objectForKey:urlString]) {
        UIImage *cachedImage = [self.photoCache objectForKey:urlString];
        dispatch_async(dispatch_get_main_queue(), ^{
            photoCell.photoView.image = cachedImage;
        });
    } else {
    
        photoCell.downloadTask = [session downloadTaskWithURL:photo.url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(error) {
                NSLog(@"error: %@", error.localizedDescription);
                return;
            }
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            
            //Adds UIImage to photoCache with urlString as key
            [self.photoCache setObject:image forKey:urlString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //This will run on main queue
                photoCell.photoView.image = image;
            });
            
        }];
        
        [photoCell.downloadTask resume];
    }
    
    return photoCell;
}

@end













