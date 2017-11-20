#import "AppDelegate.h"
#import "SAWindowController.h"

@interface AppDelegate () {
    SAWindowController *_windowController;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)awakeFromNib
{
    [[self window] setBackgroundColor:[NSColor whiteColor]];
    [self centerOnMainScreen];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#ifdef DEBUG
#else
    system("pluginkit -e use -i com.hrubasko.Share-Access-for-Sierra");
#endif
    [self centerOnMainScreen];
    [[self window] makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:0x1];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed {
    return YES;
}

- (void)centerOnMainScreen
{
    NSRect screenRect = [[NSScreen mainScreen] frame];
    NSRect windowRect = [[self window] frame];
    [[self window] setFrameOrigin:NSMakePoint((NSWidth(screenRect) - NSWidth(windowRect))/2, (NSHeight(screenRect) - NSHeight(windowRect))/2)];
}

- (IBAction)share:(NSURL *)URL
{
    if (!_windowController) {
        _windowController = [[SAWindowController alloc] initWithWindowNibName:@"FinderSync"];
    }
    [_windowController setFileURL:URL];
    [_windowController showWindow:self];
    
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:self];
}

- (IBAction)revealExtensions:(id)sender
{
    NSError *error;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"System Preferences\"\n\
                                   activate\n\
                                   set the current pane to pane id \"com.apple.preferences.extensions\"\n\
                                   reveal anchor \"Extensions\" of pane id \"com.apple.preferences.extensions\"\n\
                                   end tell"];

    if (error) {
        [[NSAlert alertWithError:error] runModal];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAppleEventDescriptor* returnDescriptor = NULL;
            NSDictionary* errorDict;
            returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
        });
    }
    
}

- (IBAction)sendFeedback:(id)sender
{
    NSString *URLString = @"https://github.com/xhruso00/shareaccessforsierra/issues";
    NSURL *URL = [NSURL URLWithString:URLString];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}


@end
