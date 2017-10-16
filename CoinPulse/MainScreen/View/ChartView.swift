//
//  ChartView.swift
//  CoinPulse
//
//  Created by macbook on 16.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import Charts

class ChartView: LineChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        var lineChartEntries: [ChartDataEntry] = []
        for i in 0..<10 {
            let data = ChartDataEntry(x: Double(i), y: Double(200 + arc4random_uniform(30)))
            lineChartEntries.append(data)
        }
        self.doubleTapToZoomEnabled = false
        self.pinchZoomEnabled = false
        self.scaleYEnabled = false
        self.scaleXEnabled = false
        self.dragEnabled = false
        self.xAxis.enabled = true
        self.xAxis.labelCount = 3
        self.xAxis.gridColor = .lightGray
        self.xAxis.axisLineColor = .lightGray
        self.xAxis.labelTextColor = .lightGray
        self.xAxis.gridLineDashLengths = [7]
        self.rightAxis.gridColor = .lightGray
        self.rightAxis.labelTextColor = .lightGray
        self.rightAxis.axisLineColor = .lightGray
        self.rightAxis.gridLineDashLengths = [7]
        self.rightAxis.valueFormatter = ChartNumberFormatter()
        self.xAxis.labelPosition = .bottom
        self.xAxis.valueFormatter = ChartDateFormatter()
        self.leftAxis.enabled = false
        self.backgroundColor = Color.ultraDarkBlue
        self.chartDescription?.enabled = false
        self.legend.enabled = false
        self.highlightPerDragEnabled = false
        self.highlightPerTapEnabled = false
        
        self.noDataTextColor = .white
        self.noDataFont = UIFont.systemFont(ofSize: 20)
        self.noDataText = "Loading data..."
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateChartView(with value: [ChartDataEntry]){
        
        let lineDataSet = LineChartDataSet(values: value, label: "")
        lineDataSet.colors = [.blue]
        lineDataSet.cubicIntensity = 0.2
        lineDataSet.mode = .cubicBezier
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.lineWidth = 1.5
        lineDataSet.drawValuesEnabled = false
        lineDataSet.fillColor = .blue
        lineDataSet.drawFilledEnabled = true
        lineDataSet.lineCapType = .round
        
        let data = LineChartData(dataSet: lineDataSet)
        self.data = data
    }
}











