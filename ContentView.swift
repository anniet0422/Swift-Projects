//
//  ContentView.swift
//  to-do-list
//
//  Created by Annie Tran on 3/19/24.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool = false
}

enum Sections: String, CaseIterable {
    case pending = "Pending"
    case completed = "Completed"
}

struct ContentView: View {
    
    @State private var tasks = [Task(name: "Do MKTG Quiz"), Task(name: "Do laundry", isCompleted: true), Task(name: "Feed the cat", isCompleted: true)]
    
    var pendingTasks: [Binding<Task>] {
        $tasks.filter { !$0.isCompleted.wrappedValue }
    }
    
    var completedTasks: [Binding<Task>] {
        $tasks.filter { $0.isCompleted.wrappedValue }
    }
    
    var body: some View {
        List {
            ForEach(Sections.allCases, id: \.self) {
                section in
                Section{
                    
                    let filteredTasks = section == .pending ? pendingTasks: completedTasks
                    
                    if filteredTasks.isEmpty {
                        Text("No tasks available.")
                    }
                    
                    ForEach(filteredTasks) {
                        $task in
                        TaskViewCell(task: $task)
                    }
                    
                    .onDelete {
                        indexSet in
                        
                        indexSet.forEach {
                            index in
                            let taskToDelete =  filteredTasks[index]
                            tasks = tasks.filter { $0.id != taskToDelete.id }
                        }
                    }
                    
                } header: {
                    Text(section.rawValue)
                }
            }
        }
    }
}

struct TaskViewCell: View {
    
    @Binding var task: Task
    
    var body: some View {
        HStack{
            Image(systemName: task.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            Text(task.name)
        }
    }
    
}

#Preview {
    ContentView()
}
