import Foundation
import SQLite3

class Goods {
    let name: String!
    let weight: Int!
    var price: Double!
    init(name: String, weight: Int, price: Double) {
        self.name = name
        self.weight = weight
        self.price = price
    }
}

let goods = Goods(name: "computer", weight: 10, price: 2000.0)
var goodArr = [Goods]()
var dbPath = ""
var db: OpaquePointer?

func createData() {
    for index in 0...4 {
        let goods = Goods(name: "computer" + "\(index)", weight: index * 10, price: 20.0)
        goodArr.append(goods)
    }
}

func fetchLibraryPath() {
    if let libraryPathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
        let pathURL = URL(fileURLWithPath: libraryPathString).appendingPathComponent("goods.sqlite")
        dbPath = pathURL.path
    }
}
func openDatabase() -> OpaquePointer? {
    var db: OpaquePointer?
    if sqlite3_open(dbPath, &db) == SQLITE_OK {
        print("成功打开数据库，路径：\(dbPath)")
        return db
    } else {
        print("打开数据库失败")
        return nil
    }
}
func createTable() {
    let createTableString = """
                            CREATE TABLE IF NOT EXISTS Computer(
                            Id INT PRIMARY KEY NOT NULL,
                            Name CHAR(255),
                            Weight Int,
                            Price Float);
                            """
    var createTableStatement: OpaquePointer?
    // 第一步
    if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
        // 第二步
        if sqlite3_step(createTableStatement) == SQLITE_DONE {
            print("成功创建表")
        } else {
            print("未成功创建表")
        }
    } else {
            
    }
    //第三步
    sqlite3_finalize(createTableStatement)
}
func insertOneData() {
    let insertRowString = "INSERT INTO Computer (Id, Name, Weight, Price) VALUES (?, ?, ?, ?);"
    var insertStatement: OpaquePointer?
    //第一步
    if sqlite3_prepare_v2(db, insertRowString, -1, &insertStatement, nil) == SQLITE_OK {
            let id: Int32 = 1
            //第二步
            sqlite3_bind_int(insertStatement, 1, id)
            
            sqlite3_bind_text(insertStatement, 2, goods.name, -1, nil)
            
            sqlite3_bind_int(insertStatement, 3, Int32(goods.weight))
            
            sqlite3_bind_double(insertStatement, 4, goods.price)
            //第三步
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("插入数据成功")
            } else {
                print("插入数据失败")
            }
    } else {
        
    }
    //第四步
    sqlite3_finalize(insertStatement)
}
func insertMutipleData() {
    let insertRowString = "INSERT INTO Computer (Id, Name, Weight, Price) VALUES (?, ?, ?, ?);"
    var insertStatement: OpaquePointer?
    //第一步
    if sqlite3_prepare_v2(db, insertRowString, -1, &insertStatement, nil) == SQLITE_OK {
       for (index, good) in goodArr.enumerated() {
            let id: Int32 = Int32(index + 1)
            //第二步
            sqlite3_bind_int(insertStatement, 1, id)
            
            sqlite3_bind_text(insertStatement, 2, good.name, -1, nil)
            
            sqlite3_bind_int(insertStatement, 3, Int32(good.weight))
            
            sqlite3_bind_double(insertStatement, 4, good.price)
            //第三步
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("插入数据成功")
            } else {
                print("插入数据失败")
            }
            //第四步
            sqlite3_reset(insertStatement)
        }
    } else {
        
    }
    //第五步
    sqlite3_finalize(insertStatement)
}
func updateData() {
    let updateString = "UPDATE Computer SET Name = 'changeComputer' WHERE Id = 2;"
    var updateStatement: OpaquePointer?
    //第一步
    if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK {
        //第二步
        if sqlite3_step(updateStatement) == SQLITE_DONE {
            print("更新成功")
        } else {
            
        }
    }
    //第三步
    sqlite3_finalize(updateStatement)
}
func deleteData() {
    let deleteString = "DELETE FROM Computer WHERE Id = 2;"
    var deleteStatement: OpaquePointer?
    //第一步
    if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
        //第二步
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("删除成功")
        }
    } else {
        
    }
    //第三步
    sqlite3_finalize(deleteStatement)
}
func queryOneData() {
    let queryString = "SELECT * FROM Computer WHERE Id == 2;"
    var queryStatement: OpaquePointer?
    //第一步
    if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
        //第二步
        if sqlite3_step(queryStatement) == SQLITE_ROW {
            //第三步
            let id = sqlite3_column_int(queryStatement, 0)
            
            let queryResultName = sqlite3_column_text(queryStatement, 1)
            let name = String(cString: queryResultName!)
            let weight = sqlite3_column_int(queryStatement, 2)
            let price = sqlite3_column_double(queryStatement, 3)
            
            
            print("id: \(id), name: \(name), weight: \(weight), price: \(price)")
        } else {
            print("error")
        }
    }
    //第四步
    sqlite3_finalize(queryStatement)
}
func queryAllData() {
    let queryString = "SELECT * FROM Computer;"
    var queryStatement: OpaquePointer?
    //第一步
    if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
        //第二步
        while(sqlite3_step(queryStatement) == SQLITE_ROW) {
            //第三步
            let id = sqlite3_column_int(queryStatement, 0)
            
            let queryResultName = sqlite3_column_text(queryStatement, 1)
            let name = String(cString: queryResultName!)
            let weight = sqlite3_column_int(queryStatement, 2)
            let price = sqlite3_column_double(queryStatement, 3)
            
            
            print("id: \(id), name: \(name), weight: \(weight), price: \(price)")
        }
    }
    //第四步
    sqlite3_finalize(queryStatement)
}


createData()
fetchLibraryPath()

db = openDatabase()
//createTable()
//insertOneData()
//insertMutipleData()
//updateData()
//deleteData()
queryOneData()
queryAllData()
