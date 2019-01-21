//
//  ChatViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-20.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ChatViewController.h"
#import "../Models/Chat.h"
#import "../Models/User.h"
#import "../Models/Message.h"
#import "FIRDatabase.h"
#import "../Services/ChatService.h"

@interface ChatViewController ()
@property(nonatomic, strong)Chat *chat;
@property(nonatomic, strong)NSMutableArray *messages;
@property(nonatomic)JSQMessagesBubbleImage *outgoingBubbleImageView;
@property(nonatomic)JSQMessagesBubbleImage *incommingBubbleImageView;
@property(nonatomic) FIRDatabaseHandle messageHandle;
@property(nonatomic) FIRDatabaseReference *messageRef;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self JSQMessageVCSetup];
    [self observeMessages];
    _messages = [NSMutableArray array];
}

- (void)dealloc {
    if (self.messageHandle) [self.messageRef removeObserverWithHandle:self.messageHandle];
}

- (void)JSQMessageVCSetup {
    User *currentUser = [User getCurrentUser];
    self.senderId = [currentUser getUserUid];
    self.senderDisplayName = [currentUser getUsername];
    self.title = [self.chat getTitle];
    
    // set attachment button to be nil
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    // set avatar image to be nil
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    JSQMessagesBubbleImageFactory *bubbleImageFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageView = [bubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.incommingBubbleImageView =[bubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
}

- (void)setChat:(Chat *)chat {
    if (_chat != chat) _chat = chat;
}

- (IBAction)dismissButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// if chat key is nil, then there is no chat created, otherwise we will recieve the messages and update UI
- (void)observeMessages {
    NSString *chatKey = [self.chat getKey];
    if (!chatKey) return;
    else {
        self.messageHandle = [ChatService ObserveMessagesForChatKey:chatKey andCallBack:^(FIRDatabaseReference * _Nonnull ref, Message * _Nonnull message) {
            self.messageRef = ref;
            if (message) {
                NSLog(@"%@: observe message and add :%@", self.class, [message getContent]);
                [self.messages addObject:message];
                [self finishReceivingMessage];
            }
        }];
    }
}

// send the message if the chat is exist in the database, otherwise create the chat in database
//  and observe messages changes for UI update
- (void)sendMessage:(Message *)message {
    if (![self.chat getKey]) {
        [ChatService createChatFromMessage:message withChat:self.chat andCallBack:^(Chat *chat) {
            if (!chat) return;
            if (chat) {
                self.chat = chat;
                [self observeMessages];
            }
        }];
    }
    else {
        [ChatService sendMessage:message withChat:self.chat andCallBack:^(BOOL success) {
            if (success) NSLog(@"%@: send message successfully", self.class);
        }];
    }
}

// when pressed send button, create the message model and send the message with an alert sound
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    Message *message = [[Message alloc] initWithContent:text];
    [self sendMessage:message];
    [self finishSendingMessage];
    [JSQSystemSoundPlayer jsq_playMessageSentAlert];
}

#pragma mark - JSQMessagesCollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messages.count;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages[indexPath.item] getAsJSQMessage];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.item];
    User *sender = [message getSender];
    if ([sender getUserUid] == self.senderId) {
        return self.outgoingBubbleImageView;
    }
    else {
        return self.incommingBubbleImageView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.item];
    JSQMessagesCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.textView.textColor = ([[message getSender] getUserUid] == self.senderId) ? UIColor.whiteColor : UIColor.blackColor;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
