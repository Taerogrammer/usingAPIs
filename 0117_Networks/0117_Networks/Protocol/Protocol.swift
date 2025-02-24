//
//  Protocol.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

protocol ViewConfiguration {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}

protocol DelegateConfiguration {
    func configureDelegate()
}
