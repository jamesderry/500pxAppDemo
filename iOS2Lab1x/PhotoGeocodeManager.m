//
//  PhotoGeocodeManager.m
//  iOS2Lab1x
//
//  Created by James Derry on 11/10/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "PhotoGeocodeManager.h"

#define kNotificationNewPlacemark @"NewPlacemarkAvailable"

@interface PhotoGeocodeManager ()
{
    
}
@end

@implementation PhotoGeocodeManager
{
    NSMutableArray      *geocodedArray;
    NSOperationQueue *geocodeOpQueue;
}

#pragma mark Singleton Method

+ (id)sharedManager {
    static PhotoGeocodeManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init]; //make this a singleton in future project
    if (self) {
        self.geocodedLocations = [[NSMutableDictionary alloc] init];
        geocodedArray = [[NSMutableArray alloc] init];
        geocodeOpQueue = [[NSOperationQueue alloc] init];
        geocodeOpQueue.maxConcurrentOperationCount = 1;  //apple geocoding service requires serial requests
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCacheFromNotification:) name:kNotificationNewPlacemark object:nil];
    }
    return self;
}

- (void)placemarkForLocation:(NSString *)location
{
    NSLog(@"...checking location: %@", location);
    if ([self.geocodedLocations objectForKey:location] == nil ) {

        [geocodeOpQueue addOperationWithBlock:^{
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            NSLog(@"geocoding address: '%@'", location);
            [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error){
                if (error == nil) {
                    //NSLog(@"placemarks:%@", placemarks);
                    MKPlacemark *placeMark = [placemarks objectAtIndex:0];
                    
                    // store new placeMark in cache by sending notification from this block back to the PhotoGeocodeManager
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPlacemark object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:placeMark, @"placemark", location, @"location", nil]];
                    
                    
                    [geocodedArray addObject:placeMark];
                    //NSLog(@"geocodedLocations: %@", geocodedLocations);
                    //add artificial delay...apple geocoding requires pacing the webservice calls
                    double delayInSeconds = .5;
                    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(waitTime, dispatch_get_main_queue(), ^(void){
                        [self.delegate didObtainPlacemark:placeMark forLocation:location];
                    });
                    
                } else {
                    NSLog(@"error geocoding location:%@ error:%@", location, error.localizedDescription);
                    
                    //add artificial delay...apple geocoding requires pacing the webservice calls
                    double delayInSeconds = .5;
                    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(waitTime, dispatch_get_main_queue(), ^(void){
                        [self.delegate didObtainPlacemark:nil forLocation:location];
                    });
                }
            }];
            
        }];
    } else {
        NSLog(@"cache hit...for location %@", location);
        [self.delegate didObtainPlacemark:[self.geocodedLocations objectForKey:location] forLocation:location];
    }
    //check cache for matching location string
    // if exists call delegate passing coordinates
    // if does not exist call Apple geocoder
    // manage sequential geocoding calls to apple with upper limit of 50
}

#pragma mark New Placemark Notification selector

- (void)updateCacheFromNotification:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    [self.geocodedLocations setObject:[dict objectForKey:@"placemark"] forKey:[dict objectForKey:@"location"]];
    //NSLog(@"geocodedLocations:%@", self.geocodedLocations);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNewPlacemark object:nil];
}

@end
