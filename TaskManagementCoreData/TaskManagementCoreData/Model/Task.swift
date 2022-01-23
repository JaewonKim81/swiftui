//
//  Task.swift
//  TaskManagementCoreData
//
//  Created by 김재원 on 2022/01/23.
//

import SwiftUI


struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
