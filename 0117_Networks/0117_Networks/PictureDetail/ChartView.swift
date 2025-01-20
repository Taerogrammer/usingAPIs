//
//  ChartView.swift
//  0117_Networks
//
//  Created by 김태형 on 1/20/25.
//

import SwiftUI
import Charts

struct SavingModel: Identifiable {
    let id = UUID()
    let amount: Double
    let createAt: Date
}

struct ChartView: View {
    let list = [
        SavingModel(amount: 124, createAt: Date() - 54),
        SavingModel(amount: 64, createAt: Date() - 44),
        SavingModel(amount: 421, createAt: Date() - 41),
        SavingModel(amount: 124, createAt: Date() - 32),
        SavingModel(amount: 52, createAt: Date() - 21),
        SavingModel(amount: 122, createAt: Date() - 11),
        SavingModel(amount: 144, createAt: Date() - 1)
    ]

    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()

    var body: some View {
        Chart(list) { savingModel in
            LineMark(x: .value("Month", savingModel.createAt), y: .value("Dollar", savingModel.amount)
            ).foregroundStyle(.red)
        }
    }
}
