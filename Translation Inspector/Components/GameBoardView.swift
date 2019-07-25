//
//  GameBoardView.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-10.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit



enum DrawType {
    case horizontal
    case vertical
    case diagonal
}

protocol GameBoardViewDelegate: class {
    func processTouchedGrid(touchedGridList: [GridBlock])
}

class GameBoardView: UIView {

    private var stackView = UIStackView()
    
    private var characterGrid = [[String]]()
    private var gridSize: GridSize = (0, 0)
    
    private var firstTouchedGrid: GridBlock?
    private var touchedGridList = [GridBlock]()
    
    weak var delegate: GameBoardViewDelegate?

    
    init() {
        super.init(frame: .zero)
        
        setTheme()
        doLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    }
    
    private func doLayout() {
        addSubview(stackView)
        stackView.pinTo(self)
    }
    
    func createGameBoard(gameBoardViewModel: GameBoardViewModel) {
        
        self.characterGrid = gameBoardViewModel.characterGrid
        gridSize = (characterGrid.count, characterGrid.first?.count ?? 0)
        
        setupGrid()
    }
    
}

//MARK: UIResponder Touch Methods Began / Moved / End
extension GameBoardView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touched = touchedGridBlock(touches, with: event),
            let touchLocation = touched.location,
            let touchGrid = touched.grid else { return }
        
        addToTouchedGridList(touched)
        firstTouchedGrid = touched
        
        colorIfNotGreen(.red, view: touchGrid)
        
        print("Touched view at (row: \(touchLocation.row), column:\(touchLocation.column))")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touched = touchedGridBlock(touches, with: event),
            let touchLocation = touched.location else { return }
        
        guard let startGridLocation = firstTouchedGrid?.location,
            let endGridLocation = touchedGridList.last?.location else { return }
        
        // We can specify startGridLocation as (x1, y1) and touchLocation as (x2, y2)
        //
        // There will be 4 different contions
        //
        // 1- Horizontal coordinates x1 == x2
        // 2- Vertical coordinates y1 == y2
        // 3- Diagonal coordinates |x1 - x2| == |y1 - y2|
        // 4- Find out (x2, y2) is close to Vertical or Horizontal or Diagonal
        
        let startRow = startGridLocation.row // x1
        let endRow = touchLocation.row       // x2
        let startColumn = startGridLocation.column // y1
        let endColumn = touchLocation.column       // y2
        
        if touchLocation == endGridLocation { return }
        cleanTheGrid(all: false)
        
        // Condition 1: Horizontal coordinates x1 == x2
        if startRow == endRow {
            
            drawSelectLine(startGridLocation: startGridLocation, endGridLocation: touchLocation, drawType: .horizontal)
        }
            // Condition 2: Vertical Coordinates y1 == y2
        else if startColumn == endColumn {
            
            drawSelectLine(startGridLocation: startGridLocation, endGridLocation: touchLocation, drawType: .vertical)
        }
            // Condition 3: Diagonal Coordinates |x1 - x2| == |y1 - y2|
        else if abs(startRow - endRow) == abs(startColumn - endColumn) {
            
            drawSelectLine(startGridLocation: startGridLocation, endGridLocation: touchLocation, drawType: .diagonal)
        }
            // Condition 4: Find out (x2, y2) is close to Vertical or Horizontal or Diagonal
        else {
            /*
            |-----------|------------|
            |   Grid    |     Grid   |
            |     1     |      2     |
            |-----------|------------|
            |   Grid    |    Grid    |
            |     3     |      4     |
            |-----------|------------|
            */
            
            //Grid 4
            if endColumn > startColumn && endRow > startRow {
                
                let normalizeColumn = endColumn - startColumn
                let normalizeRow = endRow - startRow
                let diagonalDifference = abs(startRow - startColumn)
                
                // 4.1 Lower Half
                if  normalizeRow > normalizeColumn {
                    
                    var toGridLocation = (row: startRow, column: startColumn)
                    
                    if endRow + diagonalDifference > gridSize.columns - 1 {
                        toGridLocation = (row: endRow, column: gridSize.columns - 1)
                    }
                    else {
                        toGridLocation = (row: endRow, column: endRow + diagonalDifference)
                    }
                    
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .diagonal)
                }
                // 4.2 Upper Half
                else {
                    
                    let toGridLocation = (row: startRow, column: endColumn)
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .horizontal)
                }
            }
            //Grid 2
            if endColumn > startColumn && endRow < startRow {
                
                let normalizeColumn = endColumn - startColumn
                let normalizeRow = startRow - endRow
                
                let diagonalDifference = abs(startColumn - endColumn)
                
                // 2.1 Lower Half
                if  normalizeRow < normalizeColumn {
                    
                    var toGridLocation = (row: startRow, column: startColumn)
                    
                    if endRow - diagonalDifference < 0 {
                        toGridLocation = (row: 0, column: endColumn)
                    }
                    else {
                        toGridLocation = (row: endRow - diagonalDifference, column: endColumn)
                    }

                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .diagonal)
                }
                // 2.2 Upper Half
                else {
                
                    let toGridLocation = (row: endRow, column: startColumn)
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .vertical)
                }
            }
            //Grid 1
            if endColumn < startColumn && endRow < startRow {
                
                let normalizeColumn = startColumn - endColumn
                let normalizeRow = startRow - endRow
                
                let diagonalDifference = abs(startRow - endRow)
                
                // 1.1 Upper Half
                if  normalizeRow > normalizeColumn {
                    
                    var toGridLocation = (row: startRow, column: startColumn)
                    
                    if startColumn - diagonalDifference <= 0 {
                        toGridLocation = (row: 0, column: endRow)
                    }
                    else {
                        toGridLocation = (row: startColumn - diagonalDifference, column: endRow)
                    }
                    
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .diagonal)
                }
                    // 1.2 Lower Half
                else {
 
                    let toGridLocation = (row: startRow, column: endColumn)
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .horizontal)
                }
            }
            
            //Grid 3
            if endColumn < startColumn && startRow < endRow {
                
                let normalizeColumn = startColumn - endColumn
                let normalizeRow = endRow - startRow
                
                let diagonalDifference = abs(startColumn - endColumn)
                
                // 3.1 Upper Half
                if  normalizeRow < normalizeColumn {
                    
                    var toGridLocation = (row: startRow, column: startColumn)
                    
                    if startRow + diagonalDifference > gridSize.rows - 1 {
                        toGridLocation = (row: gridSize.rows - 1, column: endColumn)
                    }
                    else {
                        toGridLocation = (row: startRow + diagonalDifference, column: endColumn)
                    }
                    
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .diagonal)
                }
                // 3.2 Lower Half
                else {
 
                    let toGridLocation = (row: endRow, column: startColumn)
                    drawSelectLine(startGridLocation: startGridLocation, endGridLocation: toGridLocation, drawType: .vertical)
                }
            }
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        colorTouchedGrid(.yellow)
        
        delegate?.processTouchedGrid(touchedGridList: touchedGridList)
    }
    
    func processTouchedGrid(_ exists: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            if exists {
                self?.colorTouchedGrid(.green)
                self?.touchedGridList.removeAll()
            }
            else {
                self?.cleanTheGrid()
            }
        }
    }
}


//MARK: Internal Functions used for setting finding adding cleaning touched grid
extension GameBoardView {
    
    private func touchedGridBlock(_ touches: Set<UITouch>, with event: UIEvent?) -> GridBlock? {
        
        guard let touch = touches.first else { return nil }
        let touched = touchedLocation(from: touch, event: event)
        
       return touched
        
    }
    
    private func touchedLocation(from touch: UITouch, event: UIEvent?) -> GridBlock {
        
        let location = touch.location(in: self)
        
        var touchedCoordinate: GridLocation?
        var touchedGridCell: UIView?
        
        /// For each row in the grid/board
        for row in 0..<stackView.arrangedSubviews.count {
            
            /// Cast to stack view
            guard let rowStackView = stackView.arrangedSubviews[row] as? UIStackView else { continue }
            
            /// For each column in the row (each square)
            for column in 0..<rowStackView.arrangedSubviews.count {
                
                // Get the touched view
                let view = rowStackView.arrangedSubviews[column]
                
                /// UIView's point(inside:with:) requires the passed point to be within the view's bounds
                /// Convert the touch from ourself (boardview) to the view that we are checking if it was touched
                let convertedLocation = convert(location, to: view)
                
                if view.point(inside: convertedLocation, with: event) {
                    touchedCoordinate = (row, column)
                    touchedGridCell = view
                }
            }
        }
        return (touchedCoordinate, touchedGridCell)
    }
    
    private func findGridCell(_ row: Int, column: Int) -> UIView? {
        
        guard let rowStackView = stackView.arrangedSubviews[row] as? UIStackView else { return nil }
        let view = rowStackView.arrangedSubviews[column]
        
        return view
    }
    
    private func addDesiredColoredGrid(row : Int, column: Int) {
        
        let locationCell = findGridCell(row, column: column)
        colorIfNotGreen(.red, view: locationCell)

        let newGridLocation: GridLocation = (row: row, column: column)
        let newGridBlock: GridBlock = (location: newGridLocation, grid: locationCell)
        
        addToTouchedGridList(newGridBlock)
    }
    
    private func addToTouchedGridList(_ gridBlock: GridBlock) {
        if !touchedGridList.contains(where: { value in
            if let valueLocation = value.location, let gridLocation = gridBlock.location {
                return valueLocation.row == gridLocation.row && valueLocation.column == gridLocation.column
            }
            return false
        }) {
            touchedGridList.append(gridBlock)
        }
    }
    
    private func cleanTheGrid(all: Bool = true) {
        
        let count = touchedGridList.count
        
        for (index, touchedGrid) in touchedGridList.enumerated() {
            if all {
                colorIfNotGreen(.white, view: touchedGrid.grid)
            } else if index != 0 {
                colorIfNotGreen(.white, view: touchedGrid.grid)
            }
        }
        if all {
            touchedGridList.removeAll()
        } else {
            touchedGridList.removeSubrange(1..<count)
        }
    }
    
    
    private func colorTouchedGrid(_ color: UIColor) {
        
        for touchedGrid in touchedGridList {
            colorIfNotGreen(color, view: touchedGrid.grid)
        }
    }
    
    private func colorIfNotGreen(_ color: UIColor, view: UIView?) {
        if !(view?.backgroundColor == .green) {
            view?.backgroundColor = color
        }
    }

}

//MARK: Internal Functions used for drawing desired touched line
extension GameBoardView {
    
    private func drawSelectLine(startGridLocation: GridLocation, endGridLocation: GridLocation, drawType: DrawType) {
    
        
        switch drawType {
        case .horizontal:
            
            let indexTraversal = (startGridLocation.column > endGridLocation.column) ? endGridLocation.column...startGridLocation.column
                                                                                     : startGridLocation.column...endGridLocation.column
            for column in indexTraversal {
                addDesiredColoredGrid(row: endGridLocation.row, column: column)
            }
        case .vertical:
            
            let indexTraversal = (startGridLocation.row > endGridLocation.row) ? endGridLocation.row...startGridLocation.row
                                                                               : startGridLocation.row...endGridLocation.row
            
            for row in indexTraversal {
                addDesiredColoredGrid(row: row, column: endGridLocation.column)
            }
        case .diagonal:
            
            var indexRow = startGridLocation.row
            var indexColumn = startGridLocation.column
            
            
            repeat {
                addDesiredColoredGrid(row: indexRow, column: indexColumn)
                
                indexRow = endGridLocation.row > startGridLocation.row ? indexRow + 1 : indexRow - 1
                indexColumn = endGridLocation.column > startGridLocation.column ? indexColumn + 1 : indexColumn - 1
                
            } while calculateDiagonalState(startGridLocation: startGridLocation,
                                           endGridLocation: endGridLocation,
                                           indexGridLocation: (row: indexRow, column: indexColumn))
        }
    }
    
    private func calculateDiagonalState(startGridLocation: GridLocation, endGridLocation: GridLocation, indexGridLocation: GridLocation) -> Bool {
        
        var condition = false
        
        if endGridLocation.row > startGridLocation.row && endGridLocation.column > startGridLocation.column {
            condition = indexGridLocation.row <= endGridLocation.row && indexGridLocation.column <= endGridLocation.column
        }
        else if  endGridLocation.row > startGridLocation.row && endGridLocation.column < startGridLocation.column {
            condition = indexGridLocation.row <= endGridLocation.row && indexGridLocation.column >= endGridLocation.column
        }
        else if  endGridLocation.row < startGridLocation.row && endGridLocation.column > startGridLocation.column {
            condition = indexGridLocation.row >= endGridLocation.row && indexGridLocation.column <= endGridLocation.column
        }
        else if  endGridLocation.row < startGridLocation.row && endGridLocation.column < startGridLocation.column {
            condition = indexGridLocation.row >= endGridLocation.row && indexGridLocation.column >= endGridLocation.column
        }
        
        return condition
    }
    
}


//MARK: Internal Functions used for setting up Grid using character grid
extension GameBoardView {
    
    /// Function used to draw the board using createLetterGridCell to draw the letters
    private func setupGrid() {
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
        }

        for row in 0..<gridSize.rows {
            let views: [UIView] = (0..<gridSize.columns).map { [weak self] column in
                return self?.createLetterGridCell(row: row, column: column) ?? UIView()
            }
            
            let rowStackView = UIStackView(arrangedSubviews: views).then {
                $0.axis = .horizontal
                $0.alignment = .fill
                $0.distribution = .fillEqually
            }
            
            stackView.addArrangedSubview(rowStackView)
        }
    }
    
    /// Creating UIView desired letter written on it
    ///
    /// - Parameters:
    ///   - row: # of row in the grid cell
    ///   - column: # column in the grid cell
    /// - Returns: View letter on it
    private func createLetterGridCell(row: Int, column: Int) -> UIView {
        
        let view = UIView(frame: .zero).then {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        let numberLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        numberLabel.text = characterGrid[row][column]
        
        view.addSubview(numberLabel)
        numberLabel.pinTo(view)
        
        return view
    }
    
}
