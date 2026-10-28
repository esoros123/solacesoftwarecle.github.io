import Foundation


enum Orientation : Codable {
    case Vertical
    case Horizontal
}

class CharacterPosition {
    var position = 0
    var character : Character = "0"
    init(_ position: Int, _ character: Character) {
        self.position = position
        self.character = character
    }
}

class WordList {
    private var _three : NSMutableArray = .init()
    private var _four : NSMutableArray = .init()
    private var _five : NSMutableArray = .init()
    private var _six : NSMutableArray = .init()
    private var _seven : NSMutableArray = .init()
    private var _eight : NSMutableArray = .init()
    private var _nine : NSMutableArray = .init()
        
    private func getRandom(_ strs: NSMutableArray, _ chars: NSMutableArray) -> String {
        let shuffeled = strs.shuffled()
        if(chars.count == 0) {
            return shuffeled[0] as! String
        }
        for strElement in shuffeled {
            let str = strElement as! String
            var found = true
            for posElem in chars {
                let position = (posElem as! CharacterPosition)
                found = found && str[str.index(str.startIndex, offsetBy: position.position)] == position.character
            }
            if found {
                return str
            }
        }
        
        return "";
    }
    
    func getDefinition(targets: [String]) async throws -> Dictionary<String, String> {
        var results : Dictionary<String, String> = [:]
        let filePath = Bundle.main.url(forResource:"wordlist", withExtension: "txt")!
        let (bytes, _) = try await URLSession.shared.bytes(from: filePath)
        
        for try await line in bytes.lines {
            let split = line.split(separator: " ");
            let word = String.init(split[0]);
            if(targets.contains(word)) {
                var result = String.init();
                for i in 2 ..< split.count {
                    result += split[i] + " "
                }
                results[String.init(word)] = result
            }
        }
        
        return results
    }
    
    func generate() async throws {
        let filePath = Bundle.main.url(forResource:"wordlist", withExtension: "txt")!
        let (bytes, _) = try await URLSession.shared.bytes(from: filePath)
        for try await line in bytes.lines {
            let str = line.split(separator: " ")[0];
            let length = str.count
            if(length == 3) {
                _three.add(str)
            } else if (length == 4) {
                _four.add(str)
            } else if (length == 5) {
                _five.add(str)
            } else if (length == 6) {
                _six.add(str)
            } else if (length == 7) {
                _seven.add(str)
            } else if (length == 8) {
                _eight.add(str)
            } else if (length == 9) {
                _nine.add(str)
            }
        }
    }
    
    func getWord(_ count: Int, _ chars: NSMutableArray) -> String {
        if(count == 3) {
            return getRandom(_three, chars)
        } else if (count == 4) {
            return getRandom(_four, chars)
        } else if (count == 5) {
            return getRandom(_five, chars)
        } else if (count == 6) {
            return getRandom(_six, chars)
        } else if (count == 7) {
            return getRandom(_seven, chars)
        } else if (count == 8) {
            return getRandom(_eight, chars)
        } else if (count == 9) {
            return getRandom(_nine, chars)
        }
        return ""
    }
}

class Letter {
    private var _letter: Character
    private var _xPosition: Double
    private var _yPosition: Double
    
    init(_ _xPosition: Double, _ _yPosition: Double) {
        self._letter = "0"
        self._xPosition = _xPosition
        self._yPosition = _yPosition
    }
    
    func getY() -> Double {
        return _yPosition
    }
    
    func getX() -> Double {
        return _xPosition
    }
    
    func insert(_ letter: Character) {
        _letter = letter
    }
    
    func getCharacter() -> Character {
        return _letter
    }
    
    func reset() {
        _letter = "0"
    }
}

class Word {
    private var id : Int
    private var letters : NSMutableArray
    public var word = ""
    
    init(_ id: Int, _ letters: NSMutableArray) {
        self.id = id
        self.letters = letters
    }

    func getSize() -> Int {
        return letters.count;
    }
    
    func getID() -> Int {
        return id
    }
    
    func getLetters() -> NSMutableArray {
        return letters
    }
    
    func reset() {
        letters.forEach { item in
            (item as! Letter).reset()
        }
    }
    
    func doubleEquals(_ expected: Double, _ actual: Double) -> Bool {
        return abs(actual - expected) < 1.0;
    }
    
    func onLetterInserted(_ _id: Int, _ x: Double, _ y: Double, _ c: Character) {
        if(_id == id) {
            return
        }
        
        letters.forEach { item in
            let l = (item as! Letter)
            if(doubleEquals(x, l.getX()) && doubleEquals(y, l.getY())) {
                l.insert(c)
            }
        }
    }
    
    func insert(_ str: String) {
        var index = 0
        str.forEach { char in
            (letters.object(at: index) as! Letter).insert(char)
            index += 1
        }
        word = str
    }
    
    func getWord() -> String {
        return word
    }
}

class Puzzle {
    private var _words : NSMutableArray
    private var _wordList : WordList
    
    init(_ _words: NSMutableArray, _ _wordList: WordList) {
        self._words = _words
        self._wordList = _wordList
    }

    func isValid() -> Bool {
        var result = true
        _words.forEach { item in
            if (item as! Word).word == "" {
                result = false
            }
        }
        return result
    }
    
    func isAlpha(_ str: String) -> Bool {
        var found = true
        for char in str {
            found = found && char.isLetter
        }
        return found
    }
    
    func generate() {
        _words.forEach { wItem in
            let word = (wItem as! Word)
            let size = word.getSize()
            let positions = NSMutableArray()
            
            var i = 0
            word.getLetters().forEach { lItem in
                let letter = (lItem as! Letter)
                if(letter.getCharacter() != "0") {
                    positions.add(CharacterPosition.init(i, letter.getCharacter()))
                }
                i = i + 1
            }
           
            let generatedWord = _wordList.getWord(size, positions)
            word.insert(generatedWord)
            _words.forEach { wItem in
                for lItem in word.getLetters() {
                    let updateWord = (wItem as! Word)
                    let letter = (lItem as! Letter)
                    updateWord.onLetterInserted(word.getID(), letter.getX(), letter.getY(), letter.getCharacter());
                }
            }
        }
    }
    
    func reset() {
        _words.forEach { item in
            (item as! Word).reset()
        }
    }
    
    func getWords() -> NSMutableArray {
        return _words
    }
    
    func print1() {
        _words.forEach { item in
            Swift.print((item as! Word).getWord())
        }
        Swift.print("\n")
    }
}

let fundamentalSize = 60

class CrosswordGenerator {
    private var list = WordList()
    weak var crosswordScreen : CrosswordScreen?
    
    init() async throws {
        try await list.generate()
    }
    
    func getDefinitions(words: [String]) async throws -> Dictionary<String, String> {
        return try await list.getDefinition(targets: words);
    }
    
    private func fillPuzzle(_ shape: ([String],[(Int,Int)], [Orientation])) -> ([String],[(Int,Int)], [Orientation]) {
        var puzzle: Puzzle?
        repeat {
            let words = NSMutableArray.init()
            let boxSizex = 60.0
            let boxSizey = 60.0
            var index = 0
            for str in shape.0 {
                let letters = NSMutableArray()
                var x = Double(shape.1[index].0)
                var y = Double(shape.1[index].1)
                for _ in str {
                    letters.add(Letter.init(x, y))
                    if(shape.2[index] == .Horizontal) {
                        x += boxSizex
                    } else {
                        y += boxSizey
                    }
                }
                words.add(Word.init(index, letters))
                index += 1
            }
            puzzle = .init(words, list)
            puzzle!.generate()
        } while (!puzzle!.isValid())
        
        var strs : [String] = []
        for w in puzzle!.getWords() {
            let word = (w as! Word)
            strs.append(word.getWord())
        }
        
        return (
            strs, shape.1, shape.2
        )
    }
    
    func generatePuzzle9() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod1234", "123456", "1234", "123423", "123", "1234", "123", "123"],
                [   (Int(boxWidth), Int(boxHeight * 5)),
                    (Int(boxWidth * 2), Int(boxHeight * 3)),
                    (Int(boxWidth * 5), Int(boxHeight * 3)),
                    (Int(boxWidth * 7), Int(boxHeight * 1)),
                    (Int(boxWidth * 7), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 8)),
                    (Int(boxWidth * 2), Int(boxHeight)),
                    (Int(boxWidth * 6), Int(boxHeight * 8)),
                ],
                [
                    Orientation.Horizontal, Orientation.Vertical, Orientation.Vertical, Orientation.Vertical, Orientation.Horizontal,
                    Orientation.Horizontal, Orientation.Horizontal, Orientation.Horizontal,
                ])
        ]
        crosswordScreen?.nameLabel.text = "twin peaks"
        return results[0];
    }
    
    func generatePuzzle8() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod1234", "1234", "1234", "123", "123", "1234", "12345", "1234"],
                [   (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth * 2), Int(boxHeight)),
                    (Int(boxWidth * 6), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 4)),
                    (Int(boxWidth * 5), Int(boxHeight * 4)),
                    (Int(boxWidth * 3), Int(boxHeight * 4)),
                    (Int(boxWidth * 5), Int(boxHeight * 4)),
                    (Int(boxWidth * 3), Int(boxHeight * 6))
                ],
                [
                    Orientation.Horizontal,  Orientation.Vertical,  Orientation.Vertical,
                    Orientation.Horizontal,  Orientation.Horizontal, Orientation.Vertical, Orientation.Vertical,
                    Orientation.Horizontal
                ])
        ]
        crosswordScreen?.nameLabel.text = "twin peaks"
        return results[0];
    }
    
    func generatePuzzle7() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["1234","1234", "1234", "1234567", "123", "123", "12345", "123"],
                [   (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth * 3), Int(boxHeight * 3)),
                    (Int(boxWidth * 5), Int(boxHeight * 5)),
                    (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth * 3), Int(boxHeight)),
                    (Int(boxWidth * 5), Int(boxHeight * 3)),
                    (Int(boxWidth), Int(boxHeight * 7)),
                    (Int(boxWidth * 5), Int(boxHeight * 5)),
                ],
                [
                    Orientation.Horizontal,Orientation.Horizontal,Orientation.Horizontal,
                    Orientation.Vertical, Orientation.Vertical,  Orientation.Vertical,
                    Orientation.Horizontal,  Orientation.Vertical
                ])
        ]
        crosswordScreen?.nameLabel.text = "The Throne"
        return results[0];
    }
    
    func generatePuzzle6() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod12345", "1234","1234", "123", "12345", "123", "123"],
                [   (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth * 2), Int(boxHeight)),
                    (Int(boxWidth * 5), Int(boxHeight)),
                    (Int(boxWidth * 7), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 4)),
                    (Int(boxWidth * 4), Int(boxHeight * 4)),
                    (Int(boxWidth), Int(boxHeight * 4)),
                ],
                [
                    Orientation.Horizontal, Orientation.Vertical, Orientation.Vertical, Orientation.Vertical,
                    Orientation.Horizontal, Orientation.Vertical, Orientation.Vertical
                ])
        ]
        crosswordScreen?.nameLabel.text = "twin peaks"
        return results[0];
    }
    
    func generatePuzzle5() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod1234", "123", "1234", "12345", "12345", "123", "123"],
                [
                    (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 2)),
                    (Int(boxWidth), Int(boxHeight * 4)),
                    (Int(boxWidth), Int(boxHeight * 6)),
                    (Int(boxWidth * 7), Int(boxHeight)),
                    (Int(boxWidth * 6), Int(boxHeight * 7)),
                    (Int(boxWidth * 4), Int(boxHeight))
                ],
                [
                    Orientation.Vertical, Orientation.Horizontal, Orientation.Horizontal, Orientation.Horizontal,Orientation.Vertical,
                    Orientation.Horizontal, Orientation.Horizontal
                ])
        ]
        crosswordScreen?.nameLabel.text = "The librarian"
        return results[0];
    }
    
    func generatePuzzle4() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod12", "sod12", "sod12", "sod12", "sod12", "sod"],
                [   (Int(boxWidth), Int(boxHeight * 5)),
                    (Int(boxWidth * 2), Int(boxHeight * 4)),
                    (Int(boxWidth * 3), Int(boxHeight * 3)),
                    (Int(boxWidth * 4), Int(boxHeight * 2)),
                    (Int(boxWidth * 5), Int(boxHeight * 1)),
                    (Int(boxWidth * 1), Int(boxHeight * 5)),
                ],
                [
                    Orientation.Horizontal, Orientation.Horizontal, Orientation.Horizontal, Orientation.Horizontal, Orientation.Horizontal,
                    Orientation.Vertical
                ])
        ]
        crosswordScreen?.nameLabel.text = "The Pipeline"
        return results[0];
    }
    
    func generatePuzzle3() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod123", "sod123", "sod123", "sod123", "123", "111"],
                [   (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth * 6), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 6)),
                    (Int(boxWidth), Int(boxHeight * 4)),
                    (Int(boxWidth * 4), Int(boxHeight * 3)),
                ],
                [
                    Orientation.Horizontal, Orientation.Vertical, Orientation.Vertical, Orientation.Horizontal,
                    Orientation.Horizontal, Orientation.Horizontal, Orientation.Horizontal
                ])
        ]
        crosswordScreen?.nameLabel.text = "The Pond"
        return results[0];
    }
    
    func generatePuzzle2() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod", "asd", "oscan", "wags", "1234567", "axel1"],
                [   (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 3)),
                    (Int(boxWidth * 2), Int(boxHeight)),
                    (Int(boxWidth * 2), Int(boxHeight * 5)),
                    (Int(boxWidth * 5), Int(boxHeight)),
                    (Int(boxWidth * 2), Int(boxHeight * 7))
                ],
                [
                    Orientation.Horizontal, Orientation.Horizontal, Orientation.Vertical, Orientation.Horizontal, Orientation.Vertical,
                    Orientation.Horizontal
                ])
        ]
        crosswordScreen?.nameLabel.text = "Touchdown"
        return results[0];
    }
    
    func generatePuzzle1() -> ([String],[(Int,Int)], [Orientation]) {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["sod", "asd", "oscan", "wags", "123456"],
                [   (Int(boxWidth), Int(boxHeight)),
                    (Int(boxWidth), Int(boxHeight * 3)),
                    (Int(boxWidth * 2), Int(boxHeight)),
                    (Int(boxWidth * 2), Int(boxHeight * 5)),
                    (Int(boxWidth * 5), Int(boxHeight))
                ],
                [
                    Orientation.Horizontal, Orientation.Horizontal, Orientation.Vertical, Orientation.Horizontal, Orientation.Vertical
                ])
        ]
        crosswordScreen?.nameLabel.text = "The Locker Room"
        return results[0];
    }
    
    func generatePuzzle10() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["wags","wags","wags","wags","wags","wags","wags", "wags"],
                [   (Int(boxWidth * 1), Int(boxHeight)),
                    (Int(boxWidth * 4), 0),
                    (0,Int(boxHeight * 4)),
                    (Int(boxWidth * 2), 0),
                    (Int(boxWidth * 1), Int(boxHeight * 6)),
                    (Int(boxWidth * 6), Int(boxHeight * 0)),
                    (Int(boxWidth * 6), Int(boxHeight * 0)),
                    (Int(boxWidth * 9), Int(boxHeight * 0))
                ],
                [
                  Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal, Orientation.Vertical,
                ])
        ]
        crosswordScreen?.nameLabel.text = "Town Hall"
        return results[0]
    }
    
    func generatePuzzle11() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["wags","wags", "wags", "wags", "wags","wags", "wags", "wags"],
                [   (Int(boxWidth * 1), Int(boxHeight)),
                    (Int(boxWidth * 4), Int(boxHeight)),
                    (Int(boxWidth * 1), Int(boxHeight * 4)),
                    (Int(boxWidth * 1), Int(boxHeight * 1)),
                    
                    (Int(boxWidth * 6), Int(boxHeight)),
                    (Int(boxWidth * 9), Int(boxHeight)),
                    (Int(boxWidth * 6), Int(boxHeight * 4)),
                    (Int(boxWidth * 6), Int(boxHeight * 1)),
                ],
                [
                  Orientation.Horizontal, Orientation.Vertical, Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal, Orientation.Vertical, Orientation.Horizontal, Orientation.Vertical
                ])
        ]
        return results[0]
    }
    
    func generatePuzzle() -> ([String],[(Int,Int)], [Orientation])  {
        let boxWidth = fundamentalSize
        let boxHeight = fundamentalSize
        let results : [([String],[(Int,Int)], [Orientation])] = [
                (["wags","oscan","byron","mantrap","apojove","saratov","sod"],
                [   (Int(boxWidth * 1), Int(boxHeight)),
                    (Int(boxWidth * 4), 0),
                    (0,Int(boxHeight * 4)),
                    (Int(boxWidth * 2), 0),
                    (Int(boxWidth * 1), Int(boxHeight * 6)),
                    (Int(boxWidth * 6), Int(boxHeight * 0)),
                    (Int(boxWidth * 6), Int(boxHeight * 0))
                ],
                [
                  Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal, Orientation.Vertical,
                  Orientation.Horizontal
                ])
        ]
        crosswordScreen?.nameLabel.text = "The Opener"
        return results[0]
    }
        
    func generateCharacters(data: SavedPuzzleData) -> String {
        var result = ""
        for _ in  1...data.length {
            result.append("a")
        }
        return result
    }
    
    func getOrientation(data: SavedPuzzleData) -> Orientation {
        if(data.orientation == 1) {
            return .Vertical
        } else {
            return .Horizontal
        }
    }
    
    func getPositionTuple(data: SavedPuzzleData) -> (Int, Int) {
        return (fundamentalSize * data.col, fundamentalSize * data.row)
    }
    
    func getPuzzle() {
        let puzzle = PuzzleRepository().getRandom()
    }
    
    func savedPuzzle() -> ([String],[(Int,Int)], [Orientation]) {
        let puzzle = PuzzleRepository().getRandom()
        var result : ([String],[(Int,Int)], [Orientation]) = ([], [], [])
        puzzle.data.forEach { d in
            result.0.append(generateCharacters(data: d))
            result.1.append(getPositionTuple(data: d))
            result.2.append(getOrientation(data: d))
        }
              
        crosswordScreen?.nameLabel.text = puzzle.name
        return fillPuzzle(result)
    }
    
    func generate() -> ([String],[(Int,Int)], [Orientation]) {
        let exists = PuzzleRepository().doPuzzlesExist()
        let randomn = Int.random(in: 0...2)
        if(randomn == 1 && useCustomGames == true && exists) {
            return fillPuzzle(savedPuzzle())
        } else {
            let randomNum = Int.random(in: 0...11)
            switch randomNum {
                case 0: return fillPuzzle(generatePuzzle())
                case 1: return fillPuzzle(generatePuzzle1())
                case 2: return fillPuzzle(generatePuzzle2())
                case 3: return fillPuzzle(generatePuzzle3())
                case 4: return fillPuzzle(generatePuzzle4())
                case 5: return fillPuzzle(generatePuzzle5())
                case 6: return fillPuzzle(generatePuzzle6())
                case 7: return fillPuzzle(generatePuzzle7())
                case 8: return fillPuzzle(generatePuzzle8())
                case 9: return fillPuzzle(generatePuzzle8())
                case 10: return fillPuzzle(generatePuzzle8())
                case 11: return fillPuzzle(generatePuzzle11())
                default: return fillPuzzle(generatePuzzle9())
            }
        }
    }
}
