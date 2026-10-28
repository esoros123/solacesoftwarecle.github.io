import Foundation

class SudokuViewSE : SudokuView {
    override func layoutSubviews() {
        if(frame.width > frame.height) {
            menuBar?.frame = .init(x: 0, y: 0, width: frame.width, height: 75)
            grid?.frame = .init(x: 50, y: menuBar!.frame.maxY + 20, width: frame.width/3.5, height: frame.width/4)
            keyboard?.frame = .init(x: grid!.frame.maxX + (frame.width/5), y: frame.height/2 - 25, width: frame.width/3, height: 50)
            buttons!.frame = .init(x: grid!.frame.maxX + (frame.width/5), y: keyboard!.frame.maxY + 10, width: frame.width/3, height: 50)
        } else {
            menuBar?.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height * 0.10)
            grid?.frame = .init(x: (frame.width/2) - ((frame.height/3)/2), y: frame.height/2 - (frame.height/3)/2 - menuBar!.frame.height - 40, width: frame.height/3, height: frame.height/3)
            buttons!.frame = .init(x: 20, y: frame.height - 150, width: frame.width/1.25, height: 48)
            keyboard?.frame = .init(x: 20, y: buttons!.frame.maxY + 10, width: frame.width/1.25, height: 50)
            
            buttons!.center.x = self.center.x
            keyboard?.center.x =  self.center.x
        }
        
        let height = frame.height * 0.5
        let width = frame.width / 1.15
        menuMask?.frame = frame
        menu?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        levelComplete?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
        gameOver?.frame = .init(x: frame.width/2 - (width/2), y: frame.height/2 - (height/2), width: width, height: height)
    }
}
