import FluentSQLite
import Vapor
import FluentPostgreSQL

///// Called before your application initializes.
//public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
//    /// Register providers first
//    try services.register(FluentSQLiteProvider())
//
//    /// Register routes to the router
//    let router = EngineRouter.default()
//    try routes(router)
//    services.register(router, as: Router.self)
//
//    /// Register middleware
//    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
//    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
//    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
//    services.register(middlewares)
//
//    // Configure a SQLite database
////    let sqlite = try SQLiteDatabase(storage: .memory)
//
//    /// Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//
//
//    let databaseConfig:PostgreSQLDatabaseConfig
//
//    if let url = Environment.get("DATABASE_URL") {
//        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
//    }
//    else {
//        databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
//                                                  port: 5432,
//                                                  username: "postgres",
//                                                  database: "kokora")
//    }
//
//    let database = PostgreSQLDatabase(config: databaseConfig)
//
//    databases.add(database: database, as: .psql)
//    services.register(databases)
//
//    /// Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: HotKeyModel.self, database: .psql)
//    migrations.add(migration: AddingDescriptionToHotKeys.self, database: .psql)
////    migrations.add(model: Todo.self, database: .sqlite)
//    services.register(migrations)
//
//}



public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    // Leaf
//    try services.register(LeafProvider())
//    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    var commands = CommandConfig.default()
    commands.useFluentCommands()
    services.register(commands)
    
    // 认证
    services.register(DirectoryConfig.detect())
//    try services.register(AuthenticationProvider())
    
    /// Register routes to the router
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /* * ** ** ** ** *** ** ** ** Middleware ** ** ** ** ** ** ** ** ** */
    var middlewares = MiddlewareConfig()
    
//    middlewares.use(LocalHostMiddleware())
    
//    middlewares.use(APIErrorMiddleware.init(environment: env, specializations: [
//        ModelNotFound()
//        ]))
    
//    middlewares.use(ExceptionMiddleware(closure: { (req) -> (EventLoopFuture<Response>?) in
//        let dict = ["status":"404","message":"访问路径不存在"]
//        return try dict.encode(for: req)
//        //        return try req.view().render("leaf/loader").encode(for: req)
//    }))
    
    middlewares.use(ErrorMiddleware.self)
    // Serves files from `Public/` directory
    middlewares.use(FileMiddleware.self)
    
    //
//    middlewares.use(PageViewMeddleware())
    
//    middlewares.use(GuardianMiddleware(rate: Rate(limit: 20, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
//        let dict = ["status":"429","message":"访问太频繁"]
//        return try dict.encode(for: req)
//    }))
    
    services.register(middlewares)
    
    /* * ** ** ** ** *** ** ** ** SQL ** ** ** ** ** ** ** ** ** */
    try services.register(FluentPostgreSQLProvider())
    let pgSQL = PostgreSQLDatabaseConfig.loadSQLConfig(env)
    services.register(pgSQL)
    
    /* * ** ** ** ** *** ** ** ** 𝐌odels ** ** ** ** ** ** ** ** ** */
    var migrations = MigrationConfig()
    
    migrations.add(model: HotKeyModel.self, database: .psql)
    migrations.add(migration: AddingDescriptionToHotKeys.self, database: .psql)
    
    services.register(migrations)
    
    
}
