//
//  ProgressBar.swift
//  IncomeExpenseApp
//
//  Created by Twinkle T on 2022-06-25.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
       
       var body: some View {
           GeometryReader { geometry in
                       ZStack(alignment: .leading) {
                           Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                               .opacity(0.3)
                               .foregroundColor(Color(UIColor.systemTeal))
                           
                           Rectangle().frame(width: min((self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                               .foregroundColor(Color(UIColor.systemBlue))
                               .animation(.linear)
                       }.cornerRadius(45.0)
               
           }
       }
}
