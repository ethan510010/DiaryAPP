//
//  ViewController.swift
//  DiaryApp
//
//  Created by EthanLin on 2018/1/19.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    //處理是否被點到的事件
    var didTapedArray = [Bool]()
    
    
    //取得當前年份及月份
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    
    //得到每個月的天數 用計算屬性
    var numberOfDaysInEachMonth:Int{
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        guard let date = Calendar.current.date(from: dateComponents) else {
            return 0
        }
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }
    
    //修正每次都是從1開始的錯誤 新增兩個屬性
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    
    var howManyItemsShouldIAdd:Int{
        return whatDayIsIt - 1
    }
    
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    
    @IBAction func goBackToLastMonth(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
            //如果年份變成0強制變成1年1月
            if currentYear == 0{
                currentYear = 1
                currentMonth = 1
            }
        }
        //再重新顯示日期
        setUp()
    }
    
    
    @IBAction func goToNextMonth(_ sender: UIButton) {
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        //重新顯示日期
        setUp()
    }
    
    //設定collectionView顯示內容
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //讓裡面的項目配合每個月的天數
        return numberOfDaysInEachMonth + howManyItemsShouldIAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
       
        if indexPath.item < howManyItemsShouldIAdd{
            dayCell.dayLabel.text = ""
        }else{
            dayCell.dayLabel.text = "\(indexPath.item + 1 - howManyItemsShouldIAdd)"
        }
        
        //被點擊到的時候的外觀處理
        for i in 1...(numberOfDaysInEachMonth + (howManyItemsShouldIAdd - 1) ){
                didTapedArray.append(false)
            }
        
        if didTapedArray[indexPath.item] == true{
            dayCell.contentView.backgroundColor = .orange
            if dayCell.dayLabel.text == ""{
                 dayCell.contentView.backgroundColor = UIColor.clear
            }
        }else{
            dayCell.contentView.backgroundColor = UIColor.clear
        }
        
       return dayCell
    }
    
    //處理點擊到後的事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in 0...didTapedArray.count - 1{
            didTapedArray[item] = false
        }
        didTapedArray[indexPath.item] = true
        calendarCollectionView.reloadData()
        
//        print(indexPath.item)
    }
    
    //  設定collectionView的layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calendarCollectionView.frame.width / 7
        //讓長寬一樣像正方形
        return CGSize(width: width, height: width)
    }
    
    //讓轉向後還是可以維持我想要的layout
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        calendarCollectionView.collectionViewLayout.invalidateLayout()
//    }
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定日期
        setUp()
        
        //設定collectionView的代理
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }

    
    //設定日期的方法
    func setUp() {
        yearMonthLabel.text = "\(currentYear)年" + " " + months.months[currentMonth-1]
        calendarCollectionView.reloadData()
//        print(whatDayIsIt)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

