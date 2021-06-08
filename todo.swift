import Foundation

var remoteTodos: [[String : Any]] = [["id": 1, "title": "delectus aut autem", "completed": 0],
                                     ["id": 2, "title": "quis ut nam facilis et officia qui", "completed": 0],
                                     ["id": 3, "title": "fugiat veniam minus", "completed": 1],
                                     ["id": 4, "title": "et porro tempora", "completed": 1],
                                     ["id": 5, "title": "laboriosam mollitia et enim quasi adipisci quia provident illum", "completed": 0],
                                     ["id": 6, "title": "qui ullam ratione quibusdam voluptatem quia omnis", "completed": 0],
                                     ["id": 7, "title": "illo expedita consequatur quia in", "completed": 0],
                                     ["id": 8, "title": "quo adipisci enim quam ut ab", "completed": 1],
                                     ["id": 9, "title": "molestiae perspiciatis ipsa", "completed": 0],
                                     ["id": 10, "title": "illo est ratione doloremque quia maiores aut", "completed": 1]]


protocol TodosHandlerProtocol {
    func addNewTodo(id: Int, title: String?, isCompleted: Bool) throws
    func deleteTodo(id: Int) throws
    func editTodo(id: Int) throws
}

class TodoViewController {

    var isCheckedTodo: Bool = false
    var newTitleTodo: String? = ""
    var newIdTodo: Int = 0
    var todosHandler: TodosHandlerProtocol

    init(todosHandler: TodosHandlerProtocol) {
      self.newIdTodo = remoteTodos.count + 1
      self.todosHandler = todosHandler
    }

    //funkcja imitujaca interfejs zwracania textu z textfield
    func fillImaginaryTextField(title: String?) {
      self.newTitleTodo = title
    }
    
    //funkcja imitujaca interfejs przelaczenia checkbox
    func toggleImaginaryCheckbox() {
      self.isCheckedTodo = !self.isCheckedTodo
    }
    
    //funkcja imitujaca przycisniecie przycisku AddNewToDo
    func imaginaryButtonActionAddNewToDo() throws {
      do {
        try todosHandler.addNewTodo(id: self.newIdTodo, title: newTitleTodo, isCompleted: isCheckedTodo)
        self.newIdTodo += 1
        self.newTitleTodo = ""
        self.isCheckedTodo = false
      } catch TodoError.emptyTitle {
        print("title is empty \n\n")
      }
        
    }
    
    //funkcja imitujaca przycisniecie przycisku RemoveTodo dla obiektu z id
    func imaginaryButtonActionRemoveTodo(id: Int) throws {
      do {
        try todosHandler.deleteTodo(id: id)
      } catch TodoError.todoIdNotExist {
        print("todo with id \(id) doesn't exist\n\n")
      }
    }
    
    //funkcja imitujaca przelaczenie checkbox dla obiektu z id
    func imaginaryButtonActionToggleTodo(id: Int) throws {
      do {
        try todosHandler.editTodo(id: id)
      } catch TodoError.todoIdNotExist {
        print("todo with id \(id) doesn't exist\n\n")
      }
    }

    func printAllTodos() {
      print(remoteTodos)
    }
}

class TodosHandler: TodosHandlerProtocol {
    // add new todo
    func addNewTodo(id: Int, title: String?, isCompleted: Bool) throws {
        if title == "" {
          throw TodoError.emptyTitle
        }
        var completed = 0;
        if isCompleted {
          completed = 1
        }
        let newTodo: [String: Any] = ["id": id, "title": title!, "completed": completed]
        remoteTodos.append(newTodo)
        print(remoteTodos.last!)
        print("todo with id \(id) added\n\n")
    }

    // delete todo with id
    func deleteTodo(id: Int) throws {
      let index: Int = findIndexById(id: id)
      if index != -1 {
        print(remoteTodos[index])
        print("todo with id \(id) deleted\n\n")
        remoteTodos.remove(at: index)
      } else {
        throw TodoError.todoIdNotExist
      }
    }

    // edit todo with id
    func editTodo(id: Int) throws {
      let index: Int = findIndexById(id: id)
      if index != -1 {

      var completed = remoteTodos[index]["completed"]
      if completed as? NSObject == 1 as NSObject {
        completed = 0
      } else {
        completed = 1
      }

        print(remoteTodos[index])
        remoteTodos[index].updateValue(completed!, forKey: "completed")
        print(remoteTodos[index])
        print("todo with id \(id) edited\n\n")
      } else {
        throw TodoError.todoIdNotExist
      }
    }

    func findIndexById(id: Int) -> Int {
      var index: Int = -1
      var counter = 0

      for todo in remoteTodos {
        if let tempId = todo["id"] {
          if tempId as? NSObject == id as NSObject {
            index = counter
          }
          counter += 1
        }
      }
      return index
    }
}

enum TodoError: Error {
    case emptyTitle
    case todoIdNotExist
}

var todosHandler = TodosHandler()
var todoView = TodoViewController(todosHandler: todosHandler)

todoView.fillImaginaryTextField(title: "")
todoView.toggleImaginaryCheckbox()
do {
  try todoView.imaginaryButtonActionAddNewToDo()
} catch TodoError.emptyTitle {
  print("title is empty")
}

todoView.fillImaginaryTextField(title: "another todo")
do {
  try todoView.imaginaryButtonActionAddNewToDo()
} catch TodoError.emptyTitle {
  print("title is empty")
}

do {
  try todoView.imaginaryButtonActionRemoveTodo(id: 71)
} catch TodoError.todoIdNotExist {
  print("Id doesn't exist")
}

do {
  try todoView.imaginaryButtonActionRemoveTodo(id: 7)
} catch TodoError.todoIdNotExist {
  print("Id doesn't exist")
}

do {
  try todoView.imaginaryButtonActionToggleTodo(id: 2)
} catch TodoError.todoIdNotExist {
  print("Id doesn't exist")
}