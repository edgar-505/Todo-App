//
//
//

import SwiftUI

struct ContentView: View {
  
  @Environment(\.managedObjectContext) var managedObjectContext
  
  @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
  
  @State private var showingAddTodoView: Bool = false
  @State private var showingSettingsView: Bool = false
  
  @EnvironmentObject var iconSettings: IconNames
  
  let themes: [Theme] = themeData
  @ObservedObject var theme = ThemeSettings.shared
  
  var body: some View {
    NavigationView{
      ZStack{
        List{
          ForEach(self.todos, id: \.self){ todo in
            HStack{
              Circle()
                .frame(width: 12, height: 12, alignment: .center)
                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
              Text(todo.name ?? "Unknown")
                .fontWeight(.semibold)
              
              Spacer()
              Text(todo.priority ?? "Unknown")
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray2))
                .padding(3)
                .frame(minWidth: 62)
                .overlay(
                  Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                )
            }
            .padding(.vertical, 10)
          }
          .onDelete(perform: deleteTodo)
          
        }
        .navigationBarTitle("Todo", displayMode: .inline)
        .navigationBarItems(
          leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
          trailing:
            // shift tab harus di select dulu => buat mindahin ke kiri
            Button(action: {
              // diganti jadi showingSettingsView
              self.showingSettingsView.toggle()
            }){
              Image(systemName: "gear")
            }
            .accentColor(themes[self.theme.themeSettings].themeColor)
            .sheet(isPresented: $showingSettingsView){
            // diganti jadi SettingsView
            SettingsView().environmentObject(self.iconSettings)
          }
        )
        
        if todos.count == 0{
          EmptyListView()
        }
      }
      .sheet(isPresented: $showingAddTodoView){
        AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
      }
      .overlay(
        ZStack{
          Button(action: {
            self.showingAddTodoView.toggle()
          }){
            Image(systemName: "plus.circle.fill")
              .resizable()
              .scaledToFit()
              .background(Circle().fill(Color("ColorBase")))
              .frame(width: 48, height: 48, alignment: .center)
          }
          .accentColor(themes[self.theme.themeSettings].themeColor)
        }
        .padding(.bottom, 15)
        .padding(.trailing, 15)
        , alignment: .bottomTrailing
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  private func deleteTodo(at offsets: IndexSet){
    for index in offsets{
      let todo = todos[index]
      managedObjectContext.delete(todo)
      
      do{
        try managedObjectContext.save()
      } catch{
        print(error)
      }
    }
  }
  
  private func colorize(priority: String) -> Color{
    switch priority {
    case "High":
      return .pink
    case "Normal":
      return .green
    case "Low":
      return .blue
    default:
      return .gray
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    return ContentView().environment(\.managedObjectContext, context)
  }
}
