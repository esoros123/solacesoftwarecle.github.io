import Foundation
import UIKit

//loading games from the menu

class SudokuKeyboardKey : UIView {
    weak var screen: SudokuGrid?
    var number : Int
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    init(frame: CGRect, num: Int) {
        number = num
        super.init(frame: frame)
        super.layer.borderWidth = 1.0
        super.layer.cornerRadius = 5.0
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                super.layer.borderColor = UIColor.black.cgColor
            case .dark:
                super.layer.borderColor = UIColor.white.cgColor
            default:
                super.layer.borderColor = UIColor.white.cgColor
        }
        
        let label = UILabel(frame: .init(x: 9, y: 0, width: 20, height: 30))
        label.text = number.description
        let size = getLabelSize(label: label, char: label.text!)
        label.frame = .init(x: (frame.width/2)-(size.width/2), y: (frame.height/2)-(size.height/2), width: size.width, height: size.height)
        super.addSubview(label)
    }
    
    override func layoutSubviews() {
        let label = self.subviews[0] as! UILabel
        let size = getLabelSize(label: label, char: label.text!)
        label.frame = .init(x: (frame.width/2)-(size.width/2), y: (frame.height/2)-(size.height/2), width: size.width, height: size.height)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        screen?.onNumberPress(num: self.number)
    }
    
    required init?(coder: NSCoder) {
        number = Int.min
        super.init(coder: coder)
    }
}

class SudokuKeyboard : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        var x = 48.0
        for i in 1...6 {
            let key = SudokuKeyboardKey(frame: .init(x: x, y: 0, width: frame.width / 7.85, height: frame.height), num: i)
            super.addSubview(key)
            x += key.frame.width
        }
            
        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
    }
    
    override func layoutSubviews() {
        var x = 0.0
        for i in 1...6 {
            let key = self.subviews[i - 1]
            key.frame = .init(x: x, y: 0, width: Double((frame.width) / 6), height: frame.height)
            x += key.frame.width
        }
    }
    
    func lightmode() {
        subviews.forEach { s in
            s.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func darkmode() {
        subviews.forEach { s in
            s.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func injectView(screen: SudokuGrid) {
        self.subviews.forEach { v in
            if let s = v as? SudokuKeyboardKey {
                s.screen = screen
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class SuodkuBox : UIView {
    var id = 0
    var number = 0
    var label : UILabel = .init()
    weak var grid: SudokuGrid?
    var guesses : [UILabel] = []
    var initiallySet = false
    
    init(frame: CGRect, id: Int, number: Int, initiallySet_: Bool) {
        self.id = id
        self.number = number
        super.init(frame: frame)
        super.layer.borderWidth = 1.0
        super.layer.cornerRadius = 5.0
        if(number != 0) {
            super.layer.borderColor = UIColor.systemGreen.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        grid?.onBoxPress(id: self.id)
    }
    
    func serializeGuesses() -> Int {
        if(guesses.isEmpty) {
            return 0
        }
        
        var result = 0
        guesses.forEach { g in
            result += Int(g.text!)!
            result = result * 10
        }
        return result
    }
    
    func lightmode() {
        if((label.text == nil || label.text == "") &&  guesses.count == 0) {
            backgroundColor = .white
        }
    }
    
    func darkmode() {
        if((label.text == nil || label.text == "") &&  guesses.count == 0) {
            backgroundColor = .black
        }
    }
    
    func reset() {
        if(!initiallySet) {
            clear()
        }
    }
    
    func clear() {
        if(initiallySet) {
            return
        }
        
        number = 0
        guesses = []
        label.text = ""
        subviews.forEach {v in v.removeFromSuperview()}
        
        if traitCollection.userInterfaceStyle == .dark {
            self.backgroundColor = .black
        } else {
            self.backgroundColor = .white
        }
    }
    
    func guess(number: Int) {
        if(self.number != 0) {
            return
        }
        
        super.backgroundColor = .systemYellow
        if(guesses.count  == 0) {
            let label = UILabel()
            label.text = number.description
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            guesses.append(label)
            super.addSubview(label)
        } else if (guesses.count  == 1) {
            let label = UILabel()
            label.text = number.description
            label.textColor = .black
            label.font = .systemFont(ofSize: 14)
            guesses.append(label)
            super.addSubview(label)
        } else if(guesses.count == 2) {
            let label = UILabel()
            label.text = number.description
            label.textColor = .black
            label.font = .systemFont(ofSize: 14)
            guesses.append(label)
            super.addSubview(label)
        } else if(guesses.count == 3) {
            let label = UILabel()
            label.text = number.description
            label.textColor = .black
            label.font = .systemFont(ofSize: 14)
            guesses.append(label)
            super.addSubview(label)
        }
    }
    
    func setInitiallySet(num: Int) {
        initiallySet = true
        super.backgroundColor = .green
        render(n: num)
    }
    
    func render(n: Int) {
        if(n == 0) {
            return
        }
        label.font = .systemFont(ofSize: 18)
        label.text = n.description
        label.textColor = .black
        number = n
        super.addSubview(label)
    }
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    override func layoutSubviews() {
        if(guesses.count > 0) {
            var index = 0
            self.guesses.forEach { lbl in
                if(index == 1) {
                    lbl.frame = .init(x: frame.width/10, y: frame.height/10, width: 13, height: 13)
                } else if (index == 2) {
                    lbl.frame = .init(x: frame.width - frame.width/4, y: frame.width/10, width: 13, height: 13)
                } else if (index == 3) {
                    lbl.frame = .init(x: frame.width/10, y: frame.width - frame.width/3, width: 13, height: 13)
                } else {
                    lbl.frame = .init(x: frame.width - frame.width/4, y: frame.width - frame.width/3, width: 13, height: 13)
                }
                index += 1
            }
        } else {
            if(label.text == nil) {
                return
            }
            
            let size = getLabelSize(label: label, char: label.text!)
            label.frame = .init(origin: .init(x: frame.width/2 - size.width/2, y: frame.height/2 - size.height/2), size: .init(width: size.width, height: size.height))
        }
    }
}

class SudokuButtons: UIView {
    weak var grid: SudokuGrid?
    private var guessButton: UIButton = UIButton.init()
    private var selectButton: UIButton = UIButton.init()
    private var clearButton: UIButton = UIButton.init()
    private var resetButton: UIButton = UIButton.init()
    
    private var pressedAttrs : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19.0),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
    ]
    
    private var unpressedAttrs : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19.0),
        NSAttributedString.Key.foregroundColor : UIColor.white,
    ]
    
    @objc func pressSelect(button: UIButton) {
        button.setAttributedTitle(.init(string: "Select", attributes: pressedAttrs), for: .normal)
        guessButton.setAttributedTitle(.init(string: "Guess", attributes: unpressedAttrs), for: .normal)
        clearButton.setAttributedTitle(.init(string: "Clear", attributes: unpressedAttrs), for: .normal)
        resetButton.setAttributedTitle(.init(string: "Reset", attributes: unpressedAttrs), for: .normal)
        grid?.onButtonPress(state: "Select")
    }
    
    @objc func pressGuess(button: UIButton) {
        button.setAttributedTitle(.init(string: "Guess", attributes: pressedAttrs), for: .normal)
        selectButton.setAttributedTitle(.init(string: "Select", attributes: unpressedAttrs), for: .normal)
        clearButton.setAttributedTitle(.init(string: "Clear", attributes: unpressedAttrs), for: .normal)
        resetButton.setAttributedTitle(.init(string: "Reset", attributes: unpressedAttrs), for: .normal)
        grid?.onButtonPress(state: "Guess")
    }
    
    @objc func pressClear(button: UIButton) {
        button.setAttributedTitle(.init(string: "Clear", attributes: pressedAttrs), for: .normal)
        guessButton.setAttributedTitle(.init(string: "Guess", attributes: unpressedAttrs), for: .normal)
        resetButton.setAttributedTitle(.init(string: "Reset", attributes: unpressedAttrs), for: .normal)
        selectButton.setAttributedTitle(.init(string: "Select", attributes: unpressedAttrs), for: .normal)
        grid?.onButtonPress(state: "Clear")
    }
    
    @objc func pressReset(button: UIButton) {
        button.setAttributedTitle(.init(string: "Reset", attributes: pressedAttrs), for: .normal)
        guessButton.setAttributedTitle(.init(string: "Guess", attributes: unpressedAttrs), for: .normal)
        clearButton.setAttributedTitle(.init(string: "Clear", attributes: unpressedAttrs), for: .normal)
        selectButton.setAttributedTitle(.init(string: "Select", attributes: unpressedAttrs), for: .normal)
        grid?.onButtonPress(state: "Reset")
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectButton.setAttributedTitle(.init(string: "Select", attributes: pressedAttrs), for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        selectButton.addTarget(self, action: #selector(pressSelect), for: .touchDown)
        selectButton.backgroundColor = .systemRed
        selectButton.layer.cornerRadius = 5.0
        super.addSubview(selectButton)
        
        guessButton.setAttributedTitle(.init(string: "Guess", attributes: unpressedAttrs), for: .normal)
        guessButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        guessButton.addTarget(self, action: #selector(pressGuess), for: .touchDown)
        guessButton.backgroundColor = .systemRed
        super.addSubview(guessButton)
                
        clearButton.setAttributedTitle(.init(string: "Clear", attributes: unpressedAttrs), for: .normal)
        clearButton.backgroundColor = .systemRed
        clearButton.layer.cornerRadius = 5.0
        clearButton.addTarget(self, action: #selector(pressClear), for: .touchDown)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        super.addSubview(clearButton)
        
        resetButton.setAttributedTitle(.init(string: "Reset", attributes: unpressedAttrs), for: .normal)
        resetButton.backgroundColor = .systemRed
        resetButton.layer.cornerRadius = 5.0
        resetButton.addTarget(self, action: #selector(pressReset), for: .touchDown)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        super.addSubview(resetButton)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        var xi = 0.0
        for i in 1...4 {
            let button = self.subviews[i - 1]
            button.frame = .init(x: xi , y: 0, width: Double(frame.width/4), height: frame.height)
            xi += (button.frame.width) + 2.5
        }
    }
}

class SudokuGrid : UIView {
    var map = Dictionary<Int, SuodkuBox>.init()
    var focus : SuodkuBox?
    var state = "Select"
    weak var sudokuView: SudokuView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var index = 0
        for _ in 0...5 {
            for _ in 0...5 {
                let box = SuodkuBox(frame: .init(), id: index, number: 0, initiallySet_: false);
                box.grid = self
                map[index] = box
                super.addSubview(box)
                if(index == 0) {
                    focus = box
                }
                index += 1
            }
        }
        
        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
    }
    
    func lightmode() {
        subviews.forEach { v in
            v.layer.borderColor = UIColor.black.cgColor
            (v as! SuodkuBox).lightmode()
        }
    }
    
    func darkmode() {
        subviews.forEach { v in
            v.layer.borderColor = UIColor.white.cgColor
            (v as! SuodkuBox).darkmode()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func seed(puzzle: [Int]) {
        var index = 0
        for _ in 0...5 {
            for _ in 0...5 {
                let box = map[index]!
                if(puzzle[index] != 0) {
                    box.setInitiallySet(num: puzzle[index])
                }
                index += 1
            }
        }
    }
    
    func hydrateFromDisk(data: SaveData) {
        var index = 0
        data.puzzle.forEach { num in
            let box = map[index]!
            if(data.guesses[index] != 0) {
                var num = data.guesses[index] / 10
                while(num != 0) {
                    box.guess(number: num % 10)
                    num = num / 10
                }
            } else  {
                box.render(n: data.puzzle[index])
            }
            if(data.initiallySet[index] != 0) {
                box.setInitiallySet(num: data.puzzle[index])
            }
            index += 1
        }
    }
    
    func onBoxPress(id: Int) {
        focus = map[id]!
        if(state == "Clear") {
            focus?.clear()
        }
    }
        
    func onButtonPress(state: String) {
        self.state = state
        if(state == "Reset") {
            map.values.forEach { b in
                b.clear()
            }
        }
    }
    
    func serialize() -> ([Int],[Int],[Int]) {
        var index = 0
        var numbers : [Int] = []
        var guesses : [Int] = []
        var initiallySet: [Int] = []
        
        for _ in 0...5 {
            for _ in 0...5 {
                let box = map[index]!
                numbers.append(box.number)
                initiallySet.append(box.initiallySet == true ? 1 : 0)
                guesses.append(box.serializeGuesses())
                index += 1
            }
        }
        return (numbers, guesses, initiallySet)
    }
    
    func onNumberPress(num: Int) {
        if(focus != nil && focus!.initiallySet) {
            return
        }
        
        if(state == "Select") {
            focus!.render(n: num)
            sudokuView!.isComplete(serialize: serialize().0)
        } else if (state == "Guess") {
            focus?.guess(number: num)
        }
    }
            
    override func layoutSubviews() {
        var index = 0
        var x = 0.0
        var y = 0.0
        let height = frame.height / 6
        let width = frame.width / 6
        for _ in 0...5 {
            for _ in 0...5 {
                let box = map[index]
                box!.frame = CGRect.init(x: x, y: y, width: width, height: height)
                index += 1
                x += width
            }
            x = 0.0
            y += height
        }
    }
}

class SudokuView : UIView {
    weak var viewController: SudokuViewController?
    var menuBar: MenuBar?
    var keyboard: SudokuKeyboard?
    var buttons: SudokuButtons?
    var grid: SudokuGrid?
    public var menu: Menu?
    public var gameOver: GameOver?
    public var levelComplete: LevelComplete?
    public var menuMask: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        
        menuBar = MenuBar()
        menuBar?.sudoku = self
        super.addSubview(menuBar!)
        
        grid = SudokuGrid()
        grid?.sudokuView = self
        super.addSubview(grid!)
        
        keyboard = SudokuKeyboard()
        keyboard!.injectView(screen: grid!)
        super.addSubview(keyboard!)
        
        buttons = SudokuButtons.init()
        buttons!.grid = grid
        super.addSubview(buttons!)
            
        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
    }
    
    func darkmode() {
        backgroundColor = .black
        grid?.darkmode()
        keyboard?.darkmode()
    }
    
    func lightmode() {
        backgroundColor = .white
        grid?.lightmode()
        keyboard?.lightmode()
    }
    
    func onSaveGame(name: String) throws {
        let puzzle = grid!.serialize()
        try viewController?.onGameSave(name: name, numbers: puzzle.0, guesses: puzzle.1, _initiallySet: puzzle.2)
    }
    
    override func layoutSubviews() {
        if(frame.width > frame.height) {
            menuBar?.frame = .init(x: 0, y: 0, width: frame.width, height: 75)
            grid?.frame = .init(x: 50, y: menuBar!.frame.maxY + 20, width: frame.width/3.5, height: frame.width/4)
            keyboard?.frame = .init(x: grid!.frame.maxX + (frame.width/5), y: frame.height/2 - 25, width: frame.width/3.25, height: 50)
            buttons!.frame = .init(x: grid!.frame.maxX + (frame.width/5), y: keyboard!.frame.maxY + 10, width: frame.width/3, height: 50)
        } else {
            menuBar?.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height * 0.10)
            grid?.frame = .init(x: (frame.width/2) - ((frame.height/3)/2), y: frame.height/2 - (frame.height/3)/2 - menuBar!.frame.height - 40, width: frame.height/3, height: frame.height/3)
            buttons!.frame = .init(x: 50, y: frame.height - 150, width: frame.width/1.5, height: 50)
            keyboard?.frame = .init(x: 50, y: buttons!.frame.maxY + 10, width: frame.width / 1.5, height: 50)
        }
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        levelComplete?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        gameOver?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
    }
                
    func onHideMenu() {
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.menu?.alpha = 0.0
        }) {[weak self] _ in
            self?.menu?.removeFromSuperview()
            self?.menuMask?.removeFromSuperview()
        }
    }
    
    func isComplete(serialize: [Int]) {
        let result = viewController!.checkPuzzle(check: serialize)
        if(result) {
            onLevelComplete()
        }
    }
    
    func onGameOver() {
        let viewController = GameOverViewController()
        window?.rootViewController = viewController
    }
    
    func onShowMenu() {
        menuMask = UIView(frame: self.frame)
        menuMask!.backgroundColor = UIColor.init(white: 0.0, alpha: 0.30)
        self.addSubview(menuMask!)
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menu = Menu(frame: .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height))
        menu?.alpha = 0.0
        menu?.s = self
        self.addSubview(menu!)
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.menu?.alpha = 1.0
        })
    }
    
    func onLevelComplete() {
        menuMask = UIView(frame: self.frame)
        menuMask!.backgroundColor = UIColor.init(white: 0.0, alpha: 0.30)
        self.addSubview(menuMask!)
        
        if(!level_skip) {
            points_this_round = 10
        }
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        levelComplete = LevelComplete(frame: .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height))
        levelComplete?.sviewController = viewController
        levelComplete?.alpha = 0.0
        self.addSubview(levelComplete!)
        
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.levelComplete?.alpha = 1.0
        })
    }
    
    func initialSeed(puzzle: [Int]) {
        grid!.seed(puzzle: puzzle)
    }
    
    func renderLevel(level: Int) {
        menuBar?.renderLeevl(level: level)
    }
            
    func renderTime(time: String) {
        menuBar?.renderTime(time: time)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class SudokuGenerator {
    private func nextPosition(row: Int, col: Int) -> (Int, Int)
    {
        var r = row
        var c = col
        if(r == 5) {
            r = 0
            c += 1
        } else {
            r += 1
        }
        return (r,c)
    }
    
    private func generateInternal(size: Int, board: [[Int]], row: Int, col: Int) -> Optional<[[Int]]>
    {
        var copyBoard = board
        if(col == 6) {
            return board
        }
        
        var possible = [1,2,3,4,5,6].shuffled()
        for i in 0...5 {
            if(board[i][col] != 0) {
                possible.removeAll() { num in
                    num == board[i][col]
                }
            }
        }
        for i in 0...5 {
            if(board[row][i] != 0) {
                possible.removeAll() { num in
                    num == board[row][i]
                }
            }
        }
        
        let pos = nextPosition(row: row, col: col)
        for move in possible {
            copyBoard[row][col] = move
            let b = generateInternal(size: size, board: copyBoard, row: pos.0, col: pos.1)
            if(b != nil) {
                return b
            }
        }
        
        return .none
    }
    
    func generate() -> [[Int]] {
        var board : [[Int]] = []
        for _ in 0...5 {
            board.append([0,0,0,0,0,0])
        }
        return generateInternal(size: 6, board: board, row: 0, col: 0)!
    }
}

class SudokuSave : Codable {
    var type: String
    var numbers: [[Int]]
    var time: Int
    var level: Int
    var name: String
    
    init(type: String, numbers: [[Int]], time: Int, level: Int, name: String) {
        self.type = type
        self.numbers = numbers
        self.time = time
        self.level = level
        self.name = name
    }
}

var ellapsedTime = 0

class SudokuViewController: UIViewController {
    private var generator: SudokuGenerator = .init()
    private var v: SudokuView?
    private var solved: [[Int]] = [[]]
    private var initiallySet : [Int] = []
    var timer = Timer()
    var level = 1
    var data: SaveData?
    
    func onExitGame() {
        let vc = ViewController()
        time_selection = 0
        view.window?.rootViewController = vc
    }
    
    func unFlattenSolved(solved: [Int]) -> [[Int]] {
        var result : [[Int]] = []
        var index = 0
        for _ in 0...5 {
            var r : [Int] = []
            for _ in 0...5 {
                r.append(solved[index])
                index += 1
            }
            result.append(r)
        }
        return result
    }
    
    func flattenSolved() -> [Int] {
        var result : [Int] = []
        solved.forEach { arr in
            arr.forEach { val in
                result.append(val)
            }
        }
        
        return result
    }
    
    func onGameSave(name: String, numbers: [Int], guesses: [Int], _initiallySet: [Int]) throws {
        let solved = flattenSolved()
        let data = SaveData.init(time: ellapsedTime, time_limit: time_selection, level: level, score: total_points_game, name: name, GameType: "Sudoku", puzzleCrossword: [], completeCrossword: [],
                                 puzzle: numbers, complete: solved, initiallySet: _initiallySet, guesses: guesses, positions: [], orientations: [])
        
        try Archiver().save(data: data)
        onExitGame()
    }
    
    func getFormatTime(_ seconds : Int) -> String {
        let (_,m,s) = secondsToHoursMinutesSeconds(seconds)
        return format(num: m) + ":" + format(num: s)
    }
    
    func onLevelComplete() {
        let vc = CrosswordScreenViewController()
        vc.level = level + 1
        view.window?.rootViewController = vc
    }
    
    func format(num: Int) -> String {
        if(num < 10) {
            return "0" + num.description
        } else {
            return num.description
        }
    }
    
    func checkPuzzle(check: [Int]) -> Bool {
        var index = 0
        for i in 0...5 {
            for j in 0...5 {
                if(solved[i][j] != check[index]) {
                    return false
                }
                index += 1
            }
        }
        return true
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                v?.darkmode()
                v?.menuBar?.darkmode()
            } else {
                v?.lightmode()
                v?.menuBar?.lightmode()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.view.setNeedsLayout()
        })
    }
    
    @objc func onTimerTick() {
        ellapsedTime += 1
        v?.renderTime(time: getFormatTime(ellapsedTime))
        if(ellapsedTime == time_selection && time_selection != 0) {
            v?.onGameOver()
        }
    }
    
    func loadFromDisk() {
        level = data!.level
        ellapsedTime = data!.time
        total_points_game = data!.score
        time_selection = data!.time_limit
        initiallySet = data!.initiallySet
        solved = unFlattenSolved(solved: data!.complete)
                
        let v = view as! SudokuView
        v.grid?.hydrateFromDisk(data: data!)
        v.renderLevel(level: level)
        v.renderTime(time: getFormatTime(ellapsedTime))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = ViewFactory().createSudokuView(frame: self.view.frame)
        v.viewController = self
        self.view = v
        self.v = v
                
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.onTimerTick()
        }

        if(data != nil) {
            loadFromDisk()
        } else {
            let puzzle = generator.generate()
            solved = puzzle
            
            var d = 0
            if(difficulty == 2) {
                d = 675
            } else if (difficulty == 3) {
                d = 500
            } else {
                d = 475
            }
            
            var copy : [Int] =  []
            puzzle.forEach { arr in
                arr.forEach { w in
                    let random = Int.random(in: 1..<1000)
                    if(random > d) {
                        copy.append(0)
                    } else {
                        copy.append(w)
                    }
                }
            }
            
            v.initialSeed(puzzle: copy)
            v.renderLevel(level: level)
        }
    }
}
