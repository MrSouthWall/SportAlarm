//
//  ViewModel.swift
//  SportAlarm
//
//  Created by MrSouthWall on 2025/7/14.
//

import Foundation
import Combine
import SwiftUI

@Observable
final class ViewModel {
    var isAlarming = false
    var currentDate = Date()
    var sportTime = Date()
    var remainingTimeString: String = "加载中..."
    var countdownToWashString: String = "加载中..."
    var targetWashTime: Date = Date()
    var isWashTime = false
    var isWashed = false
    
    private var timer: AnyCancellable?
    private var washTimer: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.currentDate = Date()
                self?.calculateRemainingTime()
                self?.calculateCountdownToWash()
                self?.checkIsTime()
            }
    }
    func startWashTimer() {
        self.targetWashTime = Date().addingTimeInterval(10 * 60)
        washTimer = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.calculateCountdownToWash()
                self?.checkIsWashedTime()
            }
    }
    deinit {
        timer?.cancel()
        washTimer?.cancel()
    }
    
    /// 计算剩余时间
    private func calculateRemainingTime() {
        let targetTime = Calendar.current.date(byAdding: .day, value: 1, to: sportTime)!
        let interval = targetTime.timeIntervalSince(currentDate)
        if interval > 0 {
            let hours = (Int(interval) % 86400) / 3600
            let minutes = (Int(interval) % 3600) / 60
            let seconds = Int(interval) % 60
            
            self.remainingTimeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            self.remainingTimeString = "开始运动！"
        }
    }
    
    /// 检查是否到时
    private func checkIsTime() {
        let calendar = Calendar.current
        let currentDateHour = calendar.component(.hour, from: self.currentDate)
        let currentDateMinute = calendar.component(.minute, from: self.currentDate)
        let currentDateSecond = calendar.component(.second, from: self.currentDate)
        let sportTimeHour = calendar.component(.hour, from: self.sportTime)
        let sportTimeMinute = calendar.component(.minute, from: self.sportTime)
        let sportTimeSecond = calendar.component(.second, from: self.sportTime)
        if currentDateHour == sportTimeHour && currentDateMinute == sportTimeMinute && currentDateSecond == sportTimeSecond {
            self.isAlarming = true
        }
    }
    /// 计算洗漱倒计时
    private func calculateCountdownToWash() {
        let now = Date()
        let interval = targetWashTime.timeIntervalSince(now)
        if interval > 0 {
            let totalCentiseconds = Int(interval * 100)
            let minutes = (totalCentiseconds / 100) / 60
            let seconds = (totalCentiseconds / 100) % 60
            let centiseconds = totalCentiseconds % 100
            
            self.countdownToWashString = String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
        } else {
            self.countdownToWashString = "开始运动！"
        }
    }
    /// 检查是否到时
    private func checkIsWashedTime() {
        let calendar = Calendar.current
        let currentDateHour = calendar.component(.hour, from: self.currentDate)
        let currentDateMinute = calendar.component(.minute, from: self.currentDate)
        let currentDateSecond = calendar.component(.second, from: self.currentDate)
        let sportTimeHour = calendar.component(.hour, from: self.targetWashTime)
        let sportTimeMinute = calendar.component(.minute, from: self.targetWashTime)
        let sportTimeSecond = calendar.component(.second, from: self.targetWashTime)
        if currentDateHour == sportTimeHour && currentDateMinute == sportTimeMinute && currentDateSecond == sportTimeSecond {
            self.isWashed = true
        }
    }
}
