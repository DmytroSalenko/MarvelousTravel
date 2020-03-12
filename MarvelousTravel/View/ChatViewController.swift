//
//  ViewController.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-21.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    let chatService = ChatService()
    let userService = UserService(config: URLSessionConfiguration.default)
    let messageService = MessageService()
    var chatID : String?
    
    var currentUser : User?
    var userMiniPicture : UIImage?
    var messages : [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCurrentUser()
        loadChat()
        getUserMiniPicture()
        setupDependencies()
        reloadCollection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatMessageNotification(notification:)), name: NSNotification.Name(rawValue: "newChatMessageNotification"), object: nil)
    }
    
    @objc func handleNewChatMessageNotification(notification : NSNotification) {
        let newChatMessage = notification.object as! Message
        insertNewMessage(newChatMessage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SocketIOManager.sharedInstance.establishConnection()
        reloadCollection()
    }
    
    
    func currentSender() -> SenderType {
        return Sender(senderId: currentUser?._id ?? "Not found", displayName: currentUser?.last_name ?? "Not found")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
    
    // fetch chat in here
    func loadChat() {
        guard let chatId = chatID else {return}
        chatService.getSingleChat(chatId: chatId) { (chat, error) in
            if let chat = chat {
                self.messages = chat.chatMessages
                //
                self.reloadCollection()
            } else {
                print("Error")
            }
        }
    }
    
    func getUserMiniPicture() {
        userService.getMiniPicture { (image, error) in
            if let image = image {
                self.userMiniPicture = image
            }
        }
    }
    
    func reloadCollection() {
        DispatchQueue.main.async {
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    
    func insertNewMessage(_ message: Message) {
    messages.append(message)
        
    reloadCollection()
        
    }
    
    private func sendMessage(_ message: Message) {

        messageService.sendMessage(message: message) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful")
                self.messagesCollectionView.scrollToBottom()
            }
        }
    }
    
    private func getCurrentUser() {
            self.userService.getSingleUser { (user, error) in
                if let user = user {
                    self.currentUser = user
                    print(self.currentUser!.email)
                }
            }
    }
    
    private func setupDependencies() {
        self.title = "Chat"
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .gray
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
    }

}

extension ChatViewController {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let now = Date()
        var typedMessage = Message()
        typedMessage.chatId = "5e34bb82de34b31645b4ec9b"
        typedMessage.userId = currentUser?._id
        typedMessage.messageBody = text
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        typedMessage.date = formatter.string(from: today)
        
       // MARK: this is a workaround to fix io.emit
       // insertNewMessage(typedMessage)
        sendMessage(typedMessage)
        
        inputBar.inputTextView.text = ""
        reloadCollection()
    }
}


extension ChatViewController {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
          string: name,
          attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor(white: 0.3, alpha: 1)
          ]
        )
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
}

extension ChatViewController {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .lightGray
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentUser?._id {
            // load image here
            if let mini = userMiniPicture {
            avatarView.image = userMiniPicture!
            } else {
                avatarView.image = UIImage(named: "swift")
            }
        } else {
            avatarView.image = UIImage(named: "swift")
        }
        
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}
