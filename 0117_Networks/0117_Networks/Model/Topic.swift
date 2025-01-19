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

let dummyTopics = Topic(topicDetail: [
    TopicDetail(
        id: "1a2b3c",
        created_at: "2024-07-22T14:03:52Z",
        width: 4000,
        height: 6000,
        urls: TopicUrl(
            raw: "https://example.com/raw1.jpg",
            small: "https://example.com/small1.jpg"
        ),
        likes: 120,
        user: TopicUser(
            name: "John Doe",
            profile_image: TopicUserProfileImage(
                medium: "https://example.com/profile1.jpg"
            )
        )
    ),
    TopicDetail(
        id: "4d5e6f",
        created_at: "2024-06-16T05:36:06Z",
        width: 4500,
        height: 3000,
        urls: TopicUrl(
            raw: "https://example.com/raw2.jpg",
            small: "https://example.com/small2.jpg"
        ),
        likes: 95,
        user: TopicUser(
            name: "Jane Smith",
            profile_image: TopicUserProfileImage(
                medium: "https://example.com/profile2.jpg"
            )
        )
    ),
    TopicDetail(
        id: "7g8h9i",
        created_at: "2024-05-10T12:45:33Z",
        width: 3200,
        height: 4800,
        urls: TopicUrl(
            raw: "https://example.com/raw3.jpg",
            small: "https://example.com/small3.jpg"
        ),
        likes: 210,
        user: TopicUser(
            name: "Alice Johnson",
            profile_image: TopicUserProfileImage(
                medium: "https://example.com/profile3.jpg"
            )
        )
    )
])
