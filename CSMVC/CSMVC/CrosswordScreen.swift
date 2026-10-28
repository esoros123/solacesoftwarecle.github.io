import Foundation
import UIKit

class MenuBar : UIView {
    private var timerLabel = UILabel()
    private var levelLabel = UILabel()
    private var menuButton = UIButton()
    private var skipButton = UIButton()
    weak var crossword: CrosswordScreen?
    weak var sudoku: SudokuView?
    
    func format(num: Int) -> String {
        if(num < 10) {
            return "0" + num.description
        } else {
            return num.description
        }
    }
    
    @objc func skip() {
        level_skip = true
        crossword?.onNextLevel()
        sudoku?.onLevelComplete()
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getFormatTime(_ seconds : Int) -> String {
        let (_,m,s) = secondsToHoursMinutesSeconds(seconds)
        return format(num: m) + ":" + format(num: s)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        timerLabel.font = timerLabel.font.withSize(13)
        timerLabel.text = getFormatTime(ellapsedTime)
        if(time_selection > 0) {
            timerLabel.text = getFormatTime(ellapsedTime) + " | " + getFormatTime(time_selection)
        }
        super.addSubview(timerLabel)
                
        levelLabel.font = levelLabel.font.withSize(13)
        levelLabel.text = "Level 1"
        super.addSubview(levelLabel)
        
        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = .systemBlue
        skipButton.titleLabel!.font = .systemFont(ofSize: 12)
        skipButton.addTarget(self, action: #selector(skip), for: .touchDown)
        super.addSubview(skipButton)
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let iconImage = UIImage(systemName: "line.3.horizontal", withConfiguration: iconConfig)
        menuButton.setImage(iconImage, for: .normal)
        menuButton.tintColor = .black
        menuButton.addTarget(self, action: #selector(onMenuPress), for: .touchDown)
        super.addSubview(menuButton)
        
        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
    }
    
    func lightmode() {
        backgroundColor = .white
        menuButton.tintColor = .black
    }
    
    func darkmode() {
        backgroundColor = .black
        menuButton.tintColor = .white
    }
    
    override func layoutSubviews() {
        if(superview!.frame.width > superview!.frame.height) {
            landscape()
        } else {
            portrait()
        }
    }
        
    func portrait() {
        timerLabel.frame = .init(x: 12, y: 55, width: 90, height: 20)
        levelLabel.frame = .init(x: frame.width - 70 - 35, y: 55, width: 70, height: 20)
        menuButton.frame = .init(x: frame.width - 83, y: 14, width: 100, height: 100)
        if(gameMode == 1) {
            skipButton.frame = .init(x: 55, y: 55, width: 50, height: 20)
        } else {
            skipButton.frame = .init(x: 105, y: 55, width: 50, height: 20)
        }
    }
        
    func landscape() {
        timerLabel.frame = .init(x: 10, y: 0, width: 90, height: 100)
        levelLabel.frame = .init(x: frame.width - 100, y: 0, width: 100, height: 100)
        menuButton.frame = .init(x: frame.width - 83, y: 0, width: 100, height: 100)
        if(gameMode == 1) {
            skipButton.frame = .init(x: 60, y: 40, width: 50, height: 20)
        } else {
            skipButton.frame = .init(x: 105, y: 40, width: 50, height: 20)
        }
    }
        
    @objc func onMenuPress() {
        crossword?.onShowMenu()
        sudoku?.onShowMenu()
    }
    
    func renderTime(time: String) {
        var t = time
        if(time_selection > 0) {
            t += " | " +  getFormatTime(time_selection)
        }
        timerLabel.text = t
    }
    
    func renderLeevl(level: Int) {
        levelLabel.text = "Level " + level.description
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CrosswordWordsBox : UIView {
    var words: [String] = []
    weak var screen: CrosswordScreen?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .systemGreen
        super.layer.cornerRadius = 3.0
    }
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    @objc func xonLabelTouch(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? UILabel else { return }
        screen?.crosswordDefinition?.onWordTapped(word: words[tappedView.tag])
    }
    
    func renderWords(words: [String]) {
        var index = 0
        words.forEach { word in
            let label = UILabel.init()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xonLabelTouch(_:)))
            label.isUserInteractionEnabled = true
            label.textColor = .white
            label.font = .systemFont(ofSize: 14)
            label.text = word
            label.tag = index
            label.addGestureRecognizer(tapGesture)
            super.addSubview(label)
            index += 1
        }
        if(difficulty == 3) {
            let random = self.subviews[0] as! UILabel
            random.text = "???"
        }
        if(difficulty == 4) {
            let randCount = min(3, words.count)
            let randomNumbers = Array(0...words.count - 1).shuffled().prefix(randCount)
            for i in randomNumbers {
                let random = self.subviews[i] as! UILabel
                random.text = "???"
            }
        }
        self.words = words
    }
    
    override func layoutSubviews() {
        var x = 20
        subviews.forEach { view in
            let label = view as! UILabel
            let size = getLabelSize(label: label, char: label.text!)
            label.frame = .init(x: x, y: 5, width: Int(size.width + 10), height: 30)
            x += Int(size.width + 10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CrosswordWordBox : UIView {
    private var text = " "
    var actual = ""
    var id = 0
    var lastId = 0
    weak var crossword: CrosswordGrid?
        
    
    func getText() -> String {
        return text;
    }
    
    func insert(char: String, fireUpdate: Bool) {
        let old = text
    
        self.text = char
        let label = self.subviews[0] as! UILabel
        label.text = char
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        label.frame = .init(x: frame.width/2 - size.width/2, y: 0, width: self.frame.width, height: self.frame.height)
        
        if(fireUpdate) {
            crossword?.onBoxUpdated(updates: self, old: old, new: char)
        }
    }
    
    override func layoutSubviews() {
        let label = self.subviews[0] as! UILabel
        if(label.text != nil) {
            let att = [NSAttributedString.Key.font: label.font!]
            let size = (label.text! as NSString).size(withAttributes: att)
            label.frame = .init(x: frame.width/2 - size.width/2, y: 0, width: self.frame.width, height: self.frame.height)
        }
    }
        
    func remove() {
        text = " "
        let label = self.subviews[0] as! UILabel
        label.text = " "
        crossword?.onBoxUpdated(updates: self, old: "aaa", new: "")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        crossword?.onBoxFocus(box: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layer.zPosition = 0
        super.layer.cornerRadius = 5.0

        self.text = " "
        super.layer.borderWidth = 1.0
        
        if(isDarkMode) {
            self.layer.borderColor = UIColor.white.cgColor
        } else {
            self.layer.borderColor = UIColor.black.cgColor

        }
                
        let label = UILabel(frame: .zero)
        super.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CrosswordKeyboardKey: UIView {
    var text = ""
    var display = ""
    private var label = UILabel.init()
    weak var viewController: CrosswordScreenViewController?
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(text != " ") {
            viewController?.onKeyPress(letter: text)
        }
    }
    
    init(frame: CGRect, text: String, display: String, tag: Int) {
        super.init(frame: frame)
        self.tag = tag
        
        if(text != " ") {
            super.layer.borderWidth = 1
            super.layer.cornerRadius = 7
        }

        self.text = text
        label.text = display
        super.addSubview(label)
    }
    
    override func layoutSubviews() {
        let size = getLabelSize(label: label, char: label.text!)
        label.frame = .init(origin: .init(x: frame.width/2 - size.width/2, y: frame.height/2 - size.height/2), size: .init(width: size.width, height: size.height))
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CrosswordKeyboard: UIView {
    private var display: [String] = []
    
    func injectViewController(viewController: CrosswordScreenViewController) {
        subviews.forEach { x in
            if let key = x as? CrosswordKeyboardKey {
                key.viewController = viewController
            }
        }
    }
    
    private func swap(i: Int, j: Int) {
        let temp = display[i]
        display[i] = display[j]
        display[j] = temp
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let height = frame.height / 4
        let width = frame.width / 12
        var x = 13.0
        var y = 25.0
        
        display = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L",
        "Z", "X", "C", "V", "B", "N", "M"]
        
        if(difficulty == 4) {
            display.shuffle()
        }
        
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "Q", display: display[0], tag: 1)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "W",  display: display[1], tag: 2)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "E",  display: display[2], tag: 3)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "R",  display: display[3], tag: 4)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "T",  display: display[4], tag: 5)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "Y",  display: display[5], tag: 7)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "U",  display: display[6], tag: 8)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "I",  display: display[7], tag: 9)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "O",  display: display[8], tag: 10)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "P",  display: display[9],tag: 11)); x+=width
        
        x = 20.0
        y += height
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: " ",  display: " ", tag: 12)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "A",  display: display[10], tag: 13)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "S",  display: display[11], tag: 14)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "D",  display: display[12], tag: 15)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "F",  display: display[13], tag: 16)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "G",  display: display[14], tag: 17)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "H",  display: display[15], tag: 18)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "J",  display: display[16], tag: 19)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "K",  display: display[17], tag: 20)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "L",  display: display[18], tag: 21)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: " ",  display: " ", tag: 22)); x+=width
        
        
        x = 20.0
        y += height
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width + width/2, height: height), text: " ",  display: "", tag: 23)); x+=width; x+=width/2
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "Z",  display: display[19], tag: 24)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "X",  display: display[20], tag: 25)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "C",  display: display[21], tag: 26)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "V",  display: display[22], tag: 27)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "B",  display: display[23], tag: 28)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "N",  display: display[24], tag: 29)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "M",  display: display[25], tag: 30)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: "<",  display: "<", tag: 31)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: " ",  display: " ", tag: 32)); x+=width
        super.addSubview(CrosswordKeyboardKey(frame: .init(x: x, y: y, width: width, height: height), text: " ",  display: " ", tag: 33)); x+=width
    }
        
    override func layoutSubviews() {
        print("non se keybaord")
        let height = frame.height / 4
        let width = frame.width / 12
        var x = 13.0
        var y = 25.0
                
        for i in 1...10 {
            let key = self.subviews[i-1]
            key.frame = .init(x: x, y: y, width: width, height: height)
            x += width
        }
        
        x = 6.0
        y += height
        for i in 11...22 {
            let key = self.subviews[i-1]
            key.frame = .init(x: x, y: y, width: width, height: height)
            x += width
        }
        
        x = 50.0
        y += height
        for i in 23...32 {
            let key = self.subviews[i-1]
            key.frame = .init(x: x, y: y, width: width, height: height)
            x += width
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

var level_skip = false
var total_points_game = 0
var points_this_round = 0

class LevelComplete : UIView {
    weak var viewController: CrosswordScreenViewController?
    weak var sviewController: SudokuViewController?
    var button: UIButton = .init()
    var uiLabel: UILabel = .init()
    
    private func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
        super.layer.cornerRadius = 5.0
        
        uiLabel = UILabel(frame: .init(x: frame.width/2, y: frame.height/2, width: 200, height: 25))
        uiLabel.text = level_skip ? "Level Skipped" : "Level Complete!"

        let size = getLabelSize(label: uiLabel, char: uiLabel.text!)
        uiLabel.frame = .init(x: frame.width/2 - (size.width/2), y: frame.height/2 - (size.height/2) - 40 + 10, width: 200, height: 25)
        
        button = UIButton(frame: .init(x: frame.width/2 - 100, y: frame.height/2 - 20 + 10, width: 200, height: 40))
        button.setTitle("Next Level", for: .normal)
        button.addTarget(self, action: #selector(onNextLevel), for: .touchUpInside)
        button.titleLabel!.font = uiLabel.font.withSize(14)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5.0
        
        if(gameMode == 2) {
            total_points_game += points_this_round
            
            let points_earned = UILabel(frame: .init(x:0, y: button.frame.maxY + 10, width: 150, height: 25));
            points_earned.tag = 1000
            points_earned.font = UIFont.systemFont(ofSize: 12.0)
            
            let total_points = UILabel(frame: .init(x: frame.width-45 , y: button.frame.maxY + 10, width: 150, height: 25))
            total_points.tag = 2000
            total_points.font = UIFont.systemFont(ofSize: 12.0)
            
            points_earned.text = "\(points_this_round) Points This Round"
            total_points.text = "\(total_points_game) Points So Far"
            
            super.addSubview(points_earned)
            super.addSubview(total_points)
        }
        
        self.addSubview(uiLabel)
        self.addSubview(button)
    }
    
    override func layoutSubviews() {
        let size = getLabelSize(label: uiLabel, char: uiLabel.text!)
        uiLabel.frame = .init(x: frame.width/2 - (size.width/2), y: frame.height/2 - (size.height/2) - 40 + 10, width: 200, height: 25)
        button.frame = .init(x: frame.width/2 - 100, y: frame.height/2 - 20 + 10, width: 200, height: 40)
        
        if let points_earned = self.viewWithTag(1000) as? UILabel {
            points_earned.frame = .init(x:5, y: button.frame.maxY + 10, width: 150, height: 25)
        }
        
        if let total_points = self.viewWithTag(2000) as? UILabel {
            total_points.frame = .init(x: frame.width - 90 , y: button.frame.maxY + 10, width: 150, height: 25)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func onNextLevel() {
        level_skip = false
        points_this_round = 0
    
        viewController?.onLevelComplete();
        sviewController?.onLevelComplete();
    }
}

class CrosswordDefinition : UIView {
    var textblock = UITextView()
    private var definitions : Dictionary<String, String> = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.addSubview(textblock)
        textblock.isEditable = false
        textblock.backgroundColor = .systemBlue
        textblock.textColor = .white
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.cornerRadius = 10.0
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.addSubview(textblock)
    }
    
    func setDefinitions(d: Dictionary<String, String>) {
        definitions = d
        textblock.text = definitions[definitions.first!.key]
    }
    
    func onWordTapped(word: String) {
        textblock.text = definitions[word]
    }
    
    override func layoutSubviews() {
        textblock.frame  = .init(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}

class CrosswordGrid : UIView {
    private var map: Dictionary<Int, CrosswordWordBox> = .init()
    private var focusBox: CrosswordWordBox?
    weak var crossword: CrosswordScreen?
    var called = 0
    private var words: [CrosswordWord] = []
    public var position: [(Int,Int)] = []
    public var orientation: [Orientation] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func lightmode() {
        subviews.forEach { v in
            v.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func darkmode() {
        subviews.forEach { v in
            v.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func setWords(position: [(Int, Int)], orientation: [Orientation]) {
        called += 1
        self.position = position
        self.orientation = orientation
        
        var h = 0;
        var d = 0;
        let screenSize = UIScreen.main.bounds.size
        if screenSize.width > screenSize.height {
            h = 20
            d = 3
        } else {
            h = 30
            d = 2
        }
        
        var index = 0
        position.forEach { position in
            let word = (crossword?.wordsBox!.words[index])! //words order is changing....
            if orientation[index] == .Horizontal {
                drawRow(id: index, start_y: position.0 / d, start_x: position.1 / d, num: word.count, height: h, width: h, layout: false)
            } else {
                drawCol(id: index, start_y: position.0 / d, start_x: position.1 / d, num: word.count, height: h, width: h, layout: false)
            }
            index += 1
        }
    }
    
    override func layoutSubviews() {
        var index = 0
        var h = 0;
        var d = 0;
        
        let screenSize = UIScreen.main.bounds.size
        if screenSize.width > screenSize.height {
            h = 20
            d = 3
        } else {
            h = 30
            d = 2
        }
        
        position.forEach { position in
            let word = (crossword?.wordsBox!.words[index])!
            if orientation[index] == .Horizontal {
                drawRow(id: index, start_y: position.1 / d, start_x: position.0 / d, num: word.count, height: h, width: h, layout: true)
            } else {
                drawCol(id: index, start_y: position.1 / d, start_x: position.0 / d, num: word.count, height: h, width: h, layout: true)
            }
            index += 1
        }
    }
    
    func renderLetter(letter: String) {
        let id = focusBox!.id
        focusBox?.insert(char: letter, fireUpdate: true)
        
        if(map[id + 1] != nil) {
            focusBox = map[id + 1]
        } else {
            focusBox = map[(id/10) * 10]
        }
        
        checkComplete()
    }
    
    func getMax(id: Int) -> Int {
        var max = (id * 10) + 9
        var found = false
        while(!found) {
            let box = map[max]
            if(box != nil) {
                found = true
            }
            else {
                max = max - 1
            }
        }
        return max
    }
    
    func removeLetter() {
        var id = focusBox!.id
        focusBox?.insert(char: " ", fireUpdate: true)
        if(id % 10 == 0) {
            let max = getMax(id: id / 10)
            focusBox = map[max]
        } else {
            id = id - 1
            focusBox = map[id]
        }
    }
    
    func checkComplete() {
        let complete = Set<String>.init(crossword!.viewController!.complete)
        var check = Set<String>.init()
        self.words.forEach { w in
            check.insert(w.text().lowercased())
        }
        if(check == complete) {
            points_this_round = 10
            crossword?.onNextLevel()
        }
    }

    func onBoxFocus(box: CrosswordWordBox) {
        focusBox = box
    }
    
    func framesCollide(lhs: CGRect, rhs: CGRect) -> Bool {
        return (abs(lhs.minX - rhs.minX) < 1.0 && abs(lhs.minY - rhs.minY) < 1.0)
    }
        
    func onBoxUpdated(updates: CrosswordWordBox, old: String, new: String) {
        map.values.forEach { box in
            if(framesCollide(lhs: box.frame, rhs: updates.frame)) {
                box.insert(char: new, fireUpdate: false)
            }
        }
    }
    
    private func drawCol(id: Int, start_y: Int, start_x: Int, num: Int, height: Int, width: Int, layout: Bool = false) {
        let height = height
        let width = width
        let word = CrosswordWord.init(orient: 1)
        var lastId = 0
        var y = start_y
        let x = start_x
        for i in  0...num-1 {
            let boxid = (id * 10) + i
            if(!layout) {
                let box = CrosswordWordBox.init(frame: .init(x: x, y: y, width: width, height: height))
                box.id = boxid
                map[boxid] = box
                box.crossword = self
                super.addSubview(box)
                super.addSubview(box)
                y += width
                lastId = boxid
                word.addBox(box: box)
            } else {
                let box = map[boxid]
                word.addBox(box: box!)
                box!.frame = .init(x: x, y: y, width: width, height: height)
                y += width
            }
        }
        words.append(word)
        word.boxes.forEach { b in
            b.lastId = lastId
        }
    }
    
    private func drawRow(id: Int, start_y: Int, start_x: Int, num: Int, height: Int, width: Int, layout: Bool = false) {
        let height = height
        let width = width
        let word = CrosswordWord.init(orient: 0)
        var x = start_x
        var y = start_y
        var lastId = 0
        for i in  0...num-1 {
            let boxid = (id * 10) + i
            if(!layout) {
                let box = CrosswordWordBox.init(frame: .init(x: x, y: y, width: width, height: height))
                box.crossword = self
                box.id = boxid
                map[boxid] = box
                super.addSubview(box)
                x += height
                lastId = boxid
                word.addBox(box: box)
            } else {
                let boxid = (id * 10) + i
                let box = map[boxid]
                word.addBox(box: box!)
                box!.frame = .init(x: x, y: y, width: width, height: height)
                lastId = boxid
                x += height
            }
        }
        words.append(word)
        word.boxes.forEach { b in
            b.lastId = lastId
        }
    }
    
    func serialize() -> [String] {
        var _words : [String] = []
        for i in 1...7 {
            var word = ""
            var found = true
            var id = 0
            while(found) {
                let boxId = (i * 10) + id
                if(map[boxId] != nil) {
                    word.append(map[boxId]!.getText())
                } else {
                    found = false
                    _words.append(word)
                }
                id += 1
            }
        }
        return _words
    }
}


var puzzleText = ""
class CrosswordScreen: UIView {
    weak var viewController: CrosswordScreenViewController?
    private var map: Dictionary<Int, CrosswordWordBox> = .init()
    public var menuBar: MenuBar?
    public var wordsBox: CrosswordWordsBox?
    public var menu: Menu?
    public var nameLabel: UILabel = .init()
    public var levelComplete: LevelComplete?
    public var gameOver: GameOver?
    public var menuMask: UIView?
    private var focusBox: CrosswordWordBox?
    var crosswordDefinition: CrosswordDefinition?
    private var words: [CrosswordWord] = []
    public var grid: CrosswordGrid?
    private var letterCount = 0
    private var count = 0
        
    func setViewController(vc: CrosswordScreenViewController) {
        viewController = vc
        subviews.forEach { x in
            if let keyboard = x as? CrosswordKeyboard {
                keyboard.injectViewController(viewController: vc)
            }
        }
    }
    
    func hydateScreenFromData(data: SaveData) {
        let grid = self.viewWithTag(20) as! CrosswordGrid;
        self.wordsBox!.renderWords(words: data.puzzleCrossword)
        setNeedsLayout()
    }
    
    func onGameOver() {
        let viewController = GameOverViewController()
        window?.rootViewController = viewController
    }
    
    func onNextLevel() {
        menuMask = UIView(frame: self.frame)
        menuMask!.backgroundColor = UIColor.init(white: 0.0, alpha: 0.30)
        self.addSubview(menuMask!)
        
        if(!level_skip) {
            points_this_round = 10 //from time tick
        }
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        levelComplete = LevelComplete(frame: .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height))
        levelComplete?.viewController = viewController
        levelComplete?.alpha = 0.0
        self.addSubview(levelComplete!)
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.levelComplete?.alpha = 1.0
        })
    }
    
    func onShowMenu() {
        menuMask = UIView(frame: self.frame)
        menuMask!.backgroundColor = UIColor.init(white: 0.0, alpha: 0.30)
        self.addSubview(menuMask!)
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menu = Menu(frame: .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height))
        menu?.screen = self
        menu?.alpha = 0.0
        self.addSubview(menu!)
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.menu?.alpha = 1.0
        })
    }
    
    func onHideMenu() {
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.menu?.alpha = 0.0
        }) {[weak self] _ in
            self?.menu?.removeFromSuperview()
            self?.menuMask?.removeFromSuperview()
            self?.menu = nil
        }
    }
    
    func createKeyboard() -> CrosswordKeyboard {
        var w = 0; var h = 0;
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            w = Int(windowScene.screen.bounds.width)
            h = Int(windowScene.screen.bounds.height)
        }
        
        if(w == 667 && h == 375 || h == 667 && w == 375) {
            return CrosswordKeyboardSE.init()
        } else {
            return CrosswordKeyboard.init()
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        
        menuBar = MenuBar()
        menuBar?.tag = 1
        menuBar?.crossword = self
        super.addSubview(menuBar!)
        
        grid = CrosswordGrid()
        grid?.crossword = self
        grid?.tag = 20
        super.addSubview(grid!)
        
        wordsBox = CrosswordWordsBox()
        wordsBox?.screen = self
        super.addSubview(wordsBox!)
        
        let keyboard = createKeyboard()
        keyboard.tag = 10
        super.addSubview(keyboard)
        
        nameLabel.text = puzzleText
        nameLabel.font = UIFont.systemFont(ofSize: 14.0)
        super.addSubview(nameLabel)
        
       if(difficulty == 3 || difficulty == 4) {
            self.crosswordDefinition = CrosswordDefinition()
            super.addSubview(crosswordDefinition!)
        }
        
        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
    }
    
    func lightmode() {
        backgroundColor = .white
        menuBar?.lightmode()
        grid?.lightmode()
    }
    
    func darkmode() {
        backgroundColor = .black
        menuBar?.darkmode()
        grid?.darkmode()
    }
    
    override func layoutSubviews() {
        if(frame.width > frame.height) {
            landscape()
        } else {
            portrait()
        }
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        gameOver?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
    }
    
    func portrait() {
        wordsBox!.frame = .init(x: 4, y: frame.height - (frame.height * 0.15) - 90, width: frame.width - 8, height: 45)
        menuBar!.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height * 0.10)
        
        let grid = self.viewWithTag(20) as! CrosswordGrid; 
        grid.frame = .init(x: 40, y: (menuBar!.frame.maxY) + 20.0, width: 350, height: 350);
        
        let keyboard = self.viewWithTag(10);
        keyboard?.frame = .init(x: 0, y: frame.height - (frame.height * 0.15) - 45, width: frame.width, height: frame.height / 6)
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        levelComplete?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        
        let originY = wordsBox!.frame.minY - 100
        crosswordDefinition?.frame = .init(x: frame.width/2 - (width/2), y: originY, width: 200, height: 80)
    }
    
    func landscape() {
        print("non se layout")
        menuBar!.frame = .init(x: 0, y: 0, width: frame.width, height: 65)
        
        let grid = viewWithTag(20) as! CrosswordGrid
        grid.frame = .init(x: 80, y: 75, width: 260, height: 260)
        
        let keyboard = viewWithTag(10);
        keyboard?.frame = .init(x: (frame.width/2.15), y: 150, width: (frame.width/2.25), height: frame.height/2.90)
        
        nameLabel.frame = .init(x: (frame.width/2.15), y: 10, width: (frame.width/2.25), height: frame.height/2.90)
        wordsBox!.frame = .init(x: 0, y: frame.height - 45, width: frame.width, height: 45)
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        levelComplete?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        
        let originY = keyboard!.frame.minY - 100
        crosswordDefinition?.frame = .init(x: 500, y: originY, width: 200, height: 80)
    }
    
    func saveGame(name: String) {
        do {
            let grid = viewWithTag(20) as! CrosswordGrid
            try viewController!.onSaveGame(name: name, puzzle: grid.serialize())
        } catch {
            print(error)
        }
    }
    
    func removeKey() {
        let grid = viewWithTag(20) as! CrosswordGrid
        grid.removeLetter()
    }
    
    func renderLetter(letter: String) {
        let grid = viewWithTag(20) as! CrosswordGrid
        grid.renderLetter(letter: letter)
    }
    
    func onBoxFocus(box: CrosswordWordBox) {
        let grid = viewWithTag(20) as! CrosswordGrid
        grid.onBoxFocus(box: box)
    }
        
    func renderTime(time: String) {
        menuBar?.renderTime(time: time)
    }
    
    func renderLevel(level: Int) {
        menuBar?.renderLeevl(level: level)
    }
    
    func renderWords(words: [String], position: [(Int,Int)], orientation: [Orientation], definitions: Dictionary<String, String>) {
        self.wordsBox!.renderWords(words: words)
        self.grid!.setWords(position: position, orientation: orientation)
        self.crosswordDefinition?.setDefinitions(d: definitions)
        self.crosswordDefinition?.setNeedsDisplay()
    }
    
    func framesCollide(lhs: CGRect, rhs: CGRect) -> Bool {
        return (abs(lhs.minX - rhs.minX) < 1.0 && abs(lhs.minY - rhs.minY) < 1.0)
    }
    
    func overlap(one: CrosswordWordBox, two: CrosswordWordBox) -> Bool {
        return framesCollide(lhs: one.frame, rhs: two.frame)
    }
    
    func onBoxUpdates(update: CrosswordWordBox, old: String, new: String) {
        self.words.forEach { w in
            w.boxes.forEach { box in
                if(box.id != update.id && overlap(one: box, two: update)) {
                    box.insert(char: new, fireUpdate: false)
                }
            }
        }
    }
        
    func serialize() -> [String] {
        var s : [String] = []
        words.forEach { w in
            var str : String = ""
            let t = w.text()
            t.forEach { c in
                if(c.description != "") {
                    str.append(" ")
                } else {
                    str.append(c)
                }
            }
            s.append(str)
        }
        return s
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CrosswordWord {
    var boxes: [CrosswordWordBox] = []
    var orientation = 0
    
    init(orient: Int) {
        self.orientation = orient
    }
    
    func addBox(box: CrosswordWordBox) {
        boxes.append(box)
    }
    
    func text() -> String {
        var text = ""
        boxes.forEach { b in
            text.append(b.getText())
        }
        return text
    }
}

class CrosswordSaveData : Codable {
    var type: String
    var words: [String]
    var time: Int
    var level: Int
    var name: String
    
    init(type: String, words: [String], time: Int, level: Int, name: String) {
        self.type = type
        self.words = words
        self.time = time
        self.level = level
        self.name = name
    }
}

class CrosswordScreenViewController: UIViewController {
    var generator: CrosswordGenerator?
    var level = 1
    var timer = Timer()
    private var screen: CrosswordScreen?
    var complete : [String] = []
    var data: SaveData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = ViewFactory().createCrosswordScreen(frame: view.frame)
        v.setViewController(vc: self)
        self.view = v
        screen = v
        
        if(data == nil) {
            Task {
                generator = try await .init()
                generator?.crosswordScreen = v
                let words = generator?.generate()
                words!.0.forEach { w in
                    complete.append(w)
                }
                try await v.renderWords(words: words!.0, position: words!.1, orientation: words!.2, definitions: (generator?.getDefinitions(words: words!.0))!)
                v.renderLevel(level: level)
            }
            
        } else {
            loadFromDisk(data: data!)
        }
    
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.onTimerTick()
        }
    }
    
    func mapQ(_ points: [VirtualPoint]) -> [(Int, Int)] {
        var result : [(Int, Int)] = []
        points.forEach { p in
            result.append((p.x, p.y))
        }
        return result
    }
    
    func loadFromDisk(data: SaveData) {
        Task {
            generator = try await .init()
            level = data.level
            ellapsedTime = data.time
            total_points_game = data.score
            time_selection = data.time_limit
            complete = data.completeCrossword
            try await screen!.renderWords(words: data.completeCrossword, position: mapQ(data.positions), orientation: data.orientations, definitions: (generator?.getDefinitions(words: data.completeCrossword))!)
            
            //screen!.hydateScreenFromData(data: data)
            
            screen!.renderLevel(level: level)
            screen!.renderTime(time: getFormatTime(ellapsedTime))
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                screen?.darkmode()
            } else {
                screen?.lightmode()
            }
        }
    }
    
        
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.view.setNeedsLayout()
        })
    }
    
    func mapPositions(_ positions: [(Int, Int)]) -> [VirtualPoint] {
        var result : [VirtualPoint] = []
        positions.forEach { p in
            result.append(.init(x: p.0, y: p.1))
        }
        return result
    }
    
    func onSaveGame(name: String, puzzle: [String]) throws {
        do {
            let data : SaveData = .init(time: ellapsedTime, time_limit: time_selection, level: level, score: total_points_game, name: name, GameType: "Crossword", puzzleCrossword: puzzle,
                                        completeCrossword: complete, puzzle: [], complete: [], initiallySet: [], guesses: [],
                                        positions: mapPositions(screen!.grid!.position), orientations: screen!.grid!.orientation)
            try Archiver().save(data: data)
            onExitGame()
        } catch {
            print("unable to save game", error)
        }
    }
    
    func onExitGame() {
        let vc = ViewController()
        time_selection = 0
        view.window?.rootViewController = vc
    }
    
    func onRemoveKey(letter: String) {
        screen?.removeKey()
    }
    
    func onLevelComplete() {
        let vc = SudokuViewController()
        vc.level = level + 1
        view.window?.rootViewController = vc
    }
    
    func onKeyPress(letter: String) {
        if(letter == "<") {
            onRemoveKey(letter: letter)
        } else {
            screen?.renderLetter(letter: letter)
        }
    }
    
    func getFormatTime(_ seconds : Int) -> String {
        let (_,m,s) = secondsToHoursMinutesSeconds(seconds)
        return format(num: m) + ":" + format(num: s)
    }
    
    func format(num: Int) -> String {
        if(num < 10) {
            return "0" + num.description
        } else {
            return num.description
        }
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func onTimerTick() {
        if(ellapsedTime == time_selection && time_selection != 0) {
            screen?.onGameOver()
            timer.invalidate()
        } else {
            ellapsedTime += 1
            screen?.renderTime(time: getFormatTime(ellapsedTime))
        }
    }
}


