//
//  PictureDetailViewController.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import SwiftUI
import Kingfisher
import SnapKit

final class PictureDetailViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let infoLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let downloadsText = UILabel()
    private let viewsLabel = UILabel()
    private let viewsText = UILabel()
    private let chartLabel = UILabel()
    private let segmentedControl = UISegmentedControl()
    private var chartHostingController: UIHostingController<ChartView>?

    var viewData: [HistoryValue] = []
    var downloadData: [HistoryValue] = []
    var historyData: [HistoryValue] = []    // ChartView에 전달될 데이터

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(), configureLayout(), configureView(), configureChartView()].forEach { $0 }
    }
}

// MARK: UI
extension PictureDetailViewController: ViewConfiguration {
    func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView, infoLabel, downloadsLabel, downloadsText, viewsLabel, viewsText, chartLabel, segmentedControl].forEach { contentView.addSubview($0) }
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.width.equalTo(contentView)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).inset(20)
        }
        viewsLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoLabel.snp.trailing).offset(44)
            make.centerY.equalTo(infoLabel)
        }
        viewsText.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(viewsLabel)
        }
        downloadsLabel.snp.makeConstraints { make in
            make.leading.equalTo(viewsLabel)
            make.top.equalTo(viewsLabel.snp.bottom).offset(24)
//            make.bottom.equalTo(contentView).inset(20)
        }
        downloadsText.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(downloadsLabel)
        }
        chartLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoLabel)
            make.top.equalTo(downloadsLabel.snp.bottom).offset(32)
        }
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(chartLabel)
            make.leading.equalTo(chartLabel.snp.trailing).offset(24)
        }
    }
    
    func configureView() {

        imageView.contentMode = .scaleAspectFill
        infoLabel.text = "정보"
        infoLabel.font = .boldSystemFont(ofSize: 24)
        viewsLabel.text = "조회수"
        viewsLabel.font = .boldSystemFont(ofSize: 14)
        viewsText.font = .systemFont(ofSize: 14)
        downloadsLabel.text = "다운로드"
        downloadsLabel.font = .boldSystemFont(ofSize: 14)
        downloadsText.font = .systemFont(ofSize: 14)
        chartLabel.text = "차트"
        chartLabel.font = .boldSystemFont(ofSize: 24)

        segmentedControl.insertSegment(withTitle: "조회", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "다운로드", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedTapped), for: .valueChanged)
    }

    func configureDetail(with detail: PhotoDetail) {
        downloadsText.text = "\(detail.downloads.total.formatted())"
        viewsText.text = "\(detail.views.total.formatted())"

        downloadData = detail.downloads.historical.values
        viewData = detail.views.historical.values
        historyData = viewData
    }

    func configureImage(with photoId: String) {
        let url = URL(string: photoId)
        imageView.kf.setImage(with: url)
    }
}

// MARK: Chart
extension PictureDetailViewController {
    private func configureChartView() {
        let chartView = ChartView(data: viewData)
        let controller = UIHostingController(rootView: chartView)
        self.chartHostingController = controller

        guard let chartUIView = controller.view else { return }
        contentView.addSubview(chartUIView)

        chartUIView.snp.makeConstraints { make in
            make.top.equalTo(chartLabel.snp.bottom).offset(24)
            make.width.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(60)
            make.height.equalTo(400)
        }
    }
    private func updateChartView() {
        let updatedChartView = ChartView(data: historyData)
        chartHostingController?.rootView = updatedChartView
    }
}

// MARK: @objc
extension PictureDetailViewController {
    @objc private func segmentedTapped(_ segment: UISegmentedControl) {
        let isViews = segment.selectedSegmentIndex == 0
        historyData = isViews ? viewData : downloadData
        updateChartView()
    }
}
