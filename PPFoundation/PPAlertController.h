//
//  PPAlertController.h
//
//  Created by Philip Zhao on 12/24/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * PPAlertController manage UIAlertView/UIActionSheet/UIAlertController for both iOS7 and iOS8.
 */

@class PPAlertController;
@class PPAlertAction;

typedef NS_ENUM(NSUInteger, PPAlertActionStyle) {
  PPAlertActionStyleDefault = 0,
  PPAlertActionStyleCancel,
  PPAlertActionStyleDestructive,
};

typedef void(^PPAlertActionHandler)();

/**
 * Similar to UIAlertAction but avaiable to both platforms.
 */
@interface PPAlertAction : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) PPAlertActionStyle style;
@property (nonatomic, copy, readonly) PPAlertActionHandler handler;

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(PPAlertActionStyle)style
                        handler:(PPAlertActionHandler)handler;
@end

@protocol PPAlertControllerDelegate <NSObject>
/**
 * After dismiss, this method would be involved. The caller must nil its alertController ptr.
 */
- (void)alertControllerDidInvalid:(PPAlertController *)alertController;
@end

/**
 * PPAlertController is designed to use once. Once it used, the caller must nil its pointer.
 */
@interface PPAlertController : NSObject
@property (nonatomic, weak, readonly) id<PPAlertControllerDelegate> delegate;

/**
 *  Return AlertController that configures to be AlertView
 */
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                       actions:(NSArray *)actions
                      delegate:(id<PPAlertControllerDelegate>)delegate;

/** 
 * Return AlertController that configures to be ActionSheet.
 */
+ (instancetype)actionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                             actions:(NSArray *)actions
                            delegate:(id<PPAlertControllerDelegate>)delegate;

/**
 * Call once. And it would involve the alertControllerDidInvalid: method
 */
- (void)showOnceFromViewController:(UIViewController *)presenter;

@end
