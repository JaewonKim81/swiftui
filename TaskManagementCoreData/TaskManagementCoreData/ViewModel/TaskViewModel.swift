//
//  TaskViewModel.swift
//  TaskManagementCoreData
//
//  Created by 김재원 on 2022/01/23.
//

import SwiftUI

class TaskViewModel : ObservableObject {
    
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1642955155)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate: .init(timeIntervalSince1970: 1642958755)),
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1642984255)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1642998355)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1643175055)),
        Task(taskTitle: "Check asset", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1643181775)),
        Task(taskTitle: "Team party", taskDescription: "Make fun with team mated", taskDate: .init(timeIntervalSince1970: 1643277655)),
        Task(taskTitle: "Cliend Meeting", taskDescription: "Explain project to client", taskDate: .init(timeIntervalSince1970: 1643331655)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate: .init(timeIntervalSince1970: 1643358355)),
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1643349955))
    ]
    
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var filteredTasks: [Task]?
    
    // MARK: - Initialzing
    init() {
        fetchCurrentWeek()
        filterTodayTask()
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        let week = calendar.dateInterval(of: .weekOfYear, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (0...6).forEach { day in

            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekDay)
            }
        }
    }
    
    func filterTodayTask() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task1.taskDate < task2.taskDate
                }
            
            DispatchQueue.main.async {
                self.filteredTasks = filtered
            }
            
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDate(date, inSameDayAs: currentDay)
    }
    
    func isCurrentHour(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return currentHour == hour
    }
    
}
