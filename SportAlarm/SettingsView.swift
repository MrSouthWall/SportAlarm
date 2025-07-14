//
//  SettingsView.swift
//  SportAlarm
//
//  Created by MrSouthWall on 2025/7/14.
//

import SwiftUI

struct SettingsView: View {
    @Binding var sportTime: Date
    
    var body: some View {
        DatePicker("选择时间", selection: $sportTime, displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
            .labelsHidden()
    }
}

#Preview {
    SettingsView(sportTime: .constant(.now))
}
