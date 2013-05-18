//
//  VAAddMapViewController.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/15/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "VAAddMapViewController.h"
#import "VAKML.h"

@interface VAAddMapViewController ()

@end

@implementation VAAddMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(IBAction)addMap:(id)sender {
    
    [self showLoader];
    
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self dismissLoader];
        
        if (data) {
            
            // parse the KML and create a document for it to make it easier to use
            self.kml = [KMLParser parseKMLWithData:data];
            if (self.kml.feature && [self.kml.feature isKindOfClass:[KMLDocument class]]) {
                self.document = (KMLDocument *)self.kml.feature;
            }
            
            [self saveData:data];
            
        } else {
            NSLog(@"connection error");
        }
        
    }];
}

-(void)saveData:(NSData *)data {
    
    // use/create the Application Support directory
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSURL *supportURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    NSURL *KMLdirectory = [supportURL URLByAppendingPathComponent:@"KML"];
    error = nil;
    BOOL directoryWasCreated = [fileManager createDirectoryAtURL:KMLdirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (directoryWasCreated == NO) {
        NSLog(@"error creating directory");
    } else {
        
        // save the kml file to disk using it's name as the file name
        error = nil;
        NSArray *files = [fileManager contentsOfDirectoryAtURL:KMLdirectory includingPropertiesForKeys:nil options:0 error:&error];
        NSLog(@"files: %@", [files valueForKey:@"lastPathComponent"]);
        BOOL wroteFile = [data writeToURL:[KMLdirectory URLByAppendingPathComponent:[self.document.name stringByAppendingString:@".kml"]] atomically:YES];
        if (wroteFile) {
            NSLog(@"wrote file");
        } else {
            NSLog(@"error writing file");
        }
    }
}


-(void)showLoader {
    // TODO
}

-(void)dismissLoader {
    // TODO
}





-(IBAction) closeAddMapView:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
