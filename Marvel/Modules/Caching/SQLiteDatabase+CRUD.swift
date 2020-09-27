//
//  SQLiteDatabase+CRUD.swift
//  OLXTrack
//
//  Created by abuzeid on 11/21/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import SQLite3

extension SQLiteDatabase {
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        log(.info, "\(table) table created.")
    }

    func insertCategory(cat: CategoryItem) throws {
        let insertSql = "INSERT INTO CategoryItem (Id, Name, visits) VALUES (?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }

        let title: NSString = NSString(string: cat.title)

        guard sqlite3_bind_text(insertStatement, 1, cat.id, -1, nil) == SQLITE_OK,
            sqlite3_bind_text(insertStatement, 2, title.utf8String, -1, nil) == SQLITE_OK,
            sqlite3_bind_int(insertStatement, 3, Int32(cat.visitsCount ?? 0)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }

        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }

        log(.info, "Successfully inserted row.")
    }

    func update(id: String, newVisits: Int) throws {
        let updateStatementString = "UPDATE CategoryItem SET visits = '\(newVisits)' WHERE Id = \(id);"
        let insertStatement = try prepareStatement(sql: updateStatementString)
        defer {
            sqlite3_finalize(insertStatement)
        }

        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
    }

    func category(id: String) -> CategoryItem? {
        let querySql = "SELECT * FROM CategoryItem WHERE Id = ?;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return nil
        }

        defer {
            sqlite3_finalize(queryStatement)
        }

        guard sqlite3_bind_text(queryStatement, 1, id, -1, nil) == SQLITE_OK else {
            return nil
        }

        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }

        let id = String(cString: sqlite3_column_text(queryStatement, 0)!)
        let visits = sqlite3_column_int(queryStatement, 2)
        let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
        return CategoryItem(id: id, visitsCount: Int(visits), title: name)
    }

    func allCategories() -> [CategoryItem] {
        let querySql = "SELECT * FROM CategoryItem WHERE 1=1;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return []
        }

        defer {
            sqlite3_finalize(queryStatement)
        }

        var objList: [CategoryItem] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = String(cString: sqlite3_column_text(queryStatement, 0)!)
            let visits = sqlite3_column_int(queryStatement, 2)
            let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
            let obj = CategoryItem(id: id, visitsCount: Int(visits), title: name)
            objList.append(obj)
        }

        return objList
    }
}
