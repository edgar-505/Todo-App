//
//  FormRowLinkView.swift
//  Todo App

import SwiftUI

struct FormRowLinkView: View {
  
  var icon: String
  var color: Color
  var text: String
  var link: String
  
  var body: some View {
    HStack{
      ZStack{
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(color)
        Image(systemName: icon)
          .imageScale(.large)
          .foregroundColor(Color.white)
      }
      .frame(width: 36, height: 36, alignment: .center)
      
      Text(text).foregroundColor(Color.gray)
      Spacer()
      Button(action: {
        guard let url = URL(string: self.link), UIApplication.shared.canOpenURL(url) else{
          return
        }
        UIApplication.shared.open(url as URL)
      }){
        Image(systemName: "chevron.right")
          .font(.system(size: 14, weight: .bold, design: .default))
      }
      .accentColor(Color(.systemGray2))
    }
  }
}

struct FormRowLinkView_Previews: PreviewProvider {
  static var previews: some View {
    FormRowLinkView(icon: "globe", color: Color.pink, text: "website", link: "https://mufti.web.app")
      .previewLayout(.fixed(width: 375, height: 60))
      .padding()
  }
}
