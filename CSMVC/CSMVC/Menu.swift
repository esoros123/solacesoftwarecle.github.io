import Foundation
import UIKit

class Menu: UIView {
    weak var screen: CrosswordScreen?
    weak var s: SudokuView?
    var screenType = "Menu"
    
    @objc func _onsavegame() throws {
        let textBox = viewWithTag(200) as! UITextField
        
        let text = textBox.text!
        if(text.contains("-")) {
            
        } else {
            screen?.saveGame(name: textBox.text!)
            try? s?.onSaveGame(name: textBox.text!)
        }
    }
    
    @objc func onBackMenu() {
        renderMenu()
    }
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    override func layoutSubviews() {
        if(screenType == "Menu") {
            let label = super.subviews[3] as! UILabel; let button = super.subviews[0]; let button1 = super.subviews[1]; let button2 = super.subviews[2];
            label.frame = .init(x: frame.width/2, y: 20, width: 100, height: 100)
            label.center.x = (frame.width/2)
            
            if(frame.width > frame.height) {
                let h = frame.height * 0.4
                let w = frame.width * 0.10
                button1.frame = .init(x: frame.width/2 - w/2, y: frame.height - h - 10, width: frame.width / 7.5, height: frame.height * 0.4)
                button2.frame = .init(x: button1.frame.maxX + 5, y: frame.height - h - 10, width: frame.width / 7.5, height: h)
                button.frame = .init(x: button1.frame.minX - (frame.width / 7.5) - 5, y: frame.height - h - 10, width: (frame.width / 7.5), height: frame.height * 0.4)
            } else {
                button2.frame = .init(x: 15, y: frame.height - (frame.height * 0.15) - 5, width: frame.width * 0.9, height: frame.height * 0.15)
                button1.frame = .init(x: 15, y: button2.frame.minY - frame.height * 0.15 - 5, width: frame.width * 0.9, height: frame.height * 0.15)
                button.frame = .init(x: 15, y: button1.frame.minY - frame.height * 0.15 - 5, width: frame.width * 0.9, height: frame.height * 0.15)
            }
        } else {
            let textBox = self.viewWithTag(200); 
            textBox!.frame = .init(x: 0, y: 0, width: frame.width * 0.8, height: 50)
            textBox!.center = .init(x: frame.width/2, y: frame.height/2)
            
            let saveButton = self.viewWithTag(100);
            saveButton?.frame = .init(x: textBox!.frame.minX, y: textBox!.frame.maxY + 5, width: textBox!.frame.width, height: textBox!.frame.height)
        }
    }
    
    @objc func onSaveGame() {
        screenType = "Save"
        subviews.forEach { v in v.removeFromSuperview() }
        
        let textBox = UITextField(frame: .init(origin: .init(x: 0, y: 0), size: .init(width: frame.width*0.8, height: 40)))
        textBox.frame = .init(x: frame.width/2, y: frame.height/2, width: 100, height: 100)
        textBox.text = "Save Name"
        
        let saveButton = UIButton(frame: .init(origin: .init(x: textBox.frame.minX, y: textBox.frame.maxY + 1.0), size: .init(width: frame.width*0.8, height: 40)))
        
        let bb = UIButton(frame: .init(x: 10, y: 10, width: 10, height: 10))
        bb.addTarget(self, action: #selector(onBackMenu), for: .touchUpInside)
        bb.configuration = .plain()
        bb.tintColor = .systemOrange
        bb.configuration?.image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
                    
        self.addSubview(textBox)
        self.addSubview(saveButton)
        self.addSubview(bb)
        
        textBox.layer.cornerRadius = 5.0
        textBox.tag = 200
        textBox.layer.borderColor = .init(gray: 0.5, alpha: 1.0)
        textBox.layer.borderWidth = 2
        textBox.placeholder = "Save Name"
        textBox.font = UIFont.systemFont(ofSize: 14)
        
        saveButton.tag = 100
        saveButton.backgroundColor = .systemOrange
        saveButton.setTitle("Save Game", for: .normal)
        saveButton.addTarget(self, action: #selector(_onsavegame), for: .touchDown)
        saveButton.layer.cornerRadius = 5.0
        saveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
    }
    
    @objc func onExtiGame(){
        screen?.viewController?.onExitGame()
        s?.viewController?.onExitGame()
    }
    
    @objc func onResume() {
        screen?.onHideMenu()
        s?.onHideMenu()
    }
    
    func renderMenu() {
        screenType = "Menu"
        subviews.forEach { v in v.removeFromSuperview() }
        super.backgroundColor = UIColor.secondarySystemBackground
        
        let start = ((frame.height * 0.15) * 3) - (((frame.height * 0.15) * 3)/2) + 70
        let title = UILabel(frame: .init(x: frame.width/2, y: 20, width: 100, height: 100))
        title.text = "Main Menu"
        title.center.x = (frame.width/2)
        
        let button2 = UIButton(frame: .init(x: 15, y: frame.height - (frame.height * 0.15) - 5, width: frame.width * 0.9, height: frame.height * 0.15))
        button2.setTitle("Exit Game", for: .normal)
        button2.backgroundColor = .systemOrange
        button2.addTarget(self, action: #selector(onExtiGame), for: .touchDown)
        button2.layer.cornerRadius = 5.0
        button2.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        
        let button1 = UIButton(frame: .init(x: 15, y: button2.frame.minY - frame.height * 0.15 - 5, width: frame.width * 0.9, height: frame.height * 0.15))
        button1.setTitle("Save Game", for: .normal)
        button1.backgroundColor = .systemCyan
        button1.addTarget(self, action: #selector(onSaveGame), for: .touchDown)
        button1.layer.cornerRadius = 5.0
        button1.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        
        let button = UIButton(frame: .init(x: 15, y: button1.frame.minY - frame.height * 0.15 - 5, width: frame.width * 0.9, height: frame.height * 0.15))
        button.setTitle("Resume", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(onResume), for: .touchDown)
        button.layer.cornerRadius = 5.0
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        
        super.addSubview(button)
        super.addSubview(button1)
        super.addSubview(button2)
        super.addSubview(title)
    }
    
    @objc func onCreate() {
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderMenu()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
