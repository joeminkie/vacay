//
//  MKPointAnnotation+Vacay.h
//  Vacay
//
//  Created by Joe Minkiewicz on 5/25/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <KML/KML.h>

@interface MKPointAnnotation (Vacay)

- (NSString *)iconPath;
- (void)setIconPath:(NSString *)iconPath;

@end
