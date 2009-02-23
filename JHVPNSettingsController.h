//
//  JHVPNSettingsController.h
//  iPhone VPN Settings
//
//  Created by Jonathan Hohle on 11/12/08.
//  Copyright 2008 Jonathan Hohle. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JHVPNSettingsController : NSObject {
    IBOutlet NSWindow* window;
    IBOutlet NSTextField* time;
    IBOutlet NSTextField* description;
    IBOutlet NSTextField* server;
    IBOutlet NSTextField* account;
    IBOutlet NSTextField* group;
    IBOutlet NSTextField* secret;
    IBOutlet NSView* messageView;
    
    NSString* ciscoPCFFile;
    NSTimer* clockTimer;
}

- (void) registerTypesForPanel: (NSView*) sender;

@end
