//
//  Api500pxFetcher.h
//  iOS2Lab1x
//
//  Created by James Derry on 11/4/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@protocol Api500pxFetcherDelegate <NSObject>

@required
- (void)didReceiveNewPhotos;

@end


@interface Api500pxFetcher : NSObject

@property(nonatomic, strong) NSMutableArray *gallery;
@property(nonatomic, weak) id<Api500pxFetcherDelegate> delegate;



- (void)getMorePhotos;













@end
