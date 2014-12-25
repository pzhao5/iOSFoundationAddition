//
//  PPAlertController.m
//
//  Created by Philip Zhao on 12/24/14.
//  Copyright (c) 2014 PP. All rights reserved.
//

#import "PPAlertController.h"

@interface PPAlertAction ()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) PPAlertActionStyle style;
@property (nonatomic, copy, readwrite) PPAlertActionHandler handler;
@end

@implementation PPAlertAction
+ (instancetype)actionWithTitle:(NSString *)title style:(PPAlertActionStyle)style handler:(PPAlertActionHandler)handler
{
  PPAlertAction *action = [[PPAlertAction alloc] init];
  action.title = title;
  action.style = style;
  action.handler = handler;
  return action;
}

@end

@interface PPAlertController ()
@property (nonatomic, weak, readwrite) id<PPAlertControllerDelegate> delegate;

// Make sure that view is used once and only once.
@property (nonatomic, assign) BOOL hasUsedOnce;
- (void)intendToShowAlert;
@end

@interface PPAlertViewControllerSubclass : PPAlertController <UIAlertViewDelegate>
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSArray *actions;
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                      actions:(NSArray *)actions;
@end

@interface PPActionSheetControllerSubclass : PPAlertController <UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIAlertController *alertController;
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                      actions:(NSArray *)actions;
@end

@implementation PPAlertController

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                       actions:(NSArray *)actions
                      delegate:(id<PPAlertControllerDelegate>)delegate
{
  PPAlertViewControllerSubclass *alert = [[PPAlertViewControllerSubclass alloc] initWithTitle:title message:message actions:actions];
  alert.delegate = delegate;
  return alert;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                             actions:(NSArray *)actions
                            delegate:(id<PPAlertControllerDelegate>)delegate
{
  PPActionSheetControllerSubclass *action = [[PPActionSheetControllerSubclass alloc] initWithTitle:title message:message actions:actions];
  action.delegate = delegate;
  return action;
}

- (void)showOnceFromViewController:(UIViewController *)presenter
{
  PPFailAssert();
}

- (void)intendToShowAlert
{
  NSAssert(self.hasUsedOnce, @"Must not used");
  self.hasUsedOnce = YES;
}

@end

@implementation PPAlertViewControllerSubclass

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions
{
  self = [super init];
  if (self) {
    if (![UIAlertController class]) {
      _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
      _actions = [actions copy];
      [_actions enumerateObjectsUsingBlock:^(PPAlertAction *alertAction, NSUInteger index, BOOL *stop) {
        NSInteger buttonIndex = [_alertView addButtonWithTitle:alertAction.title];
        if (alertAction.style == PPAlertActionStyleCancel) {
          [_alertView setCancelButtonIndex:buttonIndex];
        }
      }];
      _alertView.delegate = self;
    } else {
      _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
      [actions enumerateObjectsUsingBlock:^(PPAlertAction *alertAction, NSUInteger index, BOOL *stop) {
        PPAlertActionHandler handler = [alertAction.handler copy];
        __weak PPAlertViewControllerSubclass *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:alertAction.title style:(UIAlertActionStyle)alertAction.style handler:^(UIAlertAction *action1) {
          if (handler) {
            handler();
          }
          [weakSelf _invalidActions];
        }];
        [_alertController addAction:action];
      }];
    }

  }
  return self;
}

- (void)showOnceFromViewController:(UIViewController *)presenter
{
  [self intendToShowAlert];
  if (![UIAlertController class]) {
    [_alertView show];
  } else {
    [presenter presentViewController:_alertController animated:YES completion:nil];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  PPAlertAction *action = _actions[buttonIndex];
  if (action.handler) {
    action.handler();
  }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  [self _invalidActions];
}

- (void)_invalidActions
{
  _actions = nil;
  _alertView.delegate = nil;
  _alertView = nil;
  _alertController = nil;
  [self.delegate alertControllerDidInvalid:self];
}

@end

@implementation PPActionSheetControllerSubclass

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions
{
  self = [super init];
  if (self) {
    if (![UIAlertController class]) {
      _actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
      _actions = actions;
      [_actions enumerateObjectsUsingBlock:^(PPAlertAction *alertAction, NSUInteger index, BOOL *stop) {
        NSInteger buttonIndex = [_actionSheet addButtonWithTitle:alertAction.title];
        if (alertAction.style == PPAlertActionStyleCancel) {
          [_actionSheet setCancelButtonIndex:buttonIndex];
        } else if (alertAction.style == PPAlertActionStyleDestructive) {
          [_actionSheet setDestructiveButtonIndex:buttonIndex];
        }
      }];
    } else {
      _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
      [actions enumerateObjectsUsingBlock:^(PPAlertAction *alertAction, NSUInteger index, BOOL *stop) {
        PPAlertActionHandler handler = [alertAction.handler copy];
        __weak PPActionSheetControllerSubclass *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:alertAction.title style:(UIAlertActionStyle)alertAction.style handler:^(UIAlertAction *action1) {
          if (handler) {
            handler();
          }
          [weakSelf _invalidActions];
        }];
        [_alertController addAction:action];
      }];
    }
  }
  return self;
}

- (void)showOnceFromViewController:(UIViewController *)presenter
{
  [self intendToShowAlert];
  if (![UIAlertController class]) {
    [_actionSheet showInView:presenter.view];
  } else {
    [presenter presentViewController:_alertController animated:YES completion:nil];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  PPAlertAction *alertAction = _actions[buttonIndex];
  if (alertAction.handler) {
    alertAction.handler();
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  [self _invalidActions];
}

- (void)_invalidActions
{
  _actions = nil;
  _actionSheet.delegate = nil;
  _actionSheet = nil;
  _alertController = nil;

  [self.delegate alertControllerDidInvalid:self];
}
@end
