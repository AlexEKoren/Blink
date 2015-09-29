//
//  BLCamera.h
//  Blink
//
//  Created by Alex Koren on 9/19/15.
//  Copyright © 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BlinkTypeNone,
    BlinkTypeRight,
    BLinkTypeLeft,
    BlinkTypeBoth
} BlinkType;

@protocol BLCameraDelegate <NSObject>

- (void)didReceiveInput:(BlinkType)blinkType;

@end

@interface BLCamera : NSObject

@property (nonatomic, strong) UIView *previewView;

- (void)start;
- (void)stop;

@property (nonatomic, strong) id<BLCameraDelegate> cameraDelegate;

@end