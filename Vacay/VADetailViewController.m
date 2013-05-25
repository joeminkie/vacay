//
//  VADetailViewController.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/25/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "VADetailViewController.h"

@interface VADetailViewController ()

@end

@implementation VADetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.detailInfo.name;
    
    [self.webView loadHTMLString:self.detailInfo.descriptionValue baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
