//
//  JHVPNSettingsController.m
//  iPhone VPN Settings
//
//  Created by Jonathan Hohle on 11/12/08.
//  Copyright 2008 Jonathan Hohle. All rights reserved.
//

#import "JHVPNSettingsController.h"
#import "iniparser.h"
#import "cisco-decrypt.h"
#include <gcrypt.h>

@interface JHVPNSettingsController ()

@property (readwrite, copy) NSString* ciscoPCFFile;

- (void) parseFile: (NSString*) file;

@end

@implementation JHVPNSettingsController

#pragma mark accessors

@dynamic ciscoPCFFile;

- (void) setCiscoPCFFile: (NSString*) file {
    NSLog(NSStringFromSelector(_cmd));
    [ciscoPCFFile release];
    ciscoPCFFile = [file copy];
    
    NSArray* pathComponents = [file pathComponents];
    NSString* baseName = [pathComponents lastObject];
    [window setRepresentedFilename: ciscoPCFFile];
    [window setTitle: baseName];
    
    NSURL* fileURL = [[[NSURL alloc] initFileURLWithPath: file] autorelease];
    
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL: fileURL];
}

#pragma mark delegate methods

- (void) awakeFromNib {
    NSLog(NSStringFromSelector(_cmd));
    [description setStringValue: @""];
    [server setStringValue: @""];
    [account setStringValue: @""];
    [group setStringValue: @""];
    [secret setStringValue: @""];

    clockTimer = [[NSTimer scheduledTimerWithTimeInterval: 1
                                                   target: self
                                                 selector: @selector(updateTime:)
                                                 userInfo: nil
                                                  repeats: YES] retain];
    [clockTimer fire];
}

- (void) windowWillClose: (id) sender {
    NSLog(NSStringFromSelector(_cmd));
    [[NSApplication sharedApplication] terminate: self];
}

- (void) registerTypesForPanel: (NSView*) sender {
    NSLog(NSStringFromSelector(_cmd));
    [sender registerForDraggedTypes: [NSArray arrayWithObject: NSFilenamesPboardType]];
}

- (void) dealloc {
    NSLog(NSStringFromSelector(_cmd));
    [super dealloc];
    [description release];
    [server release];
    [account release];
    [group release];
    [secret release];
    [window release];
    [messageView release];
    [ciscoPCFFile release];
    [clockTimer release];
}

#pragma mark parsing and processing operations

- (NSString*) decrypt: (NSString*) encrypted {
    NSLog(NSStringFromSelector(_cmd));
    int len = 0, ret = 0;
    char *bin = 0, *pw = 0;
	
	gcry_check_version(NULL);
	
	ret = hex2bin([encrypted UTF8String], &bin, &len);
	if (ret != 0) {
		NSLog(@"decoding input");
        return nil;
    }
    ret = c_decrypt(bin, len, &pw, NULL);
    free(bin);
    if (ret != 0) {
        NSLog(@"decrypting input");
        return nil;
    }
    NSString* password = [NSString stringWithUTF8String: pw];
    free(pw);

    return password;
}

- (void) parseFile: (NSString*) file {
    NSLog(NSStringFromSelector(_cmd));
    
    dictionary* dict = iniparser_load([file UTF8String]);
    
    if (dict) {
        
        if (iniparser_find_entry(dict, "main:Description")) {
            [description setStringValue: [NSString stringWithUTF8String:
                                          iniparser_getstring(dict, "main:Description", NULL)]];
        }
        if (iniparser_find_entry(dict, "main:Host")) {
            [server setStringValue: [NSString stringWithUTF8String:
                                     iniparser_getstring(dict, "main:Host", NULL)]];
        }
        if (iniparser_find_entry(dict, "main:GroupName")) {
            [group setStringValue: [NSString stringWithUTF8String:
                                    iniparser_getstring(dict, "main:GroupName", NULL)]];
        }
        if (iniparser_find_entry(dict, "main:enc_GroupPwd")) {
            NSString* groupPassword = [NSString stringWithUTF8String:
                                       iniparser_getstring(dict, "main:enc_GroupPwd", NULL)];
            NSString* password = [self decrypt: groupPassword];
            [secret setStringValue: password];
        }
        
        [account setStringValue: NSUserName()];
        
        iniparser_freedict(dict);
    }
}

#pragma mark clock timer
- (void) updateTime: (NSTimer*) theTimer {
    NSLog(NSStringFromSelector(_cmd));
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat: @"h:mm"];
    NSDate* date = [NSDate date];
    NSString* formattedDateString = [dateFormatter stringFromDate: date];
    [time setStringValue: formattedDateString];
    [pool release];
}

#pragma mark FirstResponder methods

#pragma mark NSDraggingDestination methods

// Handle a file dropped on the dock icon
- (BOOL) application: (NSApplication*) sender
            openFile: (NSString*) path {
    NSLog(NSStringFromSelector(_cmd));
    [self setCiscoPCFFile: path];
    [self parseFile: path];
    return YES;
}

- (NSDragOperation) draggingEntered: (id<NSDraggingInfo>) sender {
    NSLog(NSStringFromSelector(_cmd));
    return [self draggingUpdated: sender];
}

- (NSDragOperation) draggingUpdated:(id<NSDraggingInfo>) sender {
    NSLog(NSStringFromSelector(_cmd));
    NSPasteboard* pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        if ([files count] > 0) {
            NSString* file = [files objectAtIndex: 0];
            NSString* extension = [[file pathExtension] lowercaseString];
            if ([extension isEqualToString: @"pcf"]) {
                return NSDragOperationCopy;
            }
        }
    }
    return NSDragOperationNone;
}


- (BOOL) performDragOperation: (id<NSDraggingInfo>) sender {
    NSLog(NSStringFromSelector(_cmd));
    
    NSPasteboard* pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        if ([files count] > 0) {
            NSString* file = [files objectAtIndex: 0]; 
            [self setCiscoPCFFile: file];
            [self parseFile: file];
        }
    }
    
    return YES;
}


- (BOOL) prepareForDragOperation: (id<NSDraggingInfo>) sender {
    NSLog(NSStringFromSelector(_cmd));
    return YES;
}

/*
- (void) draggingExited: (id<NSDraggingInfo>) sender;
- (void) draggingEnded: (id<NSDraggingInfo>) sender;
- (void) concludeDragOperation: (id<NSDraggingInfo>) sender;
- (BOOL) wantsPeriodicDraggingUpdates;
*/

@end
