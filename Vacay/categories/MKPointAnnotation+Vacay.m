//
//  MKPointAnnotation+Vacay.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/25/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import <objc/runtime.h>
#import "MKPointAnnotation+Vacay.h"
#import <KML/KML.h>

@implementation MKPointAnnotation (Vacay)

static char kIconPathKey;

- (NSString *)iconPath {
    return objc_getAssociatedObject(self, &kIconPathKey);
}

- (void)setIconPath:(NSString *)iconPath {
    objc_setAssociatedObject(self, &kIconPathKey, iconPath, OBJC_ASSOCIATION_RETAIN);
}


@end
