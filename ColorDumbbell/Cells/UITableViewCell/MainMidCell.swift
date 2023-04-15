//
//  MainMidCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/11.
//

import UIKit
import Charts
import RxSwift

class MainMidCell: UITableViewCell {
    // BarChartView
    @IBOutlet weak var chartView: BarChartView!
    
    // UIStackView
    @IBOutlet weak var containerStackView: UIStackView!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Variables
    var exerciseTimeArray: [Int]!
    
    // Constants
    let weekDays: [String] = [WeekDay.sun.rawValue, WeekDay.mon.rawValue, WeekDay.tue.rawValue, WeekDay.wed.rawValue, WeekDay.thu.rawValue, WeekDay.fri.rawValue, WeekDay.sat.rawValue]
    let STACK_VIEW_BORDER_WIDTH: CGFloat = 1
    let STACK_VIEW_CORNER_RADIUS: CGFloat = 7
    let CHART_EMPTY_TEXT: String = "이번 주 운동 일지 데이터가 없습니다."
    let CHART_EMPTY_TEXT_FONT_SIZE: CGFloat = 16
    let CHART_DATA_BAR_WIDTH: CGFloat = 0.3
    let CHART_X_AXIS_LABEL_FONT_SIZE: CGFloat = 12
    let CHART_DATA_SET_VALUE_FONT_SIZE: CGFloat = 12
    let CHART_ANIMATION_X_DURATION: CGFloat = 1
    let CHART_ANIMATION_Y_DURATION: CGFloat = 1
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
        chartView.noDataText = CHART_EMPTY_TEXT
        chartView.noDataFont = FontManager.shared.getPretendardMedium(fontSize: CHART_EMPTY_TEXT_FONT_SIZE)
        chartView.xAxis.labelFont = FontManager.shared.getPretendardRegular(fontSize: CHART_X_AXIS_LABEL_FONT_SIZE)
        chartView.xAxis.labelTextColor = ColorManager.shared.getBlackOlive()
        chartView.noDataTextColor = ColorManager.shared.getLightSilver()
        chartView.leftAxis.axisMaximum = 200
        chartView.leftAxis.axisMinimum = -5
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.setLabelCount(weekDays.count, force: false)
        chartView.rightAxis.enabled = false
    }
    
    private func setChartData(exerciseTimeArray: [Int]) {
        self.exerciseTimeArray = exerciseTimeArray
        setChart(dataPoints: weekDays, values: self.exerciseTimeArray)
        chartView.notifyDataSetChanged()
    }
    
    private func setChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = LevelManager.shared.getCurrentGradientColor(exerciseTotalCount: UserDefaultsManager.shared.getExerciseTotalCount())
        chartDataSet.valueFont = FontManager.shared.getPretendardRegular(fontSize: CHART_DATA_SET_VALUE_FONT_SIZE)
        chartDataSet.valueTextColor = ColorManager.shared.getPhilippineGray()
        configureChartDataSet(chartDataSet: chartDataSet, dataPoints: dataPoints)
        chartDataSet.highlightEnabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    private func configureChartDataSet(chartDataSet: BarChartDataSet, dataPoints: [String]) {
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartData.barWidth = CHART_DATA_BAR_WIDTH
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        chartData.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
    }
    
    func setData(exerciseTimeArray: [Int?]) {
        if !exerciseTimeArray.isEmpty {
            let nilCount = exerciseTimeArray.filter { $0 == nil }.count
            if nilCount != 7 {
                var preprocessingTimeArray: [Int] = Array<Int>()
                exerciseTimeArray.forEach { exerciseTime in
                    if let exerciseTime = exerciseTime {
                        preprocessingTimeArray.append(exerciseTime)
                    } else {
                        preprocessingTimeArray.append(.zero)
                    }
                    
                }
                setChartData(exerciseTimeArray: preprocessingTimeArray)
            }
        }
    }
}
