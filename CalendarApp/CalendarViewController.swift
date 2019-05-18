//
//  CalendarViewController.swift
//  CalendarApp
//
//  Created by 大川葵 on 2019/05/18.
//  Copyright © 2019 Nexceed. All rights reserved.
//

import Foundation
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        view.addSubview(calendar)
        
        formatter.dateFormat = "yyyy/MM/dd"
        self.todayLabel.text = formatter.string(from: Date())
        view.addSubview(todayLabel)
        
        self.calendar.allowsMultipleSelection = true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    private let gregorian: Calendar = Calendar(identifier: .gregorian)
    private lazy var formatter = DateFormatter()
    
    // 祝日判定
    func judgeHoliday(_ date : Date) -> Bool {
        
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // 日付判定
    func getDay(_ date: Date) -> (Int, Int, Int) {
        
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        return (year, month, day)
    }
    
    // 曜日判定
    func getWeekIdx(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // FSCalendarDelegateAppearance
    // 土日と祝日のフォントの色変更
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if self.judgeHoliday(date) {
            return UIColor.red
        }
        
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor.red
        } else if weekday == 7 {
            return UIColor.blue
        }
        return nil
    }
    
    // 日付を選択されたらその日付をテキストとして表示
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let year = gregorian.component(.year, from: date)
        let month = gregorian.component(.month, from: date)
        let day = gregorian.component(.day, from: date)
        let y = String(format: "%d", year)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        
        self.selectedLabel.text = "\(y)/\(m)/\(d)"
        view.addSubview(selectedLabel)
    }
    
}
