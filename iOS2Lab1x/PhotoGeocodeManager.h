//
//  PhotoGeocodeManager.h
//  iOS2Lab1x
//
//  Created by James Derry on 11/10/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol PhotoGeocodeManagerDelegate <NSObject>

@required
- (void)didObtainPlacemark:(MKPlacemark *)mark forLocation:(NSString *)key;

@end


@interface PhotoGeocodeManager : NSObject

@property(nonatomic, weak) id<PhotoGeocodeManagerDelegate> delegate;
@property(nonatomic, strong) NSMutableDictionary *geocodedLocations;

+ (id)sharedManager;

- (void)placemarkForLocation:(NSString *)location;

@end
