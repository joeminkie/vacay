//
//  VADetailViewController.h
//  Vacay
//
//  Created by Joe Minkiewicz on 5/25/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KML/KML.h>

@interface VADetailViewController : UIViewController

@property (nonatomic, weak) KMLPlacemark *detailInfo;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
