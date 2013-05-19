//
//  VAMaps.h
//  Vacay
//
//  Created by Joe Minkiewicz on 5/18/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KML/KML.h>

@interface Maps : NSObject

+(Maps *)init;
-(BOOL)addMapFromURL:(NSURL *)url withData:(NSData *)data;
-(NSDictionary *)refreshMapInfo:(NSDictionary *)info;

@property (nonatomic, strong) NSArray *maps;

@end

