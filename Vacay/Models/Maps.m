//
//  VAMaps.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/18/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "Maps.h"
#include <stdlib.h>

@implementation Maps

+(Maps *)init {
    static Maps *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [Maps new];
    });
    return m;
}

-(BOOL)addMapFromURL:(NSURL *)url withData:(NSData *)data {
    
    // parse the KML and create a document for it to make it easier to use
    KMLRoot *kml = [KMLParser parseKMLWithData:data];
    if (kml.feature && [kml.feature isKindOfClass:[KMLDocument class]]) {
        KMLDocument *document = (KMLDocument *)kml.feature;
        
        // use/create the Application Support directory
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        NSURL *supportURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
        NSURL *KMLdirectory = [supportURL URLByAppendingPathComponent:@"KML"];
        error = nil;
        BOOL directoryWasCreated = [fileManager createDirectoryAtURL:KMLdirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (directoryWasCreated == NO) {
            
            NSLog(@"error creating directory");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Directory Error" message:@"There was an error accessing the application directory" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        } else {
            
            // save the kml file to disk using it's name as the file name
            error = nil;
            NSArray *files = [fileManager contentsOfDirectoryAtURL:KMLdirectory includingPropertiesForKeys:nil options:0 error:&error];
            NSLog(@"files: %@", [files valueForKey:@"lastPathComponent"]);
            BOOL wroteFile = [data writeToURL:[KMLdirectory URLByAppendingPathComponent:[document.name stringByAppendingString:@".kml"]] atomically:YES];
            if (wroteFile) {
                
                // add or update the maps array with the new map
                
                NSDictionary *mapInfo = @{@"name": document.name, @"url": url};
                
                BOOL wasUpdated = NO;
                NSMutableArray *a = [[NSMutableArray alloc] init];
                for (NSDictionary *d in self.maps) {
                    if ([[d valueForKey:@"name"] isEqualToString:[mapInfo valueForKey:@"name"]]) {
                        [a addObject:mapInfo];
                        wasUpdated = YES;
                    } else {
                        [a addObject:d];
                    }
                }
                if (wasUpdated == NO) {
                    [a addObject:mapInfo];
                }
                self.maps = a;
                
                return YES;
                
                
            } else {
                NSLog(@"error writing file");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Writing File" message:@"There was an error writing the file to disk" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                return NO;
            }
        }
        
    } else {
        NSLog(@"error parsing KML document");
        return NO;
    }
    return NO;
}

@end
