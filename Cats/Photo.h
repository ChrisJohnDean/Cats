//
//  Photo.h
//  Cats
//
//  Created by Chris Dean on 2018-03-01.
//  Copyright © 2018 Chris Dean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic) NSURL *url;

- (instancetype)initWithDict:(NSDictionary*)photo;

@end
