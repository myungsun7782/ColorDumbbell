//
//  MainBottomCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/13.
//

import UIKit
import RxSwift
import Charts

class MainBottomCell: UITableViewCell {
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // HorizontalBarChartView
    @IBOutlet weak var currentMonthChartView: HorizontalBarChartView!
    @IBOutlet weak var previousMonthChartView: HorizontalBarChartView!
    
    // UILabel
    @IBOutlet weak var currentMonthCountLabel: UILabel!
    @IBOutlet weak var previousMonthCountLabel: UILabel!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    
    // Constants
    let STACK_VIEW_BORDER_WIDTH: CGFloat = 1
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    let CHART_ANIMATION_DURATION: CGFloat = 1
    let CHART_VIEW_AXIS_MAXIMUM: Double = 31
    let CHART_VIEW_AXIS_MINIMUM: Double = 0
    let CHART_BAR_WIDTH: CGFloat = 1
    let CURRENT_MONTH_EMPTY_STRING: String = "이번 달에 아직 운동하지 않았습니다."
    let PREVIOUS_MONTH_EMPTY_STRING: String = "지날 달에 운동하지 않았습니다."
    let EMPTY_FONT_SIZE: CGFloat = 13
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func initUI() {
        // UIStackView
        configureStackView()
        
        // ChartView
        configureChart()
    }
    
    private func configureStackView() {
        containerStackView.layer.borderWidth = STACK_VIEW_BORDER_WIDTH
        containerStackView.layer.borderColor = ColorManager.shared.getBrightGray().cgColor
        containerStackView.layer.cornerRadius = STACK_VIEW_CORNER_RADIUS
    }
    
    private func configureChart() {
        // currentMonthChartView
        currentMonthChartView.noDataText = CURRENT_MONTH_EMPTY_STRING
        currentMonthChartView.noDataFont = FontManager.shared.getPretendardMedium(fontSize: EMPTY_FONT_SIZE)
        currentMonthChartView.noDataTextColor = ColorManager.shared.getLightSilver()
        currentMonthChartView.xAxis.labelPosition = .bottom
        currentMonthChartView.xAxis.drawGridLinesEnabled = false
        currentMonthChartView.xAxis.enabled = false
        currentMonthChartView.leftAxis.enabled = false
        currentMonthChartView.rightAxis.enabled = false
        currentMonthChartView.leftAxis.drawGridLinesEnabled = false
        currentMonthChartView.legend.enabled = false
        currentMonthChartView.doubleTapToZoomEnabled = false
        currentMonthChartView.leftAxis.axisMaximum = CHART_VIEW_AXIS_MAXIMUM
        currentMonthChartView.leftAxis.axisMinimum = CHART_VIEW_AXIS_MINIMUM
        
        // previousMonthChartView
        previousMonthChartView.noDataText = PREVIOUS_MONTH_EMPTY_STRING
        previousMonthChartView.noDataFont = FontManager.shared.getPretendardMedium(fontSize: EMPTY_FONT_SIZE)
        previousMonthChartView.noDataTextColor = ColorManager.shared.getLightSilver()
        previousMonthChartView.xAxis.labelPosition = .bottom
        previousMonthChartView.xAxis.drawGridLinesEnabled = false
        previousMonthChartView.xAxis.enabled = false
        previousMonthChartView.leftAxis.enabled = false
        previousMonthChartView.rightAxis.enabled = false
        previousMonthChartView.leftAxis.drawGridLinesEnabled = false
        previousMonthChartView.legend.enabled = false
        previousMonthChartView.doubleTapToZoomEnabled = false
        previousMonthChartView.leftAxis.axisMaximum = CHART_VIEW_AXIS_MAXIMUM
        previousMonthChartView.leftAxis.axisMinimum = CHART_VIEW_AXIS_MINIMUM
    }
    
    
    private func setCurrentChart(currentMonthCount: Int) {
        let dataEntries: [BarChartDataEntry] = [
            BarChartDataEntry(x: .zero, y: Double(currentMonthCount))
        ]
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = LevelManager.shared.getCurrentGradientColor(exerciseTotalCount: UserDefaultsManager.shared.getExerciseTotalCount())
        chartDataSet.highlightEnabled = false
        chartDataSet.drawValuesEnabled = false
        setCurrentChartDataSet(chartDataSet: chartDataSet)
        currentMonthChartView.animate(yAxisDuration: CHART_ANIMATION_DURATION)
    }
    
    private func setCurrentChartDataSet(chartDataSet: BarChartDataSet) {
        let chartData = BarChartData(dataSet: chartDataSet)
        currentMonthChartView.data = chartData
        chartData.barWidth = CHART_BAR_WIDTH
    }
    
    private func setPreviousChart(previousMonthCount: Int) {
        let dataEntries: [BarChartDataEntry] = [
            BarChartDataEntry(x: .zero, y: Double(previousMonthCount))
        ]
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = [ColorManager.shared.getLightGray(), ColorManager.shared.getQuickSilver()]
        chartDataSet.highlightEnabled = false
        chartDataSet.drawValuesEnabled = false
        setPreviousChartDataSet(chartDataSet: chartDataSet)
        previousMonthChartView.animate(yAxisDuration: CHART_ANIMATION_DURATION)
    }
    
    private func setPreviousChartDataSet(chartDataSet: BarChartDataSet) {
        let chartData = BarChartData(dataSet: chartDataSet)
        previousMonthChartView.data = chartData
        chartData.barWidth = CHART_BAR_WIDTH
    }
    
    func setData(currentMonthCount: Int, previousMonthCount: Int) {
        currentMonthCountLabel.text = "\(currentMonthCount)"
        previousMonthCountLabel.text = "\(previousMonthCount)회"
        if currentMonthCount != .zero {
            setCurrentChart(currentMonthCount: currentMonthCount)
        }
        if previousMonthCount != .zero {
            setPreviousChart(previousMonthCount: previousMonthCount)
        }
        currentMonthChartView.notifyDataSetChanged()
        previousMonthChartView.notifyDataSetChanged()
    }
}
