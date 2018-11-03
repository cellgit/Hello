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
    
    var databases = DatabasesConfig()
    
    let databaseConfig:PostgreSQLDatabaseConfig
        databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
                                                  port: 5432,
                                                  username: "postgres",
                                                  database: "kokora")
    
//    if let url = Environment.get("DATABASE_URL") {
//        //        databaseConfig = try PostgreSQLDatabaseConfig(url: url)
//        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
////            {
////                "hostname": "$DATABASE_HOSTNAME",
////                "user": "$DATABASE_USER",
////                "password": "$DATABASE_PASSWORD",
////                "database": "$DATABASE_DB"
////        }
////        databaseConfig = PostgreSQLDatabaseConfig(hostname: "DATABASE_HOSTNAME",
////                                                  username: "DATABASE_USER",
////                                                  password: "DATABASE_PASSWORD",
////                                                  database: "DATABASE_DB")
//
//
//    }
//    else {
//        databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
////                                                  port: 5432,
//                                                  username: "postgres",
//                                                  database: "kokora")
//    }
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    
//    migrations.add(model: HotKeyModel.self, database: .psql)
//    migrations.add(migration: AddingDescriptionToHotKeys.self, database: .psql)
    
    services.register(migrations)

}
