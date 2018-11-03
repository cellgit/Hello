import FluentSQLite
import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
//    try services.register(FluentSQLiteProvider())
    
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    
//    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
//    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
//    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
//    middlewares.use(SessionsMiddleware.self)
//    services.register(middlewares)
    

    // Configure a SQLite database
//    let sqlite = try SQLiteDatabase(storage: .memory)
    
//    var databases = DatabasesConfig()
//    let databaseConfig: PostgreSQLDatabaseConfig
//    if let url = Environment.get("DATABASE_URL") {
//        guard let urlConfig = PostgreSQLDatabaseConfig(url: url) else {
//            fatalError("Failed to create PostgresConfig")
//        }
//        databaseConfig = urlConfig
//    } else {
//        let databaseName: String
//        let databasePort: Int
//        if (env == .testing) {
//            databaseName = "kokora"
//            if let testPort = Environment.get("DATABASE_PORT") {
//                databasePort = Int(testPort) ?? 5432
//            } else {
//                databasePort = 5432
//            }
//        }
//        else {
//            databaseName = Environment.get("DATABASE_DB") ?? "kokora"
//            databasePort = 5432
//        }
//
//        let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
//        let username = Environment.get("DATABASE_USER") ?? "vapor"
//        let password = Environment.get("DATABASE_PASSWORD") ?? "password"
//        databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: databasePort, username: username, database: databaseName, password: password)
//    }
//    let database = PostgreSQLDatabase(config: databaseConfig)
//    databases.add(database: database, as: .psql)
//    services.register(databases)
    
    
    
    
    var databases = DatabasesConfig()
    
    let databaseConfig:PostgreSQLDatabaseConfig
    //    databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
    //                                              port: 5432,
    //                                              username: "postgres",
    //                                              database: "kokora")
    
    if let url = Environment.get("DATABASE_URL") {
        //        databaseConfig = try PostgreSQLDatabaseConfig(url: url)
        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
    }
    else {
        databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
                                                  port: 5432,
                                                  username: "postgres",
                                                  database: "kokora")
    }
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    

    /// Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//    databases.add(database: sqlite, as: .sqlite)
//    services.register(databases)
    
    
    
    
    
    

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
//    migrations.add(model: Todo.self, database: .sqlite)
    
    migrations.add(model: HotKeyModel.self, database: .psql)
    migrations.add(migration: AddingDescriptionToHotKeys.self, database: .psql)
    
    services.register(migrations)

}
