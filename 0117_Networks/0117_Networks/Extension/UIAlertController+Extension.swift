//
//  UIAlertController+Extension.swift
//  0117_Networks
//
//  Created by 김태형 on 1/22/25.
//

import UIKit

extension UIAlertController {
    static func setErrorAlert(_ text: String) -> UIAlertController {
        let alert = UIAlertController(
            title: "에러", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)

        return alert
    }
}
