//
//  JHDragView.m
//  iPhone VPN Settings
//
//  Created by Jonathan Hohle on 11/12/08.
//  Copyright 2008 Jonathan Hohle. All rights reserved.
//

#import "JHNondragImageView.h"


@implementation JHNondragImageView

- (void)awakeFromNib
{
    [self unregisterDraggedTypes];
}

@end