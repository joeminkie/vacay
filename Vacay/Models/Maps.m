//
//  VAMaps.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/18/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "Maps.h"
#include <stdlib.h>

@interface Maps()

-(void)initMapsArrays;

@end

@implementation Maps

+(Maps *)init {
    static Maps *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [Maps new];
        if (m.maps == nil) {
            [m initMapsArrays];
        }
    });
    
    return m;
}

-(void)initMapsArrays {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *a = [defaults objectForKey:@"mapInfo"];
    
    if (a) {
        
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
            
            // for each saved item, read the respective file and create the kml and document data for it
            NSMutableArray *extendedInfo = [[NSMutableArray alloc] init];
            for (NSDictionary *d in a) {
                NSData *data = [[NSData alloc] initWithContentsOfURL:[KMLdirectory URLByAppendingPathComponent:[[d valueForKey:@"name"] stringByAppendingString:@".kml"]]];
                
                KMLRoot *kml = [KMLParser parseKMLWithData:data];
                KMLDocument *document = (KMLDocument *)kml.feature;
                
                [extendedInfo addObject:@{@"name":[d valueForKey:@"name"], @"url":[d valueForKey:@"url"], @"kml":kml, @"document":document}];
            }
            self.maps = extendedInfo;
            
        }
    }
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
                
                NSDictionary *mapInfo = @{@"name": document.name, @"url": [url absoluteString]};
                NSDictionary *mapData = @{@"name": document.name, @"url": [url absoluteString], @"kml":kml, @"document":document};
                
                BOOL wasUpdated = NO;
                NSMutableArray *info = [[NSMutableArray alloc] init];
                NSMutableArray *data = [[NSMutableArray alloc] init];
                for (NSDictionary *d in self.maps) {
                    if ([[d valueForKey:@"name"] isEqualToString:[mapData valueForKey:@"name"]]) {
                        [info addObject:mapInfo];
                        [data addObject:mapData];
                        wasUpdated = YES;
                    } else {
                        // only save the name and url to User Defaults
                        [info addObject:@{@"name": [d valueForKey:@"name"], @"url":[d valueForKey:@"url"]}];
                        [data addObject:d];
                    }
                }
                if (wasUpdated == NO) {
                    [info addObject:mapInfo];
                    [data addObject:mapData];
                }
                self.maps = data;
                
                NSLog(@"self.maps: %@", self.maps);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:info forKey:@"mapInfo"];
                [defaults synchronize];
                
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
