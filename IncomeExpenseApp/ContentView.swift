//
//  ContentView.swift
//  IncomeExpenseApp
//
//  Created by Twinkle T on 2022-06-25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var addSubview = false
    @State var transactionDescription = ""
    @State var transactionType = ""
    @State var amount = ""
    @State private var showingAlert = false
    @State private var selectedttypeindex = 0
    @State var TotalIncome = 0.0
    @State var TotalExpense = 0.0
    @State var Difference = 0.0
    @State var percentage:Double = 0.0
    let calendar = Calendar.current
    @State var counter=0
    @State var todaydate=""


    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
  
     let transactionTP = ["Income", "Expense"]
       @State private var addsubview = false

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                topView.init(per: (percentage), totalIncome: "\(TotalIncome)", totalExpense: "\(TotalExpense)", balance: "\(TotalIncome-TotalExpense)")
           
            }.padding().onAppear{
                sumIncomeExpense()
            }
        }
        NavigationView {
            List {
                HStack{
                    Text(todaydate).bold()
                }.padding()

                ForEach(items) { item in
                        
                    HStack{
                        VStack{
                        Text(item.transactionDesc!)
                        }.padding()
                        VStack{
                            if item.intTransactionType == 0{
                                Text("$\(item.amount, specifier: "%.2f")")
                            }
                            else{
                                Text("- $\(item.amount, specifier: "%.2f")")
                            }
                        
                        }.padding() .frame(maxWidth: .infinity, alignment: .trailing)

                    }.onAppear{
                        checkDate(item.timestamp!)
                    }
                }
                .onDelete(perform: deleteItems)
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                          Spacer()
                      }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                                       self.addsubview = true
                                   }) {
                                       Image(systemName: "plus.circle.fill")
                                                                          .imageScale(.large)
                                                                          .font(.title)
                                   }

                }
            }
           
        }
        
                       if $addsubview.wrappedValue {
                           VStack(alignment: .center) {
                               ZStack{
                                   Color.black.opacity(0.4)
                                       .edgesIgnoringSafeArea(.vertical)
                                   VStack(spacing: 5) {
                                       HStack {
    

                                           VStack {
                                               Text("Add Transaction Type") .bold().padding()
                                               Picker("Transaction Type", selection: $selectedttypeindex, content: {
                                                             ForEach(0..<transactionTP.count, content: { index in
                                                                 Text(transactionTP[index])
                                                                 
                                                             })
                                               })
                                               .clipped().padding()
                                               TextField("Transaction Descripetion", text: $transactionDescription)
                                                   .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                                               if selectedttypeindex == 0{
                                                   TextField("$ Amount", text: $amount) .keyboardType(.numberPad)
                                                       .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                                               }
                                               else
                                               {
                                                   TextField("- $Amount ", text: $amount) .keyboardType(.numberPad)
                                                       .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                                               }
                                               
                                             
                                           }
                                       }

                                       Spacer()
                                       HStack{

                                       Button(action: {
                                           if amount != "" {
                                               addItem()
                                               self.addsubview = false
                                           }
                                           
                                       }){
                                           
                                           Image(systemName: "plus.circle.fill")
                                                                              .imageScale(.large)
                                                                              .font(.title)
                                       
                                   } .padding()
                                       Button(action: {
                                               self.addsubview = false
                                       }){
                                           
                                               Image(systemName: "xmark.octagon")
                                                                                  .imageScale(.large)
                                                                                  .font(.title)
                                           
                                       } .padding()
                                             
                                       }.padding()
                                   }
                                   .frame(width:300, height: 550)
                                   .background(Color.white)
                                   .mask(RoundedRectangle(cornerRadius: 20))
                                   .shadow(radius: 20)
    
                               }
                           }

                       }
            }
    func sumIncomeExpense(){
        TotalIncome=0.0
        TotalExpense=0.0
        items.forEach { i in
            if i.intTransactionType == 0{
                TotalIncome = TotalIncome + i.amount
            }
            else{
                TotalExpense = TotalExpense + i.amount
            }
        }
        percentage = (TotalExpense/(TotalIncome+TotalExpense))
        print(percentage)
     
    }
     func checkDate(_ date:Date) {
        if calendar.isDateInToday(date)  {
            counter=counter+1
            todaydate=" \(itemFormatter.string(from: date))"
            
            print(date)
        }
        else{
            counter=0
        }
      
    }

    private func addItem() {
        
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.transactionDesc = transactionDescription
            newItem.intTransactionType = Int64(selectedttypeindex)
            newItem.transactionType = transactionTP[selectedttypeindex]
            newItem.amount = Double(amount)!
            do {
                try viewContext.save()
                sumIncomeExpense()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
                sumIncomeExpense()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
     
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
