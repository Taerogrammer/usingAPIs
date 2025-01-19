//
//  Topic.swift
//  0117_Networks
//
//  Created by 김태형 on 1/19/25.
//

import Foundation

struct Topic: Decodable {
    let topicDetail: [TopicDetail]
}

struct TopicDetail: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: TopicUrl
    let likes: Int
    let user: TopicUser
}

struct TopicUrl: Decodable {
    let raw: String
    let small: String
}

struct TopicUser: Decodable {
    let name: String
    let profile_image: TopicUserProfileImage
}

struct TopicUserProfileImage: Decodable {
    let medium: String
}
