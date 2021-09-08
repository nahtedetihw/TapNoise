#import "Tweak.h"

//if (currentListeningMode() == 1) Normal
//if (currentListeningMode() == 2) NoiseCancellation
//if (currentListeningMode() == 3) Transparency

unsigned currentListeningMode() {
    NSArray *connectedDevices = [[%c(BluetoothManager) sharedInstance] connectedDevices];
    if (![connectedDevices count]) return 0;

    return ((BluetoothDevice *)connectedDevices[0]).listeningMode;
}

unsigned listeningMode() {
    if (currentListeningMode() == 1) return 2;
    if (currentListeningMode() == 2) return 3;
    if (currentListeningMode() == 3) return 1;
    return currentListeningMode();
}

void toggleNoiseCancellation() {
    NSArray *connectedDevices = [[%c(BluetoothManager) sharedInstance] connectedDevices];
    if (![connectedDevices count]) return;
    
    [connectedDevices[0] setListeningMode:listeningMode()];
}

%hook MusicNowPlayingContentView
- (void)didMoveToSuperview {
    %orig;
    ((MusicNowPlayingContentView *)self).userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:((MusicNowPlayingContentView *)self) action:@selector(tapNoise)];
    [((MusicNowPlayingContentView *)self) addGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:0.5 animations:^ {
        ((MusicNowPlayingContentView *)self).layer.shadowColor = [UIColor systemBlueColor].CGColor;
        ((MusicNowPlayingContentView *)self).layer.shadowOpacity = 1.0;
    } completion:nil];
}

%new
- (void)tapNoise {
    toggleNoiseCancellation();
    AudioServicesPlaySystemSound(1519);
    if (currentListeningMode() == 1) {
        [UIView animateWithDuration:0.5 animations:^ {
            ((MusicNowPlayingContentView *)self).layer.shadowColor = [UIColor systemGrayColor].CGColor;
            ((MusicNowPlayingContentView *)self).layer.shadowOpacity = 1.0;
        } completion:nil];
    } else if (currentListeningMode() == 2) {
        [UIView animateWithDuration:0.5 animations:^ {
            ((MusicNowPlayingContentView *)self).layer.shadowColor = [UIColor systemBlueColor].CGColor;
            ((MusicNowPlayingContentView *)self).layer.shadowOpacity = 1.0;
        } completion:nil];
    } else if (currentListeningMode() == 3) {
        [UIView animateWithDuration:0.5 animations:^ {
            ((MusicNowPlayingContentView *)self).layer.shadowColor = [UIColor whiteColor].CGColor;
            ((MusicNowPlayingContentView *)self).layer.shadowOpacity = 1.0;
        } completion:nil];
    }
}
%end

%ctor {
    %init(MusicNowPlayingContentView = NSClassFromString(@"MusicApplication.NowPlayingContentView"));
    return;
}
