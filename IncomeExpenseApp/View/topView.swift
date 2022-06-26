//
//  topView.swift
//  IncomeExpenseApp
//
//  Created by Twinkle T on 2022-06-25.
//

import SwiftUI

struct topView: View {
    
    var per:Double = 0.0
    var totalIncome=""
    var totalExpense=""
    var balance=""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Spacer()
            VStack(alignment: .leading) {
                Text("Expenses")
                Text("$\(totalExpense)")

            }
                VStack(alignment: .leading) {
                    Text("|")
                    Text("|")

                }
            VStack(alignment: .leading) {
                Text("Income")
                Text("$\(totalIncome)")

            }
                VStack(alignment: .leading) {
                    Text("|")
                    Text("|")

                }
            VStack(alignment: .leading) {
                Text("Balance")
                Text("$\(balance)")

            }
                Spacer()
            }.padding()
        HStack(alignment: .top) {
            VStack{
                        ProgressBar(value: per).frame(height: 25)
                        Spacer()
                    }.padding()
        }
        }.border(.black).frame(height: 100)
       
    }
    
}
