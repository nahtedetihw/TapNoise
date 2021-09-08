#import <AudioToolbox/AudioServices.h>

@interface BluetoothDevice : NSObject
-(unsigned)listeningMode;
-(BOOL)setListeningMode:(unsigned)arg1 ;
@end
@interface BluetoothManager : NSObject
+(id)sharedInstance;
-(id)connectedDevices;
@end

@class MusicNowPlayingContentView;

@interface MusicNowPlayingContentView : UIView
- (id)viewControllerForAncestor;
- (void)tapNoise;
@end
