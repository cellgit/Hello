import Vapor



struct DisplayHotKeysContext: Encodable {
    var hotkeys: [HotKeyModel]
}


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    
    
    router.post(HotKeyModel.self, at: "/hotkey") { req, hotkey -> Future<HotKeyModel> in
        return hotkey.save(on: req)
    }
    router.post("/hotkeys") { req -> Future<[HotKeyModel]> in
        return HotKeyModel.query(on: req).all()
    }
    
}


