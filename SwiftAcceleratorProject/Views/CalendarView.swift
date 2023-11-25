//
//  CalendarView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var dataManager = DataManager()
    @State var DisplayEvents: [Event] = [Event(title: "", details: "")]
    @State var selectedDate: Date = Date()
    @State private var CreateNew = false
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    VStack() {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                            .padding(.horizontal)
                            .datePickerStyle(.graphical)
                    }
                    .navigationBarItems(trailing:
                    Button{
                        CreateNew = true
                    }label:{
                        Image(systemName: "plus.circle")
                    })
                    .navigationTitle("Calendar")
                    .navigationBarTitleDisplayMode(.large)
                }
                
                Section(header: Text("Events").textCase(nil)){
                    
                    ForEach(dataManager.Events.filter { x in
                        let StartDate = x.startDate
                        let EndDate = x.endDate
                        
                        let DateRange = StartDate...EndDate
                        
                        if(DateRange.contains(selectedDate)){
                            return true
                        }
                        else{
                            return false
                        }
                        
                    }, id: \.id){ item in
                        NavigationLink(destination:{
                            EventDetailView( event: item, Events: $dataManager.Events)
                        }, label:{
                            HStack{
                                VStack(alignment: .leading){
                                    Text(item.title)
                                        .bold()
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Due: \(item.endDate, format: .dateTime.month().day())")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                }
                            }
                        })
                    }
                    .onDelete(perform: { indices in
                        delete(at: indices)
                    })
                }
                
            }
            .listStyle(.sidebar)
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $CreateNew){
                CreateNewEventView(Events: $dataManager.Events, Edit: false)
            }
        }
        .onDisappear{
            dataManager.saveEvents()
        }
    }
    func delete(at offsets: IndexSet) {
        dataManager.Events.remove(atOffsets: offsets)
        dataManager.saveEvents()
    }
}

#Preview {
    CalendarView()
}
