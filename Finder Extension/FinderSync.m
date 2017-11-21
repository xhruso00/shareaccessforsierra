#import "FinderSync.h"
#import "SAWindowController2.h"
#import <syslog.h>

@interface FinderSync () {
    SAWindowController2 *_windowController;
}

@property NSURL *myFolderURL;

@end

@implementation FinderSync

- (instancetype)init {
    self = [super init];
    if (self) {
        system("pluginkit -e use -i com.hrubasko.Share-Access-for-Sierra");
        //NSString *path = [@"~/Library/Mobile Documents/com~apple~CloudDocs/" stringByExpandingTildeInPath];
        [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:[NSURL fileURLWithPath:@"/"]];
        //@"~/Library/Mobile Documents/com~apple~CloudDocs
        
    }
    
    return self;
}

- (BOOL)isURLUbiquitous:(NSURL *)URL
{
    NSNumber *isUbiquitous;
    NSError *error;
    [URL getPromisedItemResourceValue:&isUbiquitous forKey:NSURLIsUbiquitousItemKey error:&error];
    return [isUbiquitous boolValue];
}

- (BOOL)isTargetURLUbiquitous
{
   NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
    return [self isURLUbiquitous:target];
}

- (BOOL)canAccessShareOptions
{
    //only iCloud files are allowed to be shared
    if (![self isTargetURLUbiquitous]) {
        return NO;
    }
    
    NSArray <NSURL *>*itemURLs = [[FIFinderSyncController defaultController] selectedItemURLs];
    if ([itemURLs count] <= 1) {
        NSURL *URL = [itemURLs firstObject];
        BOOL isUbiquitousItem = [self isURLUbiquitous:URL];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[URL path] isDirectory:&isDir]) {
            if (isUbiquitousItem && !isDir) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu {
    NSMenu *menu;
    if ([self canAccessShareOptions]) {
        menu = [[NSMenu alloc] initWithTitle:@"Share Access"];
        [menu addItemWithTitle:@"Access Share Options" action:@selector(showShareMenu:) keyEquivalent:@""];
    }
    return menu;
}

- (IBAction)showShareMenu:(id)sender {
    if (![self canAccessShareOptions]) {
        return;
    }
    if (!_windowController) {
        _windowController = [[SAWindowController2 alloc] initWithWindowNibName:@"FinderSync2"];
    }
    NSURL *fileURL;
    NSArray <NSURL *>*itemURLs = [[FIFinderSyncController defaultController] selectedItemURLs];
    if ([itemURLs count] <= 1) {
        fileURL = [itemURLs firstObject];
    }
    [_windowController setFileURL:fileURL];
    dispatch_async(dispatch_get_main_queue(), ^{
            [_windowController showWindow:self];
    });
}

@end

