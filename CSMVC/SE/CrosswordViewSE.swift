import Foundation
import UIKit

class CrosswordScreenSE : CrosswordScreen {
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
    
    override func portrait() {
        wordsBox!.frame = .init(x: 4, y: frame.height - (frame.height * 0.15) - 90, width: frame.width - 8, height: 45)
        menuBar!.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height * 0.10)
        
        let grid = self.viewWithTag(20) as! CrosswordGrid;
        grid.frame = .init(x: 10, y: (menuBar!.frame.maxY) + 5.0, width: 350, height: 350);
        
        let keyboard = self.viewWithTag(10);
        keyboard?.frame = .init(x: 0, y: frame.height - (frame.height * 0.15) - 45, width: frame.width - 30, height: frame.height / 5)
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        levelComplete?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        
        let originY = wordsBox!.frame.minY - 100
        crosswordDefinition?.frame = .init(x: frame.width/2 - (width/2), y: originY, width: 200, height: 80)
        
        if(crosswordDefinition == nil) {
            nameLabel.frame = .init(x: frame.width/2 - (width/2), y: originY, width: 200, height: 80)
        } else {
            nameLabel.frame = .init(x: 250, y: originY, width: 80, height: 40)
        }
    }
    
    override func landscape() {
        menuBar!.frame = .init(x: 0, y: 0, width: frame.width, height: 65)
        
        let grid = viewWithTag(20) as! CrosswordGrid
        grid.frame = .init(x: 80, y: 55, width: 260, height: 260)
        
        let keyboard = viewWithTag(10);
        keyboard?.frame = .init(x: (frame.width/2.15), y: 150, width: (frame.width/2.25), height: frame.height/2.90)
        
        wordsBox!.frame = .init(x: 0, y: frame.height - 45, width: frame.width, height: 45)
        nameLabel.frame = .init(x: (frame.width/2.15), y: 0, width: (frame.width/2.25), height: frame.height/2.90)

        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        levelComplete?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        
        let originY = keyboard!.frame.minY - 100
        crosswordDefinition?.frame = .init(x: 50, y: 260, width: 200, height: 40)
    }
    
}

class CrosswordKeyboardSE : CrosswordKeyboard {
    override func layoutSubviews() {
        let height = frame.height / 4
        let width = frame.width / 10
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
}
