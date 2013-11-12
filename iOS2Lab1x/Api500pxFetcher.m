//
//  Api500pxFetcher.m
//  iOS2Lab1x
//
//  Created by James Derry on 11/4/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "Api500pxFetcher.h"

#define k500pxURLGallery @"https://api.500px.com/v1/photos?feature=popular&page=1&rpp=25&consumer_key=FSYAW9OQHwBhe6q1QpmYZAJwZd4RJdV1YIy2ghBZ"

@interface Api500pxFetcher ()
{
    Photo *onePhoto;
    int page;
}

@end

@implementation Api500pxFetcher

- (id)init
{
    self = [super init];
    if (self) {
        
        self.gallery = [[NSMutableArray alloc] init];
        page = 1;
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:k500pxURLGallery]];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            
            if (error) {
                NSLog(@"Network error occurred.");
            } else {
                [self parsePhotoJSONData:data];
            }
            
        }];
    }
    return self;
}

- (void)getMorePhotos
{
    page = page + 1;
    NSString *pageURL = [NSString stringWithFormat:@"https://api.500px.com/v1/photos?feature=popular&page=%i&rpp=25&consumer_key=FSYAW9OQHwBhe6q1QpmYZAJwZd4RJdV1YIy2ghBZ", page];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:pageURL]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            NSLog(@"Network error occurred.");
        } else {
            [self parsePhotoJSONData:data];
        }
        
    }];
}

- (void)parsePhotoJSONData:(NSData *)data
{
    NSError *error = nil;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    //NSLog(@"%@", parsedObject);
    
    NSArray *photos = [parsedObject valueForKey:@"photos"];
    int numberofphotos = [photos count];
    
    NSMutableArray *tempPhotoCollector = [[NSMutableArray alloc] initWithCapacity:numberofphotos];
    
    for (int i=0; i < numberofphotos; i++) {
        
        NSDictionary *photoInfo = [photos objectAtIndex:i];
        NSLog(@"photoInfo: %@", photoInfo);
        onePhoto = [[Photo alloc] init];
        
        onePhoto.imageURL = [photoInfo objectForKey:@"image_url"];
        onePhoto.name = [photoInfo objectForKey:@"name"];
        onePhoto.user = [[photoInfo objectForKey:@"user"] objectForKey:@"username"];
        //now get the city, country and userpic url
        onePhoto.city = [[photoInfo objectForKey:@"user"] objectForKey:@"city"];
        NSLog(@"onePhoto.city=%@", onePhoto.city);
        onePhoto.country = [[photoInfo objectForKey:@"user"] objectForKey:@"country"];
        onePhoto.userPicURL = [[photoInfo objectForKey:@"user"] objectForKey:@"userpic_url"];
        /*
        onePhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:onePhoto.imageURL]]];
        */
        
        [tempPhotoCollector addObject:onePhoto];
        
        NSLog(@"Photo %@ by %@ is found at url %@", onePhoto.name, onePhoto.user, onePhoto.imageURL);
    }
    
    //now append our temporary photo array to the gallery array used by the tableview
    self.gallery = (NSMutableArray *)[self.gallery arrayByAddingObjectsFromArray:tempPhotoCollector];
    
    NSLog(@"gallery count: %lu", (unsigned long)[self.gallery count]);
    
    [self.delegate didReceiveNewPhotos];
}







@end
