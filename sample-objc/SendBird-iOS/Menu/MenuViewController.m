//
//  MenuViewController.m
//  SendBird-iOS
//
//  Created by Jed Kyung on 9/19/16.
//  Copyright © 2016 SendBird. All rights reserved.
//

#import <SendBirdSDK/SendBirdSDK.h>

#import "MenuViewController.h"
#import "OpenChannelListViewController.h"
#import "GroupChannelListViewController.h"
#import "NSBundle+SendBird.h"
#import "Constants.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIView *openChannelView;
@property (weak, nonatomic) IBOutlet UIView *groupChannelView;

@property (weak, nonatomic) IBOutlet UIImageView *openChannelCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groupChannelCheckImageView;

@property (strong, nonatomic) GroupChannelListViewController *groupChannelListViewController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.openChannelCheckImageView.hidden = YES;
    self.groupChannelCheckImageView.hidden = YES;
    
    UIBarButtonItem *negativeRightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeRightSpacer.width = -2;
    UIBarButtonItem *rightDisconnectItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle sbLocalizedStringForKey:@"DisconnectButton"] style:UIBarButtonItemStylePlain target:self action:@selector(disconnect)];
    [rightDisconnectItem setTitleTextAttributes:@{NSFontAttributeName: [Constants navigationBarButtonItemFont]} forState:UIControlStateNormal];
    self.navItem.rightBarButtonItems = @[negativeRightSpacer, rightDisconnectItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressOpenChannelButton:(id)sender {
    self.openChannelView.backgroundColor = [UIColor colorWithRed:(CGFloat)(248.0/255.0) green:(CGFloat)(248.0/255.0) blue:(CGFloat)(248.0/255.0) alpha:1];
    self.groupChannelView.backgroundColor = [UIColor whiteColor];
    
    self.openChannelCheckImageView.hidden = NO;
    self.groupChannelCheckImageView.hidden = YES;
}

- (IBAction)clickOpenChannelButton:(id)sender {
    self.openChannelView.backgroundColor = [UIColor colorWithRed:(CGFloat)(248.0/255.0) green:(CGFloat)(248.0/255.0) blue:(CGFloat)(248.0/255.0) alpha:1];
    self.groupChannelView.backgroundColor = [UIColor whiteColor];
    
    self.openChannelCheckImageView.hidden = NO;
    self.groupChannelCheckImageView.hidden = YES;
    
    OpenChannelListViewController *vc = [[OpenChannelListViewController alloc] init];
    [self presentViewController:vc animated:NO completion:^{
        vc.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (IBAction)pressGroupChannelButton:(id)sender {
    self.openChannelView.backgroundColor = [UIColor whiteColor];
    self.groupChannelView.backgroundColor = [UIColor colorWithRed:(CGFloat)(248.0/255.0) green:(CGFloat)(248.0/255.0) blue:(CGFloat)(248.0/255.0) alpha:1];
    
    self.openChannelCheckImageView.hidden = YES;
    self.groupChannelCheckImageView.hidden = NO;
}

- (IBAction)clickGroupChannelButton:(id)sender {
    self.openChannelView.backgroundColor = [UIColor whiteColor];
    self.groupChannelView.backgroundColor = [UIColor colorWithRed:(CGFloat)(248.0/255.0) green:(CGFloat)(248.0/255.0) blue:(CGFloat)(248.0/255.0) alpha:1];
    
    self.openChannelCheckImageView.hidden = YES;
    self.groupChannelCheckImageView.hidden = NO;
    
    if (self.groupChannelListViewController == nil) {
        self.groupChannelListViewController = [[GroupChannelListViewController alloc] init];
        [self.groupChannelListViewController addDelegates];
    }
    
    [self presentViewController:self.groupChannelListViewController animated:NO completion:^{
        self.groupChannelListViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)disconnect {
    if (self.groupChannelListViewController != nil) {
        [self.groupChannelListViewController removeDelegates];
    }
    
    [SBDMain unregisterAllPushTokenWithCompletionHandler:^(NSDictionary * _Nullable response, SBDError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unregister all push tokens. Error: %@", error);
        }
        
        [SBDMain disconnectWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        }];
    }];
}

@end
