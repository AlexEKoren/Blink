//
//  BLViewController.m
//  Blink
//
//  Created by Alex Koren on 9/19/15.
//  Copyright © 2015 Alex Koren. All rights reserved.
//

#import "BLViewController.h"
#import "BLCamera.h"
#import "BLBFInterpreter.h"
#import <Parse/Parse.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BLViewController () <BLCameraDelegate>

@property (nonatomic) BlinkType currentBlink;

@property (nonatomic) BlinkType lastBlink;
@property (nonatomic) NSInteger bothCount;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) BLCamera *camera;

@property (nonatomic, strong) UIImageView *leftEyeView;
@property (nonatomic, strong) UIImageView *rightEyeView;

@property (nonatomic, strong) UITextView *codeView;

@property (nonatomic) BOOL readyToRun;

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.camera = [[BLCamera alloc]init];
    self.camera.cameraDelegate = self;
    self.camera.previewView = self.view;
    [self.camera start];
    
    self.leftEyeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.view.frame.size.height - 120, 100, 100)];
    self.leftEyeView.image = [UIImage imageNamed:@"eye-left.png"];
    self.leftEyeView.hidden = YES;
    [self.view addSubview:self.leftEyeView];
    
    self.rightEyeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 20, self.view.frame.size.height - 120, 100, 100)];
    self.rightEyeView.image = [UIImage imageNamed:@"eye-right.png"];
    self.rightEyeView.hidden = YES;
    [self.view addSubview:self.rightEyeView];
    
    self.codeView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, 50)];
    self.codeView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.8];
    self.codeView.layer.cornerRadius = 5.0;
    self.codeView.clipsToBounds = YES;
    self.codeView.textColor = [UIColor whiteColor];
    self.codeView.font = [UIFont systemFontOfSize:20];

    [self.view addSubview:self.codeView];
    
    self.currentBlink = BlinkTypeNone;
    self.lastBlink = BlinkTypeNone;
    
    self.readyToRun = NO;
    
    self.code = @"";
    
    self.code = @"++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";
    
    self.code = @"++++++[>++++++<-]>.";
    
    self.code = @">++++[>++++++<-]>-[[<+++++>>+<-]>-]<<[<]>>>>--.<<<-.>>>-.<.<.>---.<<+++.>>>++.<<---.[>]<<.";
    
    self.code = @"";
    
}

- (void)didReceiveInput:(BlinkType)blinkType {
    if (self.codeView.isFirstResponder)
        return;
    if (blinkType == self.currentBlink) {
        return;
    }
    if (blinkType == BlinkTypeNone) {
        self.currentBlink = BlinkTypeNone;
    } else if (self.lastBlink == BlinkTypeNone) {
        self.currentBlink = blinkType;
        self.lastBlink = blinkType;
        if (self.readyToRun) {
            if (![self.code isEqualToString:self.codeView.text])
                self.code = self.codeView.text;
            /** Use this if you want a local interpretation
            NSString *result = [BLBFInterpreter interpretCode:self.code];
            self.code = @"";
            self.codeView.text = [NSString stringWithFormat:@"Output: %@\n", result];
            **/
            [PFCloud callFunctionInBackground:@"runBFCode" withParameters:@{@"code":self.code} block:^(id  _Nullable object, NSError * _Nullable error) {
                NSString *result = (NSString *)object;
                self.code = @"";
                self.codeView.text = [NSString stringWithFormat:@"Output: %@\n", result];
            }];
            self.code = @"Running in cloud";
            self.currentBlink = BlinkTypeNone;
            self.lastBlink = BlinkTypeNone;
            self.readyToRun = NO;
            [self updateEyes];
            AudioServicesPlaySystemSound(1009);
        }
    } else {
        if (self.lastBlink == BlinkTypeBoth) {
            if (blinkType == BlinkTypeBoth) {
                if (self.code.length > 0) {
                    self.code = [self.code substringToIndex:self.code.length - 1];
                    AudioServicesPlaySystemSound(1007);
                }
                AudioServicesPlaySystemSound(1007);
            } else if (blinkType == BLinkTypeLeft) {
                self.code = [self.code stringByAppendingString:BFCharacterLeft];
                AudioServicesPlaySystemSound(1007);
            } else if (blinkType == BlinkTypeRight) {
                self.code = [self.code stringByAppendingString:BFCharacterRight];
                AudioServicesPlaySystemSound(1007);
            }
        } else if (self.lastBlink == BLinkTypeLeft) {
            if (blinkType == BlinkTypeBoth) {
                self.readyToRun = YES;
                AudioServicesPlaySystemSound(1008);
            } else if (blinkType == BLinkTypeLeft) {
                self.code = [self.code stringByAppendingString:BFCharacterBracketLeft];
                AudioServicesPlaySystemSound(1007);
            } else if (blinkType == BlinkTypeRight) {
                self.code = [self.code stringByAppendingString:BFCharacterBracketRight];
                AudioServicesPlaySystemSound(1007);
            }
        } else if (self.lastBlink == BlinkTypeRight) {
            if (blinkType == BlinkTypeBoth) {
                self.code = [self.code stringByAppendingString:BFCharacterOut];
                AudioServicesPlaySystemSound(1007);
            } else if (blinkType == BLinkTypeLeft) {
                self.code = [self.code stringByAppendingString:BFCharacterDecrement];
                AudioServicesPlaySystemSound(1007);
            } else if (blinkType == BlinkTypeRight) {
                self.code = [self.code stringByAppendingString:BFCharacterIncrement];
                AudioServicesPlaySystemSound(1007);
            }
        }
        self.currentBlink = blinkType;
        self.lastBlink = BlinkTypeNone;
    }
    
    [self updateEyes];
}

- (void)setCode:(NSString *)code {
    _code = code;
    self.codeView.text = code;
    if (code.length > 0) {
        NSRange range = NSMakeRange(code.length - 1, 1);
        [self.codeView scrollRangeToVisible:range];
    }
}

- (void)updateEyes {
    if (self.lastBlink == BlinkTypeNone) {
        self.leftEyeView.hidden = YES;
        self.rightEyeView.hidden = YES;
    } else if (self.lastBlink == BlinkTypeBoth) {
        self.leftEyeView.hidden = NO;
        self.rightEyeView.hidden = NO;
    } else if (self.lastBlink == BLinkTypeLeft) {
        self.leftEyeView.hidden = NO;
        self.rightEyeView.hidden = YES;
    } else if (self.lastBlink == BlinkTypeRight) {
        self.leftEyeView.hidden = YES;
        self.rightEyeView.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.codeView resignFirstResponder];
}
@end
