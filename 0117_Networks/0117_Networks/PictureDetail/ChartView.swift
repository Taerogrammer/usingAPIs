//
//  ChartView.swift
//  0117_Networks
//
//  Created by 김태형 on 1/20/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    let data: [HistoryValue]

    var body: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                if let date = data[index].date.toDate() {
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Value", data[index].value)
                    )
                    .foregroundStyle(.blue)
                }
            }
        }
        .frame(height: 300)
        .padding()
    }
}
