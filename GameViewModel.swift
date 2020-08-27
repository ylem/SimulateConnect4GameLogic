//
//  GameViewModel.swift
//  Connect4
//
//  Created by Wei Lu on 24/08/2020.
//  Copyright © 2020 Frive. All rights reserved.
//

import Foundation

final class GameBoard {

    static let shared: GameBoard = .init()

    static let totalColumns = 7
    static let totalRows = 6
    static let player1Value = 1
    static let player2Value = 2

    init() {}

    private var board: Array2D = Array2D(columns: GameBoard.totalColumns,
                                              rows: GameBoard.totalRows,
                                              initialValue: 0)

    /// set player's "value" into column.
    /// - Parameters:
    ///   - column: column of disc put in
    ///   - player: player 1 or 2
    /// - Returns: updated row
    func updateValue(column: Int, player: Int) -> Int? {
        guard
            column >= 0, column < board.columns,
            let row = availableRow(of: column)
        else { return nil }

        board[column, row] = player == 1 ? GameBoard.player1Value : GameBoard.player2Value
        return row
    }

    /// find a cell with 0 value, the row in board is from bottom to top ( 6 - 0 )
    /// - Parameter column: column of disc
    /// - Returns: row number - first 0 value cell in the row.
    func availableRow(of column: Int) -> Int? {
        // put disc to bottom of board
        guard
            let row = (0 ..< GameBoard.totalRows).first(where: { board[column, GameBoard.totalRows - 1 - $0] == 0 })
        else { return nil }
        return GameBoard.totalRows - 1 - row
    }

    func value(in column: Int, row: Int) -> Int {
        return board[column, row]
    }

    func reset() {
        board = Array2D(columns: GameBoard.totalColumns,
                        rows: GameBoard.totalRows,
                        initialValue: 0)
    }

    func printBoard() {
        print(" --------------------- ")
        for row in (0 ..< GameBoard.totalRows) {
            for column in (0 ..< GameBoard.totalColumns) {
                let value = board[column, row]
                print ("\(value)\t", terminator:"")
            }
            print ("")
        }
    }
}

final class GameViewModel {

    private let gameBoard: GameBoard

    init(board: GameBoard = .init()) {
        self.gameBoard = board
        self.gameBoard.reset()
    }

    func addDisc(column: Int, player: Int) -> Bool {
        guard let row = gameBoard.updateValue(column: column, player: player) else { return false }

        gameBoard.printBoard()
        
        return checkResult(column: column, row: row, player: player)
    }

    private func checkResult(column: Int, row: Int, player: Int) -> Bool {
        let checkNumber = player == 1 ? GameBoard.player1Value : GameBoard.player2Value

        return
            checkHorizatalResult(column: column, row: row, checkNum: checkNumber) ||
            checkVerticalResult(column: column, row: row, checkNum: checkNumber) ||
            checkLeftObliqueResult(column: column, row: row, checkNum: checkNumber) ||
            checkRightObliqueResult(column: column, row: row, checkNum: checkNumber)
    }

    private func checkVerticalResult(column: Int, row: Int, checkNum: Int) -> Bool {
        var result = 1
        var nextRow = row - 1

        // check top
        while nextRow >= 0 && gameBoard.value(in: column, row: nextRow) == checkNum {
            result += 1
            nextRow -= 1
        }

        if result == 4 {
            return true
        }

        // check down
        nextRow = row + 1
        while nextRow < GameBoard.totalRows && gameBoard.value(in: column, row: nextRow) == checkNum {
            result += 1
            nextRow += 1
        }

        return result >= 4
    }

    private func checkHorizatalResult(column: Int, row: Int, checkNum: Int) -> Bool {
        var result = 1
        var nextColumn = column - 1

        // check left
        while nextColumn >= 0 && gameBoard.value(in: nextColumn, row: row) == checkNum {
            result += 1
            nextColumn -= 1
        }

        if result == 4 {
            return true
        }

        // check right
        nextColumn = column + 1
        while nextColumn < GameBoard.totalColumns && gameBoard.value(in: nextColumn, row: row) == checkNum {
            result += 1
            nextColumn += 1
        }

        return result >= 4
    }

    private func checkLeftObliqueResult(column: Int, row: Int, checkNum: Int) -> Bool {
        var result = 1
        var nextColumn = column - 1
        var nextRow = row - 1

        // check left top
        while nextColumn >= 0
            && nextRow >= 0
            && gameBoard.value(in: nextColumn, row: nextRow) == checkNum {
            result += 1
            nextColumn -= 1
            nextRow -= 1
        }

        if result == 4 {
            return true
        }

        // check left down
        nextColumn = column - 1
        nextRow = row + 1

        while nextColumn >= 0
            && nextRow < GameBoard.totalRows
            && gameBoard.value(in: nextColumn, row: nextRow) == checkNum {
            result += 1
            nextColumn -= 1
            nextRow += 1
        }

        return result >= 4
    }

    private func checkRightObliqueResult(column: Int, row: Int, checkNum: Int) -> Bool {
        var result = 1
        var nextColumn = column + 1
        var nextRow = row + 1

        // check right down
        while nextColumn < GameBoard.totalColumns
            && nextRow < GameBoard.totalRows
            && gameBoard.value(in: nextColumn, row: nextRow) == checkNum {
                result += 1
                nextColumn += 1
                nextRow += 1
        }

        if result >= 4 {
            return true
        }

        // check right top
        nextColumn = column + 1
        nextRow = row - 1

        while nextColumn < GameBoard.totalColumns
            && nextRow >= 0
            && gameBoard.value(in: nextColumn, row: nextRow) == checkNum {
                result += 1
                nextColumn += 1
                nextRow -= 1
        }

        return result >= 4
    }
}
