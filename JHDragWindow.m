//
//  JHDragWindow.m
//  iPhone VPN Settings
//
//  Created by Jonathan Hohle on 11/12/08.
//  Copyright 2008 Jonathan Hohle. All rights reserved.
//

#import "JHDragWindow.h"


@implementation JHDragWindow


- (void)awakeFromNib
{
    if ([self delegate] && [[self delegate] respondsToSelector: @selector(registerTypesForPanel:)]) {
        [[self delegate] registerTypesForPanel:self];
    }
}

- (unsigned int) draggingEntered:sender
{
    if ([self delegate] && [[self delegate] respondsToSelector: @selector(draggingEntered:)]) {
        return [[self delegate] draggingEntered:sender];
    }
    return 0;
}

- (unsigned int) draggingUpdated:sender
{
    if ([self delegate] && [[self delegate] respondsToSelector: @selector(draggingUpdated:)]) {
        return [[self delegate] draggingUpdated:sender];
    }
    return 0;
}

- (BOOL) prepareForDragOperation:sender
{
    if ([self delegate] && [[self delegate] respondsToSelector: @selector(prepareForDragOperation:)]) {
        return [[self delegate] prepareForDragOperation:sender];
    }
    return NO;
}

- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender
{
    if ([self delegate] && [[self delegate] respondsToSelector: @selector(performDragOperation:)]) {
        return [[self delegate] performDragOperation:sender];
    }
    return NO;
}


/*
- (BOOL) performDragOperation: (id<NSDraggingInfo>) sender {
    
    NSLog(@"%@", sender);
    
    return YES;
}


- (BOOL) prepareForDragOperation: (id<NSDraggingInfo>) sender {
    NSLog(@"preparing...");
    return YES;
}

 - (void) draggingExited: (id<NSDraggingInfo>) sender;
 - (void) draggingEnded: (id<NSDraggingInfo>) sender;
 - (void) concludeDragOperation: (id<NSDraggingInfo>) sender;
 - (BOOL) wantsPeriodicDraggingUpdates;
 */

@end
