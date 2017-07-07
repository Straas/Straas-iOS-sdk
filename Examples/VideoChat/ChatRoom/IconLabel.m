//
//  IconLabel.m
//  StraaS
//
//  Created by shihwen.wang on 2017/2/16.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import "IconLabel.h"
#import <Foundation/Foundation.h>

@interface IconLabel()
@property (nonatomic, nullable) NSTextAttachment * attachment;
@end

@implementation IconLabel

- (void)setIconImage:(UIImage *)image {
    if (!image) {
        self.attachment = nil;
        return;
    }
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    self.attachment = attachment;
}

- (void)setAttachment:(NSTextAttachment *)attachment {
    if ([_attachment isEqual:attachment]) {
        return;
    }
    _attachment = attachment;
    if (self.attributedText) {
        NSMutableAttributedString * attributedText = [self.attributedText mutableCopy];
        [attributedText removeAttribute:NSAttachmentAttributeName range:NSMakeRange(0, 1)];
        if (attachment) {
            NSMutableAttributedString * tempAttributedText =
            [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
            [tempAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [attributedText insertAttributedString:tempAttributedText atIndex:0];
        } else {
            [attributedText.mutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
        }
        self.attributedText = attributedText;
        [self sizeToFit];
        return;
    }
    [self setText:self.text];
}

- (void)setText:(NSString *)text {
    if (!self.attachment || [text length] == 0) {
        self.attributedText = nil;
        [super setText:text];
        return;
    }
    NSMutableAttributedString * attributedText =
    [[NSAttributedString attributedStringWithAttachment:self.attachment] mutableCopy];
    NSString * textToAppend = [NSString stringWithFormat:@" %@", text];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:textToAppend]];
    self.attributedText = attributedText;
    [self sizeToFit];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
}

@end
