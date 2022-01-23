//
//  Home.swift
//  TaskManagementCoreData
//
//  Created by 김재원 on 2022/01/23.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            // Mark: Lazy Stack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    // MARK: - Current week view
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10) {
                            
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                
                                VStack(spacing: 10) {
                                    
                                    Text(taskModel.extractDate(date: day, format: "DD"))
                                        .font(.system(size: 15, weight: .semibold))
                                    
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        if taskModel.isToday(date: day) {
                                            Capsule().fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()

                } header: {
                    HeaderView()
                }

                
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    func TasksView() -> some View {
        
        LazyVStack(spacing: 25) {
            
            if let tasks = taskModel.filteredTasks {
                
                if tasks.isEmpty {
                    
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                    
                }
                
            } else {
                
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: taskModel.currentDay) { newValue in
            
            taskModel.filterTodayTask()
        }
    }
    
    func TaskCardView(task: Task) -> some View {
        
        HStack(alignment: .top, spacing: 30) {
            
            // 도형
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            //둥근 박스
            VStack {
                
                // 제목, 설명, 날짜
                HStack(alignment: .top, spacing: 10) {
                    
                    // 타이틀, 설명
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                            
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    // 날짜
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                
                if taskModel.isCurrentHour(date: task.taskDate)  {
                    // MARK: - Team memeber and check button
                    HStack(spacing: 0) {
                        
                        HStack(spacing: -10) {
                            
                            ForEach(["User1", "User2", "User3"], id: \.self) { User in
                                
                                Image(User)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle().stroke(.gray, lineWidth: 3)
                                    )
                            }
                        }
                        .hLeading()
                        
                        // MARK: - Check Button
                        Button {
                            
                        } label: {
                            
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding()
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }

                    }
                }
                
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
            .hLeading()
            .background(
                Color("Black")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
            )
            
        }
        .hLeading()
    }
    
    func HeaderView() -> some View {
        
        HStack(spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today").font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                
            }

        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: - UI Design Helper functions
extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
}
