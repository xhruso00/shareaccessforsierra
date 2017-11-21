#import "SAWindowController2.h"

@interface SAWindowController2 () <NSSharingServiceDelegate> {
    
}
@property (weak) IBOutlet NSButton *isSharedButton;
@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSTextField *filenameLabel;
@property (weak) IBOutlet NSButton *publicButton;
@property (weak) IBOutlet NSButton *privateButton;
@property (weak) IBOutlet NSButton *readOnlyButton;
@property (weak) IBOutlet NSButton *readWriteButton;
@property NSSharingService *sharingService;

@end

@implementation SAWindowController2

- (void)awakeFromNib
{
    [[self window] setBackgroundColor:[NSColor whiteColor]];
    [[self window] center];
    [[self isSharedButton] setEnabled:NO];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self refreshInterface];
    
}

- (void)refreshInterface
{
    NSString *path = [[self fileURL] path];
    if (path) {
        NSImage *iconImage = [[NSWorkspace sharedWorkspace] iconForFile:path];
        [[self iconImageView] setImage:iconImage];
        [[self filenameLabel] setStringValue:[path lastPathComponent]];
        if ([self isAlreadyShared]) {
            [self changeVisibilyOfButtonsToHidden:YES];
            [[self isSharedButton] setState:NSOnState];
            
        } else {
            [self changeVisibilyOfButtonsToHidden:NO];
            [[self isSharedButton] setState:NSOffState];
        }
    } else {
        [[self iconImageView] setImage:nil];
        [[self filenameLabel] setStringValue:@"No File Selected"];
    }
    
    
}

- (void)changeVisibilyOfButtonsToHidden:(BOOL)state
{
    [[self readWriteButton] setHidden:state];
    [[self readOnlyButton] setHidden:state];
    [[self publicButton] setHidden:state];
    [[self privateButton] setHidden:state];
}

- (IBAction)changeShareOptions:(id)sender {
    //method is here
    //just to group radio buttons
}

- (IBAction)changeSharePermissions:(id)sender {
    //method is here
    //just to group radio buttons
}

- (IBAction)share:(id)sender {
    //[[self window] performClose:self];
    NSSharingService *sharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNameCloudSharing];
    [self setSharingService:sharingService];
    [sharingService setDelegate:self];
    BOOL canPerformSharing = [sharingService canPerformWithItems:@[[self fileURL]]];
    
    if (canPerformSharing) {
        [sharingService performWithItems:@[[self fileURL]]];
    }
}

- (nullable NSWindow *)sharingService:(NSSharingService *)sharingService sourceWindowForShareItems:(NSArray *)items sharingContentScope:(NSSharingContentScope *)sharingContentScope
{
    return [self window];
}

- (void)sharingService:(NSSharingService *)sharingService willShareItems:(NSArray *)items
{
    if (![self isAlreadyShared]) {
        //NASTY hack that provides incompatible delegate
        [sharingService setValue:self forKey:@"_cloudKitProvider"];
        //NASTY Hack that prevents crashing once user interacts with Apple's sharing window
        [self performSelector:@selector(resetProvider:) withObject:sharingService afterDelay:0.2];
    }
}

- (void)resetProvider:(id)sender
{
    [sender setValue:nil forKey:@"_cloudKitProvider"];
}

- (NSCloudKitSharingServiceOptions)optionsForSharingService:(NSSharingService *)cloudKitSharingService shareProvider:(NSItemProvider *)provider
{
    NSCloudKitSharingServiceOptions options = 0;
    if (![self isAlreadyShared]) {
        if ([[self readOnlyButton] state] == NSOnState) {
            options |= NSCloudKitSharingServiceAllowReadOnly;
        }
        if ([[self readWriteButton] state] == NSOnState) {
            options |= NSCloudKitSharingServiceAllowReadWrite;
        }
        if ([[self publicButton] state] == NSOnState) {
            options |= NSCloudKitSharingServiceAllowPublic;
        }
        if ([[self privateButton] state] == NSOnState) {
            options |= NSCloudKitSharingServiceAllowPrivate;
        }
    }
    return options;
}

- (void)sharingService:(NSSharingService *)sharingService didCompleteForItems:(NSArray *)items error:(nullable NSError *)error
{
    [NSApp terminate:self];
}

- (BOOL)isAlreadyShared
{
    NSNumber *isShared;
    NSError *error;
    [[self fileURL] getPromisedItemResourceValue:&isShared forKey:NSURLUbiquitousItemIsSharedKey error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return [isShared boolValue];
}

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = fileURL;
    [self refreshInterface];
}

@end

