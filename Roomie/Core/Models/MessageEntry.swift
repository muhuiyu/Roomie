//
//  MessageEntry.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

struct MessageEntry {
    let senderID: String
    let receiverID: String
    let content: MessageContent
    let timestamp: Date
}


enum MessageType {
    case text
    case image
    case sticker
    case audio
//    case location
//    case gif
//    case music
}

enum MessageContent {
    case text(MessageContentTextEntry)
    case image(MessageContentImageEntry)
    case sticker(MessageContentStickerEntry)
    case audio(MessageContentAudioEntry)
}

enum MessageCellSource {
    case me
    case other
}

struct MessageContentTextEntry {
    let value: String
}
struct MessageContentImageEntry {
    let imageURL: String
}
struct MessageContentStickerEntry {
    let stickerID: String
}
struct MessageContentAudioEntry {
    let audioURL: String
}
