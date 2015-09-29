//
//  BLBFInterpreter.h
//  Blink
//
//  Created by Alex Koren on 9/19/15.
//  Copyright © 2015 Alex Koren. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const BFCharacterIncrement = @"+";
NSString * const BFCharacterDecrement = @"-";
NSString * const BFCharacterLeft = @"<";
NSString * const BFCharacterRight = @">";
NSString * const BFCharacterOut = @".";
NSString * const BFCharacterBracketLeft = @"[";
NSString * const BFCharacterBracketRight = @"]";

@interface BLBFInterpreter : NSObject

+ (NSString *)interpretCode:(NSString *)code;

@end
