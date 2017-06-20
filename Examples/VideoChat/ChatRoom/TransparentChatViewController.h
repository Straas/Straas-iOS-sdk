//
//  TransparentChatViewController.h
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"

@protocol DataChannelEventDelegate <NSObject>

- (void)aggregatedItemsAdded:(NSArray<STSAggregatedItem *> *)aggregatedItems;
- (void)rawDataAdded:(STSChatMessage *)rawData;
- (void)chatroomDidConnected:(STSChat *)chatroom;
    
@end

static NSString *TransparentMessengerCellIdentifier = @"TransparentMessengerCell";

@interface TransparentChatViewController : ChatViewController

@property (weak, nonatomic) id<DataChannelEventDelegate> dataChannelDelegate;

@end
