import Foundation
import UIKit

class SavedPuzzle : Codable {
    var name: String = ""
    var data : [SavedPuzzleData] = []
    
    init(xname: String) {
        name = xname
    }
}

class SavedPuzzleData : Codable {
    var row = 0
    var col = 0
    var length = 0
    var orientation = 0
    
    init(c: Int, r: Int, l: Int, o :Int) {
        row = r
        col = c
        length = l
        orientation = o
    }
}

class PuzzleRepository {
    init() {
        createDirectory()
    }
    
    func directoryURL() -> URL {
        let documentsURL = URL.documentsDirectory
        let directoryURL = documentsURL.appending(path: "puzzles")
        return directoryURL
    }
    
    func delete() {
        do {        
            let fileManager = FileManager.default
            try fileManager.removeItem(at: directoryURL())
            createDirectory()
        } catch {
            print("unable to delete and create")
        }
    }
    
    func delete(name: String) {
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: directoryURL().appending(path: name + "-.txt"))
            createDirectory()
        } catch {
            print("unable to delete and create" + error.localizedDescription)
        }
    }
    
    func createDirectory() {
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: directoryURL().path) {
                try fileManager.createDirectory(
                    atPath: directoryURL().path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
        } catch {
            print("unable to create file manager")
        }
    }
    
    func save(name: String, words: [(GridKey, Int, String)]) {
        do {
            let puzzle = SavedPuzzle.init(xname: name)
            words.forEach { word in
                puzzle.data.append(.init(c: word.0.x, r: word.0.y, l: word.1, o: word.2 == "vertical" ? 1 : 0))
            }
            
            let url = directoryURL().appending(path: name + "-.txt")
            let data = try JSONEncoder().encode(puzzle)
            try data.write(to: url)
        } catch {
            print("unable to save puzzle data")
        }
    }
    
    func doPuzzlesExist() -> Bool {
        let name = getNames().randomElement()
        return name != nil
    }
    
    func getRandom() -> SavedPuzzle {
        let name = getNames().randomElement()
        let puzzle = getPuzzle(name: name!)
        return puzzle
    }
        
    func getNames() -> [String] {
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: directoryURL().path)
            var result : [String] = []
            items.forEach { str in
                let s = str.split(separator: "-")
                if(s.count == 2) {
                    result.append(String(s[0]))
                }
            }
            return result
        } catch {
            print("unable to get names \(error.localizedDescription)")
        }
        return []
    }

    
    func getPuzzle(name: String) -> SavedPuzzle {
        do {
            let url = directoryURL().appending(path: name + "-.txt")
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(SavedPuzzle.self, from: data)
            return result
        } catch {
            print("unable to get puzzle")
        }
        return .init(xname: "")
    }
}

class BYOPLoadMenu : UIView {
    private var button: UIButton = .init()
    weak var containerMenu: BYOPMenuContainer?
    public weak var screen: BuildYourOwnPuzzle?
    private var gameNames: [String] = []
    private var stack: [UIButton] = []
    private var buttons: [UIButton] = []
    private var scrollright: UIButton = .init()
    private var scrollleft: UIButton = .init()
    var pageGenerator = PageGenerator.init(itemsPerPage: 0, arrCount: 0)
    private var loadIndex = 0
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
        
        button = UIButton.init(frame: .init(x: 10, y: 10, width: 20, height: 20))
        super.addSubview(button)
        
        let backButton = UIButton.init(frame: .init(x: 20, y: 10, width: 80, height: 20))
        backButton.backgroundColor = .systemRed
        backButton.setTitle("back", for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        scrollright = UIButton.init()
        scrollright.backgroundColor = .systemMint
        scrollright.setTitle(">", for: .normal)
        scrollright.addTarget(self, action: #selector(sr), for: .touchUpInside)
        
        scrollleft = UIButton.init()
        scrollleft.backgroundColor = .systemMint
        scrollleft.setTitle("<", for: .normal)
        scrollleft.addTarget(self, action: #selector(sl), for: .touchUpInside)
                
        super.addSubview(backButton)
        super.addSubview(scrollright)
        super.addSubview(scrollleft)
        
        viewDidLoad()
    }
        
    func stackRemove() {
        stack.forEach { v in
            v.removeFromSuperview()
        }
        stack.removeAll()
    }
    
    func buttonRemove() {
        buttons.forEach { v in
            v.removeFromSuperview()
        }
        buttons.removeAll()
    }
    
    @objc func sr(sender: UIButton) {
        stackRemove(); buttonRemove()
        let loadIndex = pageGenerator.NextPage()
        var localIndex = 0
        gameNames.suffix(from: loadIndex).prefix(5).forEach { nx in
            
            let nb = UIButton.init()
            nb.setTitle(nx, for: .normal)
            nb.tag = localIndex
            nb.backgroundColor = .systemBlue
            nb.addTarget(self, action: #selector(loadSavedGameGame), for: .touchUpInside)
            
            let delnb = UIButton.init()
            delnb.setTitle("delete", for: .normal)
            delnb.tag = localIndex
            delnb.backgroundColor = .systemYellow
            delnb.addTarget(self, action: #selector(xdeleteName), for: .touchUpInside)
            
            super.addSubview(delnb)
            super.addSubview(nb)
            
            stack.append(nb)
            buttons.append(delnb)
            
            localIndex += 1
        }
    }
    
    
    @objc func sl(sender: UIButton) {
        let loadIndex = pageGenerator.PreviousPage()
        var localIndex = 0
        stackRemove(); buttonRemove()
        gameNames.suffix(from: loadIndex).prefix(5).forEach { nx in
            
            let nb = UIButton.init()
            nb.setTitle(nx, for: .normal)
            nb.tag = localIndex
            nb.backgroundColor = .systemBlue
            nb.addTarget(self, action: #selector(loadSavedGameGame), for: .touchUpInside)
            
            let delnb = UIButton.init()
            delnb.setTitle("delete", for: .normal)
            delnb.tag = localIndex
            delnb.backgroundColor = .systemYellow
            delnb.addTarget(self, action: #selector(xdeleteName), for: .touchUpInside)
            
            super.addSubview(delnb)
            super.addSubview(nb)
            
            buttons.append(delnb)
            stack.append(nb)
            
            localIndex += 1
        }
    }
    
    
    @objc func xdeleteName(sender: UIButton) {
        let tileButton = stack[sender.tag]
        let archive = PuzzleRepository()
        archive.delete(name: tileButton.title(for: .normal)!)
            
        gameNames.remove(at: pageGenerator.localToGlobal(localIndex: sender.tag))
        stack.removeAll { $0.tag == sender.tag }
        buttons.removeAll { $0.tag == sender.tag }
        
        tileButton.removeFromSuperview()
        sender.removeFromSuperview()
        
        pageGenerator = PageGenerator.init(itemsPerPage: 5, arrCount: pageGenerator.ArrayCount() - 1)
    }

    override func layoutSubviews() {
        if(frame.height < frame.width) {
            let starty = 10
            let startx = 20
            var index = 0
            stack.forEach { nz in
                nz.frame =  .init(x: startx + (105 * index + 120), y: starty, width: 100, height: 20)
                buttons[index].frame = .init(x: startx + (105 * index + 120), y: starty + 30 , width: 100, height: 20)
                index += 1
            }
            
            scrollleft.frame = .init(x: 10, y: frame.height - 30, width: 40, height: 20)
            scrollright.frame = .init(x: frame.width - 50, y: frame.height - 30, width: 40, height: 20)
        } else {
            let starty = 50
            let startx = 20
            var index = 0
            stack.forEach { nz in
                nz.frame =  .init(x: startx, y: starty + (starty + (25 * index)), width: 100, height: 20)
                buttons[index].frame = .init(x: startx + 110, y: starty + (starty + (25 * index)) , width: 100, height: 20)
                index += 1
            }
            
            scrollleft.frame = .init(x: 10, y: frame.height - 30, width: 40, height: 20)
            scrollright.frame = .init(x: frame.width - 50, y: frame.height - 30, width: 40, height: 20)
        }
    }
    
    @objc func back() {
        let menu = BYOPSaveMenu.init(frame: .init(x: 0, y: 0, width: frame.width, height: frame.height))
        menu.container = containerMenu
        menu.screen = screen
        containerMenu?.setContainerView(v: menu)
    }
    
    func viewDidLoad() {
        let archive = PuzzleRepository()
        gameNames = archive.getNames()
        pageGenerator = PageGenerator.init(itemsPerPage: 5, arrCount: gameNames.count)
        
        let starty = 100
        let startx = 20
        var index = 0
        gameNames.prefix(5).forEach { nz in
            
            let nb = UIButton.init()
            nb.setTitle(nz, for: .normal)
            nb.tag = index
            nb.backgroundColor = .systemBlue
            nb.addTarget(self, action: #selector(loadSavedGameGame), for: .touchUpInside)
            nb.frame =  .init(x: startx + (100 * index + 120), y: starty, width: 100, height: 20)
            
            let delnb = UIButton.init()
            delnb.setTitle("delete", for: .normal)
            delnb.tag = index
            delnb.backgroundColor = .systemYellow
            delnb.addTarget(self, action: #selector(xdeleteName), for: .touchUpInside)
            delnb.frame =  .init(x: startx + (100 * index + 120), y: starty + 200 , width: 100, height: 20)
            
            super.addSubview(delnb)
            buttons.append(delnb)
            
            super.addSubview(nb)
            stack.append(nb)
            
            index += 1
        }
    }

    @objc func loadSavedGameGame(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            let archive = PuzzleRepository()
            let p = archive.getPuzzle(name: title)
            screen!.loadPuzzleFromMenu(puzzle: p)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BYOPMenuContainer : UIView {
    private var _view: UIView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
    }
    
    func setContainerView(v: UIView) {
        _view.removeFromSuperview()
        _view = v
        self.addSubview(_view)
    }
    
    override func layoutSubviews() {
        _view.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    
    @objc func removeView() {
        _view.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BYOPSaveMenu : UIView {
    public weak var screen: BuildYourOwnPuzzle?
    weak var container: BYOPMenuContainer?
    private var saveButton : UIButton = .init()
    private var clearButton: UIButton = .init()
    private var loadButton: UIButton = .init()
    private var menuButton: UIButton = .init()
    private var back: UIButton = .init()
    private var name: UITextField = .init()
    private var save : UIButton = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutMenu()
        backgroundColor = UIColor.secondarySystemBackground
    }
    
    @objc func layoutMenu() {
        back.frame = .init();
        back.removeFromSuperview(); name.removeFromSuperview(); save.removeFromSuperview();
        
        saveButton.frame = .init(x: 10 , y: frame.height - 60, width: 100, height: 50)
        saveButton.layer.cornerRadius = 12.0
        saveButton.addTarget(self, action: #selector(layoutSave), for: .touchDown)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .green
        
        clearButton.frame = .init(x: saveButton.frame.minX + 50 , y: frame.height - 60, width: 100, height: 50)
        clearButton.layer.cornerRadius = 12.0
        clearButton.addTarget(self, action: #selector(onClose), for: .touchDown)
        clearButton.setTitle("Close", for: .normal)
        clearButton.backgroundColor = .systemYellow
        
        loadButton.frame = .init(x: 10 , y: frame.height - 60, width: 100, height: 50)
        loadButton.layer.cornerRadius = 12.0
        loadButton.addTarget(self, action: #selector(xxload), for: .touchDown)
        loadButton.setTitle("Load", for: .normal)
        loadButton.backgroundColor = .systemRed
        
        menuButton.frame = .init(x: frame.width-105 , y: 10, width: 100, height: 50)
        menuButton.layer.cornerRadius = 12.0
        menuButton.addTarget(self, action: #selector(onMenu), for: .touchDown)
        menuButton.setTitle("Menu", for: .normal)
        menuButton.backgroundColor = .systemOrange
        
        self.addSubview(saveButton)
        self.addSubview(clearButton)
        self.addSubview(menuButton)
        self.addSubview(loadButton)
    }
    
    @objc func xxload() {
        let xxxload = BYOPLoadMenu(frame: .init(x: 0, y: 0, width: frame.width, height: frame.height))
        xxxload.containerMenu = container
        xxxload.screen = screen
        container?.setContainerView(v: xxxload)
    }
    
    func renderMenu() {
        saveButton.frame = .init(x: 10 , y: frame.height - 60, width: 100, height: 50)
        clearButton.frame = .init(x: saveButton.frame.minX + 50 , y: frame.height - 60, width: 100, height: 50)
        menuButton.frame = .init(x: frame.width-105 , y: 10, width: 100, height: 50)
        loadButton.frame = .init(x: clearButton.frame.minX + 50 , y: frame.height - 60, width: 100, height: 50)
    }
    
    @objc func savePuzzle() {
        let words = screen?.grid.getWords()
        let archiver = PuzzleRepository()
        archiver.save(name: name.text!, words: words!)
    }
    
    @objc func layoutSave() {
        saveButton.removeFromSuperview(); clearButton.removeFromSuperview(); menuButton.removeFromSuperview(); loadButton.removeFromSuperview();
        
        back.frame = .init(x: 10 , y: frame.height - 60, width: 100, height: 50)
        back.layer.cornerRadius = 12.0
        back.addTarget(self, action: #selector(layoutMenu), for: .touchDown)
        back.setTitle("Back", for: .normal)
        back.backgroundColor = .green
        
        name.frame = .init(x: 10 , y: frame.height / 2, width: 100, height: 50)
        name.layer.cornerRadius = 12.0
        name.textColor = .white
        if(screen?.name != nil) {
            name.text = screen!.name
        } else {
            name.text = "Save Name"
        }
        name.addTarget(self, action: #selector(layoutSave), for: .touchDown)
        name.backgroundColor = .black
        
        save.frame = .init(x: 10 , y: frame.height - 60, width: 100, height: 50)
        save.layer.cornerRadius = 12.0
        save.addTarget(self, action: #selector(savePuzzle), for: .touchDown)
        save.setTitle("Save", for: .normal)
        save.backgroundColor = .systemPink
        
        self.addSubview(back)
        self.addSubview(name)
        self.addSubview(save)
    }
        
    @objc func renderSave() {
        back.frame = .init(x: 10 , y: frame.height - 60, width: 100, height: 50)
        save.frame = .init(x: 50, y: frame.height - 60, width: 100, height: 50)
        name.frame = .init(x: 10 , y: save.frame.minY - 100, width: frame.width - 50, height: 50)
    }
             
    func onTextChanged() {

    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onBackButton() {
        back.removeFromSuperview(); name.removeFromSuperview(); save.removeFromSuperview();
        layoutMenu()
    }
    
    @objc func onMenu() {
        let vc = ViewController()
        self.window?.rootViewController = vc
    }
    
    override func layoutSubviews() {
        if(back.frame.minX == 0) {
            renderMenu()
        } else {
            renderSave()
        }
    }
    
    @objc func onClose() {
        screen?.onCloseMenu()
    }
}

class BuildYourOwnPuzzleViewController: UIViewController {
    override func viewDidLoad() {
        let v = BuildYourOwnPuzzle(frame: self.view.frame)
        self.view = v
    }
}

class ByopGridItem : UIButton {
    var isHighlght = false
    var x = 0
    var y = 0
    var txt = ""
    var label: UILabel = .init()
    var parentVertical = 0
    var parentHoriztonal = 0
    weak var grid: ByopGrid?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 2.0
        layer.cornerRadius = 2.0
        addTarget(self, action: #selector(xonTapx), for: .touchDown)
        layer.borderColor = UIColor.systemGray5.cgColor
        
        super.addSubview(label)
    }
    
    func clear() {
        txt = ""
        label.text = ""
        isHighlght = false
        layer.borderColor = UIColor.gray.cgColor
    }
    
    func setText(str: String) {
        txt = str
        label.frame = .init(x: 8, y: 2, width: 10, height: 20)
        label.text = str
    }
    
    func isRemove() -> Bool {
        return layer.borderColor == UIColor.systemPink.cgColor
    }
    
    func setPosition(x: Int, y: Int) {
        self.x = x; self.y = y
    }
    
    func highlight() {
        layer.borderColor = UIColor.systemBlue.cgColor
        isHighlght = true
    }
    
    @objc func xonTapx() {
        if(layer.borderColor == UIColor.systemPink.cgColor) {
            isHighlght = false
            clear()
            grid?.removeFromCache(key: .init(x: self.x, y: self.y))
        }
    }
        
    func onRemove() {
        layer.borderColor = UIColor.systemPink.cgColor
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

struct GridKey: Hashable {
    let x: Int
    let y: Int
}

class ByopGrid: UIView {
    var index = 0
    var gridCache : [GridKey : ByopGridItem] = .init()
    
    func gridItemHeight() -> CGFloat {
        return frame.width/10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in  0...8 {
            for  j in 0...8 {
                let xx = i * 30
                let yy = j * 30
                let item = ByopGridItem.init(frame: .init(x: CGFloat(10 + xx), y: CGFloat(10 + yy), width: frame.width/10, height: frame.height/10))
                item.grid = self
                super.addSubview(item)
            }
        }
    }
    
    func clear() {
        for (_,v) in gridCache {
            v.clear()
        }
        gridCache.removeAll()
    }
    
    func getLetterAt(key: GridKey) -> String {
        let item = gridCache[key]
        if let xitem = item {
            return xitem.txt
        }
        return ""
    }
    
    private func GetWordsX() -> [GridKey : Int]  {
        var words : [GridKey : Int] = .init()
        for item in subviews {
            let xitem = item as! ByopGridItem
            if(xitem.isHighlght) {
                var xPos = xitem.x
                let yPos = xitem.y
                var parentX = 0
                var count = 0
                
                //go "left" find the parent, and then go "right" and count
                while(xPos != 10) {
                    if !gridCache.keys.contains(.init(x: xPos, y: yPos)) {
                        break
                    }
                    xPos -= 1
                }
                
                parentX = xPos + 1
                xPos = parentX
                while(xPos != 9) {
                    if !gridCache.keys.contains(.init(x: xPos, y: yPos)) {
                        break
                    }
                    xPos += 1
                    count += 1
                }
                
                if(count >= 3) {
                    words[.init(x: parentX, y: yPos)]  = count
                }
            }
        }
        return words
    }
    
    private func GetWordsY()  -> [GridKey : Int]  {
        var words : [GridKey : Int] = .init()
        for item in subviews {
            let xitem = item as! ByopGridItem
            if(xitem.isHighlght) {
                let xPos = xitem.x
                var yPos = xitem.y
                var parentY = 0
                var count = 0
                
                while(yPos != 10) {
                    if !gridCache.keys.contains(.init(x: xPos, y: yPos)) {
                        break
                    }
                    yPos -= 1
                }
                
                parentY = yPos + 1
                yPos = parentY
                while(yPos != 10) {
                    if !gridCache.keys.contains(.init(x: xPos, y: yPos)) {
                        break
                    }
                    yPos += 1
                    count += 1
                }
                
                if(count >= 3) {
                    words[.init(x: xPos, y: parentY)]  = count
                }
            }
        }
        return words
    }
    
    func getWords() -> [(GridKey, Int, String)] {
        var result : [(GridKey, Int, String)] = []
        let y = GetWordsY()
        let x = GetWordsX()
        for (k, v) in y {
            result.append((k, v, "vertical"))
        }
        for (k, v) in x {
            result.append((k, v, "hotizontal"))
        }
        return result
    }
    
    func onColorModeChange() {
        for item in subviews {
  
        }
    }
    
    func removeFromCache(key: GridKey) {
        gridCache.removeValue(forKey: key)
    }
    
    func setWord(key: GridKey, direction: Int, text: String) {
        var x = key.x
        var y = key.y
        for c in text {
            let item = gridCache[.init(x: x, y: y)]!
            item.setText(str: String(c))
            if(direction == 0) {
                x += 1
            } else {
                y += 1
            }
        }
    }
    
    func isRemove() -> Bool {
        for item in subviews {
            let xitem = item as! ByopGridItem
            if(xitem.isHighlght && xitem.isRemove()) {
                return true
            }
        }
        return false
    }
    
    func tapRemove() {
        for item in subviews {
            let xitem = item as! ByopGridItem
            if(xitem.isHighlght) {
                xitem.onRemove()
            }
        }
    }
    
    func endRemove() {
        for item in subviews {
            let xitem = item as! ByopGridItem
            if(xitem.isHighlght) {
                xitem.highlight()
            }
        }
    }
    
    func highlight(x: Int, y: Int) {
        var index = 0
        for item in subviews {
            let selectedItem = item as! ByopGridItem
            if Int(selectedItem.frame.minX) < x && Int(selectedItem.frame.maxX) > x && Int(selectedItem.frame.maxY) > y && Int(selectedItem.frame.minY) < y {
                selectedItem.highlight()
                selectedItem.setPosition(x: Int(selectedItem.frame.maxX/selectedItem.frame.width), y: Int(selectedItem.frame.maxY/selectedItem.frame.height))
                gridCache[.init(x: selectedItem.x, y: selectedItem.y)] = selectedItem
            }
            index += 1
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BuildYourOwnPuzzle : UIView {
    private var addButton : UIButton = .init()
    private var saveButton: UIButton = .init()
    private var removeButton: UIButton = .init()
    private var generate: UIButton = .init()
    private var fixup: UIButton = .init()
    private var nameLabel: UILabel = .init()
    var name = ""
    var grid: ByopGrid = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.systemBackground
        
        addButton = .init(frame: .init(x: 10, y: frame.height-75, width: 100, height: 50))
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 12.0
        addButton.setTitle("+", for: .normal)
        addButton.addTarget(self, action: #selector(xaddView), for: .touchDown)
        super.addSubview(addButton)
        
        removeButton = .init(frame: .init(x: 90, y: frame.height-75, width: 100, height: 50))
        removeButton.backgroundColor = .systemRed
        removeButton.layer.cornerRadius = 12.0
        removeButton.setTitle("-", for: .normal)
        removeButton.addTarget(self, action: #selector(xremove), for: .touchDown)
        super.addSubview(removeButton)
        
        saveButton = .init(frame: .init(x: frame.width - 120, y: frame.height-75, width: 100, height: 50))
        saveButton.backgroundColor = .systemGreen
        saveButton.layer.cornerRadius = 12.0
        saveButton.setTitle("=", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        super.addSubview(saveButton)
        
        nameLabel = .init(frame: .init(x: 10, y: 10, width: 100, height: 50))
        nameLabel.text = ""
        super.addSubview(nameLabel)
        
        generate = .init(frame: .init(x: frame.width - 300, y: frame.height-75, width: 100, height: 50))
        generate.backgroundColor = .systemMint
        generate.layer.cornerRadius = 12.0
        generate.setTitle("Generate", for: .normal)
        generate.addTarget(self, action: #selector(geneerate1), for: .touchDown)
        super.addSubview(generate)
                
        grid = .init(frame: .init(x: addButton.frame.maxX, y: 50, width: 300, height: 300))
        super.addSubview(grid)
    }
    
    func loadPuzzleFromMenu(puzzle: SavedPuzzle) {
        onCloseMenu()
        name = puzzle.name
        nameLabel.text = name
        grid.clear()
        puzzle.data.forEach { d in
            print("data", d.row, d.col, d.length, d.orientation)
            let h = grid.gridItemHeight()
            for i in 1...d.length {
                if(d.orientation == 1) {
                    grid.highlight(x: Int(h) + ((d.col-1) * Int(h)), y: (Int(h) * i) + ((d.row-1) * Int(h)))
                } else {
                    grid.highlight(x: (Int(h) * i) + ((d.col-1) * Int(h)), y: Int(h) + ((d.row-1) * Int(h)))
                }
            }
        }
    }
    
    @objc func geneerate1() {
        let wordList = WordList()
        Task {
            try await wordList.generate()
            let words = self.grid.getWords()
            for t in words {
                let firstLetter = grid.getLetterAt(key: t.0)
                let arayz = firstLetter == "" ? NSMutableArray.init() : [CharacterPosition.init(0, firstLetter.first!)]
                let word = wordList.getWord(t.1, arayz)
                let dir = t.2 == "vertical" ? 1 : 0
                grid.setWord(key: .init(x: t.0.x, y: t.0.y), direction: dir, text: word)
            }
        }
    }
    
    @objc func xremove() {
        if(grid.isRemove()) {
            grid.endRemove()
        } else {
            grid.tapRemove()
        }
    }
    
    @objc func xaddView(sender: UIButton, event: UIEvent) {
        if let test = hitTest(.init(x: addButton.frame.minX, y: addButton.frame.minY - 30), with: nil) {
            if test is BYOPuzzleWord {
                return
            }
        }
        
        grid.endRemove()

        let word = BYOPuzzleWord.init()
        word.isUserInteractionEnabled = true
        word.frame = .init(x: addButton.frame.minX, y: addButton.frame.minY - 30, width: 25, height: 25)
        self.addSubview(word)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(xhandlePan(_:)))
        word.addGestureRecognizer(panGesture)
    }
    
    func onColorModeChange() {
        //change color of grid item here
    }
    
    @objc func xhandlePan(_ sender: UIPanGestureRecognizer) {
        guard let xview = sender.view else { return }
        let translation = sender.translation(in: self)
        xview.center = CGPoint (
            x: xview.center.x + translation.x,
            y: xview.center.y + translation.y
        )
        sender.setTranslation(.zero, in: self)
        
        if(sender.state == .ended) {
            let cview = convert(xview.frame, to:  grid)
            grid.highlight(x: Int(cview.minX), y: Int(cview.minY))
            xview.removeFromSuperview()
        }
    }
    
    func onCloseMenu() {
        let menu = self.viewWithTag(10000)
        let menuMask = self.viewWithTag(20000)
        UIView.animate(withDuration: 0.25, animations: {[] in
            menu!.alpha = 0.0
            menu!.removeFromSuperview()
            menuMask!.removeFromSuperview()
        })
        {[] _ in}
    }
        
    @objc func save() {
        let menuMask = UIView(frame: self.frame)
        menuMask.tag = 10000
        menuMask.backgroundColor = UIColor.init(white: 0.0, alpha: 0.30)
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        
        let menu = BYOPMenuContainer(frame: .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height))
        menu.tag = 20000
        menu.alpha = 0.0
        
        self.addSubview(menuMask)
        self.addSubview(menu)

        UIView.animate(withDuration: 0.25, animations: {[] in
            menu.alpha = 1.0
            let saveMenu = BYOPSaveMenu.init(frame: .init(x: 0, y: 0, width: menu.frame.width, height: menu.frame.height))
            saveMenu.container = menu
            saveMenu.screen = self
            menu.setContainerView(v: saveMenu)
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        if(frame.width > frame.height) {
            addButton.frame = .init(x: 10, y: frame.height-75, width: 100, height: 50)
            saveButton.frame = .init(x: frame.width - 120, y: frame.height-75, width: 100, height: 50)
            generate.frame = .init(x: frame.width - 175, y: frame.height-75, width: 100, height: 50)
            fixup.frame = .init(x: frame.width - 500, y: 10, width: 100, height: 50)
            grid.frame = .init(x: addButton.frame.maxX, y: 10, width: 300, height: 300)
            grid.center.x = self.center.x; grid.center.y = self.center.y;
            removeButton.frame = .init(x: 90, y: frame.height-75, width: 100, height: 50)
        } else {
            addButton.frame = .init(x: 10, y: frame.height-75, width: 100, height: 50)
            saveButton.frame = .init(x: frame.width - 120, y: frame.height-75, width: 100, height: 50)
            generate.frame = .init(x: frame.width - 250, y: frame.height-75, width: 100, height: 50)
            fixup.frame = .init(x: frame.width - 500, y: 10, width: 100, height: 50)
            grid.frame = .init(x: frame.width/10, y: 80, width: 300, height: 300)
            grid.center.x = self.center.x; grid.center.y = self.center.y - 80
            removeButton.frame = .init(x: 90, y: frame.height-75, width: 100, height: 50)
        }
        
        let menuMask = viewWithTag(10000)
        menuMask?.frame = frame

        let height : CGFloat = frame.height * 0.5
        let width : CGFloat = frame.width / 1.15
        let menu = self.viewWithTag(20000)
        menu?.frame = CGRect(x:frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: frame.width / 1.15, height: frame.height * 0.5)
    }
}

class BYOPuzzleWord: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = .init(x: frame.width/2 - frame.width/2, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
