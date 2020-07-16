import Foundation

struct Task: Equatable {
    let id: String
    let title: String
    let dueDate: Date?
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case dueDate
        case isCompleted
    }
}

extension Task: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Task.CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}

extension Task: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Task.CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
}

extension Task {
    static var createTable: SQL {
        return """
            CREATE TABLE tasks (
                id TEXT NOT NULL,
                title TEXT NOT NULL,
                dueDate TEXT,
                isCompleted INTEGER NOT NULL
            );
            """
    }

    static var upsert: SQL {
        return "INSERT OR REPLACE INTO tasks VALUES (:id, :title, :dueDate, :isCompleted);"
    }

    static var fetchAll: SQL {
        return "SELECT id, title, dueDate, isCompleted FROM tasks;"
    }

    static var fetchByID: SQL {
        return "SELECT id, title, dueDate, isCompleted FROM tasks WHERE id=:id;"
    }
}

// MARK: JSON Encoder and Decoder

let jsonEncoder = JSONEncoder()
let jsonDecoder = JSONDecoder()

let id = UUID().uuidString
let tomorrow = Date(timeIntervalSinceNow: 86400)
let task = Task(id: id, title: "Buy milk", dueDate: tomorrow, isCompleted: false)

// wrap these calls in do-catch blocks in real apps
let json = try! jsonEncoder.encode(task)
let taskFromJSON = try! jsonDecoder.decode(Task.self, from: json)

// MARK: SQLite Encoder and Decoder

// wrap these calls in do-catch blocks in real apps
let database = try! SQLite.Database(path: ":memory:")
try! database.execute(raw: Task.createTable)

let sqliteEncoder = SQLite.Encoder(database)
let sqliteDecoder = SQLite.Decoder(database)

// wrap these calls in do-catch blocks in real apps
try! sqliteEncoder.encode(task, using: Task.upsert)
let allTasks = try! sqliteDecoder.decode(Array<Task>.self, using: Task.fetchAll)
let taskFromSQLite = try! sqliteDecoder.decode(Task.self, using: Task.fetchByID, arguments: ["id": .text(id)])
