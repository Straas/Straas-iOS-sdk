//
//  TransparentChatViewController.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "TransparentChatViewController.h"
#import "TransparentMessageTableViewCell.h"

@interface TransparentChatViewController ()
@end

@implementation TransparentChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[TransparentMessageTableViewCell class]
           forCellReuseIdentifier:TransparentMessengerCellIdentifier];
    
    [self setTextInputbarHidden:YES];
    [self clearCachedText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STSChatMessage * message = self.messages[indexPath.row];
    
    TransparentMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TransparentMessengerCellIdentifier
                                                                                 forIndexPath:indexPath];
    NSString *nameString = [NSString stringWithFormat:@"%@: ", message.creator.name];
    NSString *text = [NSString stringWithFormat:@"%@%@", nameString, message.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor orangeColor]
                             range:NSMakeRange(0, nameString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:NSMakeRange(nameString.length, message.text.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:16]
                             range:NSMakeRange(0, text.length)];
    [cell setBodyAttributedText:attributedString];
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 36;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Override Methods

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status {
    if (status == SLKKeyboardStatusWillShow) {
        self.textInputbarHidden = NO;
        self.tableView.hidden = YES;
    }
    else if (status == SLKKeyboardStatusWillHide) {
        self.textInputbarHidden = YES;
        self.tableView.hidden = NO;
    }
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder {
    return YES;
}

- (void)didPressRightButton:(id)sender {
    self.textInputbarHidden = YES;
    
    [super didPressRightButton:sender];
}

@end