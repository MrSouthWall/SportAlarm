//
//  ContentView.swift
//  SportAlarm
//
//  Created by MrSouthWall on 2025/7/14.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var isShowSettingsView = false
    @AppStorage("sportTime") var sportTime: Date = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isAlarming {
                isAlarmingView
            } else {
                noAlarmingView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            Button("设置", systemImage: "gear") {
                isShowSettingsView.toggle()
            }
            .buttonStyle(.glass)
        }
        .overlay(alignment: .topLeading) {
            Button("开发切换", systemImage: "switch.2") {
                viewModel.isAlarming.toggle()
            }
            .buttonStyle(.glass)
        }
        .padding()
        .animation(.default, value: viewModel.isAlarming)
        .sheet(isPresented: $isShowSettingsView) {
            SettingsView(sportTime: $sportTime)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: sportTime) { oldValue, newValue in
            viewModel.sportTime = newValue
        }
        .onAppear {
            viewModel.sportTime = sportTime
        }
        .statusBar(hidden: true)
        .colorScheme(.dark)
        .monospacedDigit()
        .fontDesign(.rounded)
    }
    
    @ViewBuilder private var isAlarmingView: some View {
        Label("准备运动！", systemImage: "alarm.fill")
            .font(.title.bold())
            .foregroundStyle(.secondary)
            .symbolEffect(.wiggle.wholeSymbol, options: .repeat(.continuous))
            .padding(.top, 64)
        Text(viewModel.currentDate.formatted(date: .omitted, time: .shortened))
            .font(.system(size: 128).bold())
            .foregroundStyle(.white.opacity(0.8))
        
        Spacer()
        
        Button {
            
        } label: {
            Text("洗漱")
                .font(.title.bold())
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glassProminent)
        .tint(.orange)
        .padding(.horizontal)
        
        Button {
            
        } label: {
            Text("开始跑步")
                .font(.title.bold())
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glass)
        .padding(.horizontal)
        
    }
    
    @ViewBuilder private var noAlarmingView: some View {
        Spacer()
        Text("距离锻炼开始还有")
            .font(.title.bold())
            .foregroundStyle(.secondary)
            .padding(.top, 64)
        Text(viewModel.remainingTimeString)
            .font(.system(size: 80).bold())
            .foregroundStyle(.white.opacity(0.8))
        Spacer()
        Spacer()
        Text("起床时间 \(viewModel.sportTime.formatted(date: .omitted, time: .shortened))")
            .foregroundStyle(.secondary)
            .bold()
    }
}

#Preview("闹铃中") {
    ContentView()
        .environment(ViewModel())
}
