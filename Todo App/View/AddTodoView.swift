//
//  AddTodoView.swift
//  Todo App
//
//  Created by abdullah irianda on 15/02/21.
//

import SwiftUI

struct AddTodoView: View {
  
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.presentationMode) var presentationMode
  
  @State private var name: String = ""
  @State private var priority: String = "Normal"
  
  let priorities = ["High", "Normal", "Low"]
  
  @State private var errorShowing: Bool = false
  @State private var errorTitle: String = ""
  @State private var errorMessage: String = ""
  
  let themes: [Theme] = themeData
  @ObservedObject var theme = ThemeSettings.shared
  
  var body: some View {
    NavigationView{
      VStack{
        VStack(alignment: .leading, spacing: 20){
          TextField("Todo", text: $name)
            .padding()
            .background(Color(UIColor.tertiarySystemFill))
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))
          
          Picker("Priority", selection: $priority){
            ForEach(priorities, id: \.self){
              Text($0)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
          
          Button(action: {
            if self.name != ""{
              let todo = Todo(context: self.managedObjectContext)
              todo.name = self.name
              todo.priority = self.priority
              
              do{
                try self.managedObjectContext.save()
                print("New todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
              } catch{
                print(error)
              }
            } else {
              self.errorShowing = true
              self.errorTitle = "Invalid Name"
              self.errorMessage = "Make sure to enter something for\nthe new todo item"
              return
            }
            self.presentationMode.wrappedValue.dismiss()
            
          }){
            Text("Save")
              .font(.system(size: 24, weight: .bold, design: .default))
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(themes[self.theme.themeSettings].themeColor)
              .cornerRadius(9)
              .foregroundColor(Color.white)
          }
        }
        .padding(.horizontal)
        .padding(.vertical, 30)
        
        Spacer()
      }
      .navigationBarTitle("New Todo", displayMode: .inline)
      .navigationBarItems(trailing:
                            Button(action: {
                              self.presentationMode.wrappedValue.dismiss()
                            }){
                              Image(systemName: "xmark")
                            })
      .alert(isPresented: $errorShowing){
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    }
    .accentColor(themes[self.theme.themeSettings].themeColor)
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddTodoView()
  }
}
