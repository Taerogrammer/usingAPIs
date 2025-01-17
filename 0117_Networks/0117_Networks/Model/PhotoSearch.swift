//
//  PhotoSearch.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import Foundation

struct PictureSearch: Decodable {
    let totalPages: Int
    let results: [PictureResult]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

struct PictureResult: Decodable {
    let id: String
    let urls: PictureURL
    let likes: Int
    let likedByUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case likes
        case likedByUser = "liked_by_user"
    }
}

struct PictureURL: Decodable {
    let full: String
}


// 더미 데이터 생성
let dummyData = PictureSearch(
    totalPages: 3,
    results: [
        PictureResult(
            id: "1",
            urls: PictureURL(full: "https://example.com/image1.jpg"),
            likes: 15,
            likedByUser: false
        ),
        PictureResult(
            id: "2",
            urls: PictureURL(full: "https://example.com/image2.jpg"),
            likes: 27,
            likedByUser: true
        ),
        PictureResult(
            id: "3",
            urls: PictureURL(full: "https://example.com/image3.jpg"),
            likes: 42,
            likedByUser: false
        ),
        PictureResult(
            id: "4",
            urls: PictureURL(full: "https://example.com/image1.jpg"),
            likes: 15,
            likedByUser: false
        ),
        PictureResult(
            id: "5",
            urls: PictureURL(full: "https://example.com/image2.jpg"),
            likes: 27,
            likedByUser: true
        ),
        PictureResult(
            id: "6",
            urls: PictureURL(full: "https://example.com/image3.jpg"),
            likes: 42,
            likedByUser: false
        ),
        PictureResult(
            id: "7",
            urls: PictureURL(full: "https://example.com/image1.jpg"),
            likes: 15,
            likedByUser: false
        ),
        PictureResult(
            id: "8",
            urls: PictureURL(full: "https://example.com/image2.jpg"),
            likes: 27,
            likedByUser: true
        ),
        PictureResult(
            id: "9",
            urls: PictureURL(full: "https://example.com/image3.jpg"),
            likes: 42,
            likedByUser: false
        )
    ]
)





//    {
////        "total": 56,
//        "total_pages": 3,
//        "results": [
//            {
//                "id": "V1DFo8C4JPA",
////                "slug": "a-concept-car-is-shown-in-the-dark-V1DFo8C4JPA",
////                "alternative_slugs": {
////                    "en": "a-concept-car-is-shown-in-the-dark-V1DFo8C4JPA",
////                    "es": "un-concept-car-se-muestra-en-la-oscuridad-V1DFo8C4JPA",
////                    "ja": "暗闇の中でコンセプトカーが映し出される-V1DFo8C4JPA",
////                    "fr": "un-concept-car-est-montre-dans-lobscurite-V1DFo8C4JPA",
////                    "it": "una-concept-car-viene-mostrata-al-buio-V1DFo8C4JPA",
////                    "ko": "어둠-속에서-콘셉트카가-보인다-V1DFo8C4JPA",
////                    "de": "ein-konzeptfahrzeug-wird-im-dunkeln-gezeigt-V1DFo8C4JPA",
////                    "pt": "um-carro-conceito-e-mostrado-no-escuro-V1DFo8C4JPA"
////                },
////                "created_at": "2024-01-04T03:50:05Z",
////                "updated_at": "2025-01-13T21:47:53Z",
////                "promoted_at": null,
////                "width": 4000,
////                "height": 2110,
////                "color": "#d9c0a6",
////                "blur_hash": "LrFFHTayRjj[0Layayaz%LoLt7ay",
////                "description": "A sketch of the left side view of the Kia Concept EV4.",
////                "alt_description": "a concept car is shown in the dark",
////                "breadcrumbs": [],
//                "urls": {
//                    "raw": "https://images.unsplash.com/photo-1704340142770-b52988e5b6eb?ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww&ixlib=rb-4.0.3",
//                    "full": "https://images.unsplash.com/photo-1704340142770-b52988e5b6eb?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww&ixlib=rb-4.0.3&q=85",
//                    "regular": "https://images.unsplash.com/photo-1704340142770-b52988e5b6eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww&ixlib=rb-4.0.3&q=80&w=1080",
//                    "small": "https://images.unsplash.com/photo-1704340142770-b52988e5b6eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww&ixlib=rb-4.0.3&q=80&w=400",
//                    "thumb": "https://images.unsplash.com/photo-1704340142770-b52988e5b6eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww&ixlib=rb-4.0.3&q=80&w=200",
//                    "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1704340142770-b52988e5b6eb"
//                },
////                "links": {
////                    "self": "https://api.unsplash.com/photos/a-concept-car-is-shown-in-the-dark-V1DFo8C4JPA",
////                    "html": "https://unsplash.com/photos/a-concept-car-is-shown-in-the-dark-V1DFo8C4JPA",
////                    "download": "https://unsplash.com/photos/V1DFo8C4JPA/download?ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww",
////                    "download_location": "https://api.unsplash.com/photos/V1DFo8C4JPA/download?ixid=M3w2OTgwMDF8MXwxfHNlYXJjaHwxfHxjYXJ8ZW58MHx8Mnx5ZWxsb3d8MTczNzEwNDMxNnww"
////                },
//                "likes": 1,
//                "liked_by_user": false,
////                "current_user_collections": [],
////                "sponsorship": {
////                    "impression_urls": [],
////                    "tagline": "Our vision is clear: Progress for Humanity.",
////                    "tagline_url": "https://www.hyundaimotorgroup.com/main/mainRecommend",
////                    "sponsor": {
////                        "id": "hfrh7ZJApJQ",
////                        "updated_at": "2025-01-15T16:07:53Z",
////                        "username": "hyundaimotorgroup",
////                        "name": "Hyundai Motor Group",
////                        "first_name": "Hyundai Motor Group",
////                        "last_name": null,
////                        "twitter_username": null,
////                        "portfolio_url": "https://www.hyundaimotorgroup.com",
////                        "bio": null,
////                        "location": null,
////                        "links": {
////                            "self": "https://api.unsplash.com/users/hyundaimotorgroup",
////                            "html": "https://unsplash.com/@hyundaimotorgroup",
////                            "photos": "https://api.unsplash.com/users/hyundaimotorgroup/photos",
////                            "likes": "https://api.unsplash.com/users/hyundaimotorgroup/likes",
////                            "portfolio": "https://api.unsplash.com/users/hyundaimotorgroup/portfolio",
////                            "following": "https://api.unsplash.com/users/hyundaimotorgroup/following",
////                            "followers": "https://api.unsplash.com/users/hyundaimotorgroup/followers"
////                        },
////                        "profile_image": {
////                            "small": "https://images.unsplash.com/profile-1667725587447-c153854a19dcimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32",
////                            "medium": "https://images.unsplash.com/profile-1667725587447-c153854a19dcimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64",
////                            "large": "https://images.unsplash.com/profile-1667725587447-c153854a19dcimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"
////                        },
////                        "instagram_username": "hyundaimotorgroup.official",
////                        "total_collections": 80,
////                        "total_likes": 0,
////                        "total_photos": 325,
////                        "total_promoted_photos": 0,
////                        "total_illustrations": 0,
////                        "total_promoted_illustrations": 0,
////                        "accepted_tos": true,
////                        "for_hire": false,
////                        "social": {
////                            "instagram_username": "hyundaimotorgroup.official",
////                            "portfolio_url": "https://www.hyundaimotorgroup.com",
////                            "twitter_username": null,
////                            "paypal_email": null
////                        }
////                    }
////                },
////                "topic_submissions": {},
////                "asset_type": "photo",
////                "user": {
////                    "id": "hfrh7ZJApJQ",
////                    "updated_at": "2025-01-15T16:07:53Z",
////                    "username": "hyundaimotorgroup",
////                    "name": "Hyundai Motor Group",
////                    "first_name": "Hyundai Motor Group",
////                    "last_name": null,
////                    "twitter_username": null,
////                    "portfolio_url": "https://www.hyundaimotorgroup.com",
////                    "bio": null,
////                    "location": null,
////                    "links": {
////                        "self": "https://api.unsplash.com/users/hyundaimotorgroup",
////                        "html": "https://unsplash.com/@hyundaimotorgroup",
////                        "photos": "https://api.unsplash.com/users/hyundaimotorgroup/photos",
////                        "likes": "https://api.unsplash.com/users/hyundaimotorgroup/likes",
////                        "portfolio": "https://api.unsplash.com/users/hyundaimotorgroup/portfolio",
////                        "following": "https://api.unsplash.com/users/hyundaimotorgroup/following",
////                        "followers": "https://api.unsplash.com/users/hyundaimotorgroup/followers"
////                    },
////                    "profile_image": {
////                        "small": "https://images.unsplash.com/profile-1667725587447-c153854a19dcimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32",
////                        "medium": "https://images.unsplash.com/profile-1667725587447-c153854a19dcimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64",
////                        "large": "https://images.unsplash.com/profile-1667725587447-c153854a19dcimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"
////                    },
////                    "instagram_username": "hyundaimotorgroup.official",
////                    "total_collections": 80,
////                    "total_likes": 0,
////                    "total_photos": 325,
////                    "total_promoted_photos": 0,
////                    "total_illustrations": 0,
////                    "total_promoted_illustrations": 0,
////                    "accepted_tos": true,
////                    "for_hire": false,
////                    "social": {
////                        "instagram_username": "hyundaimotorgroup.official",
////                        "portfolio_url": "https://www.hyundaimotorgroup.com",
////                        "twitter_username": null,
////                        "paypal_email": null
////                    }
////                }
//            },
//        }
