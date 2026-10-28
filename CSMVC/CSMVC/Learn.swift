import Foundation
import UIKit

//skip color

class MathFacts : UIView {
    var b = UIButton.init()
    var refresh = UIButton.init()
    var label = UITextView.init()
    var vocab = UIButton.init()
    weak var vc: MathViewController?
    
    let facts = [ "Gemotry was invented by the phenocians in 1907",
                  "The Birthday Paradox shows that in a group of just 23 people, there is a greater than 50% chance that two people share the same birthday",
                  "A deck of 52 cards has 52! (52 factorial) possible arrangements, which is written out as 8.065 \times 10^{67} (an 8 followed by 67 zeros).",
                  "Euler authored over 850 books and papers during his lifetime, creating roughly a quarter of all 18th-century scientific output in mathematics, physics, and mechanics",
                 "Pierre de Fermat was actually a full-time lawyer and judge, and he only pursued mathematics as a passionate hobby",
                 "The number 4 is the only number in the English language that has the exact same number of letters as its numerical value (f-o-u-r = 4)",
                 "-40°C and -40°F are the exact same temperature.", "There is no zero in Roman numerals",
                 "Celebrated annually on March 14 (3/14) to match the first three digits of the number, which is also Albert Einstein’s birthday.",
                 "Pi (π) represents the ratio of a circle's circumference (distance around) to its diameter (distance straight across).",
                 "The record for blindfolded recitation of pi belongs to Rajveer Meena, who memorized and recited 70,000 decimal places in 2015)",
                 "If you invest $1 at a 100% annual interest rate, compounding continuously, you will end up with exactly $2.72 (e dollars) at the end of one year.",
                  "If you enter a lottery that has a 1-in-a-million chance of winning, and you buy exactly 1 million tickets, your chance of losing every single one of them is roughly 37%",
                   "In physics, vectors are used to represent quantities that have both a magnitude (size) and a direction, such as velocity, force, and acceleration",
                  "The dot product of two perpendicular vectors is always zero, because the cosine of a 90-degree angle is zero.",
                  "Venn diagrams were popularized by English logician John Venn in 1880, though he originally called them Eulerian circles after Swiss mathematician Leonhard Euler.", "The odds of winning the Powerball jackpot are about 1 in 292.2 million.", "The largest U.S. Powerball jackpot ever won reached $2.04 billion in November 2022.", "The word geometry comes from Greek words geo and metria as early humans used it to survey land and redraw property lines after floods.",
                    "The interior angles of a four-sided shape always add up to 360", "A circle has infinite lines of symmetry because any straight line drawn directly through its center splits it into two identical halves.", "All 4-digit palindromic numbers (numbers that read the same forward and backward, such as 1221 or 5885) are always divisible by 11", "Every integer greater than 1 is either a prime number itself or can be represented as a unique product of prime numbers", "The equation a^n + b^n = c^n has no positive integer solutions for n > 2", "Al-Khwārizmī used algebra to describe the method of moving negative terms to the other side of an equation to restore a balance—a practice we still use today", " Al-Khwārizmī's name was later translated into Latin as Algoritmi, which gave us the modern word algorithm.", "Al-Khwarizmi is credited with founding algebra as an independent field of study rather than just a tool for geometry.", "Sir Isaac Newton and Gottfried Wilhelm Leibniz developed modern calculus independently in the late 17th century.",
                        "The word calculus comes from the Latin term calculus, meaning a small counting stone used for tallying and abacus counting.",
                        "In certian jurisdictions, compound interest is considered evil", "There are more ways to arrange a standard 52-card deck than there are atoms on the entire Earth.", "Among all closed shapes with the exact same perimeter, a circle encloses the greatest possible area", "A circle has zero vertices, corners, or straight edges.", "Every point along the outer edge is the exact same distance from the center point.",
                  " A square has 4 lines of reflectional symmetry and 4-fold rotational symmetry.", "A square is both a regular quadrilateral, a special type of rectangle, and a special type of rhombus", "A triangle with a 90-degree angle follows the Pythagorean theorem.", "The combined length of any two sides of a triangle must always be greater than the length of the third side", "Triangles are the most rigid and stable geometric shape, which is why engineers use them in bridges, roof trusses, and towers", "A scalene triangle is a triangle where all three sides are different lengths, and all three angles are different sizes.",
                    "Parallel lines never intersect, no matter how far you extend them.", "On a coordinate plane, parallel lines always share the exact same slope",
                  "A histogram is the most commonly used graph to show frequency distributions.", "The histogram is one of the seven basic tools of quality control."]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.systemBackground

        
        b = UIButton.init(frame: .init(x: 50, y: 50, width: 100, height: 40))
        b.addTarget(self, action: #selector(LearnViewController.back), for: .touchDown)
        b.layer.cornerRadius = 5.0
        b.backgroundColor = .systemOrange
        b.setTitle("back", for: .normal)
        
        label = .init(frame: .init(x: 100, y: 200, width: 300, height: 300))
        label.text = "Gemotry was invented by the phenocians in 1907"
        label.center = CGPoint(x: bounds.midX, y: bounds.midY + 100)
        label.font = UIFont.systemFont(ofSize: 16)
        
        refresh = UIButton.init(frame: .init(x: 160, y: 50, width: 100, height: 40))
        refresh.backgroundColor = .systemPink
        refresh.addTarget(self, action: #selector(xrefresh), for: .touchDown)
        refresh.layer.cornerRadius = 5.0
        refresh.setTitle("refresh", for: .normal)
        
        vocab = UIButton.init(frame: .init(x: 270, y: 50, width: 100, height: 40))
        vocab.backgroundColor = .systemBlue
        vocab.addTarget(self, action: #selector(onvocab), for: .touchDown)
        vocab.layer.cornerRadius = 5.0
        vocab.setTitle("vocab", for: .normal)
        
        addSubview(b); addSubview(refresh); addSubview(label); addSubview(vocab);
    }
    
    override func layoutSubviews() {
        label.center = CGPoint(x: bounds.midX, y: bounds.midY + 50)
    }
    
    @objc func back() {
        let view = ViewController()
        self.window?.rootViewController = view
    }
    
    @objc func onvocab() {
        let viewController = LearnViewController()
        self.window?.rootViewController = viewController
    }
    
    @objc func xrefresh() {
        label.text = facts.randomElement()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LearnView : UIView {
    weak var vc: LearnViewController?
    var b = UIButton.init()
    var refresh = UIButton.init()
    var label = UILabel.init()
    var definitionx = UITextField.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.systemBackground

        
        b = UIButton.init(frame: .init(x: 50, y: 50, width: 100, height: 40))
        b.addTarget(self, action: #selector(LearnViewController.back), for: .touchDown)
        b.layer.cornerRadius = 5.0
        b.backgroundColor = .systemOrange
        b.setTitle("back", for: .normal)
        
        refresh = UIButton.init(frame: .init(x: 160, y: 50, width: 100, height: 40))
        refresh.addTarget(vc, action: #selector(LearnViewController.loadWordAndDefintion), for: .touchDown)
        refresh.backgroundColor = .systemPink
        refresh.layer.cornerRadius = 5.0
        refresh.setTitle("refresh", for: .normal)
        
        let mfacats = UIButton.init(frame: .init(x: 270, y: 50, width: 100, height: 40))
        mfacats.addTarget(vc, action: #selector(LearnViewController.showMathFacts), for: .touchDown)
        mfacats.backgroundColor = .systemBlue
        mfacats.layer.cornerRadius = 5.0
        mfacats.setTitle("math facts", for: .normal)
        
        label = UILabel.init(frame: .init(x: 50, y: 100, width: 100, height: 50))
        label.text = "Word of the day"
        
        definitionx = UITextField.init(frame: .init(x: 50, y: 300, width: 800, height: 300))
        definitionx.text = "Definition"
        definitionx.layer.cornerRadius = 3.0
        definitionx.backgroundColor = .systemBlue
        definitionx.textColor = .white
        
        addSubview(mfacats)
        self.addSubview(label)
        self.addSubview(b)
        self.addSubview(definitionx)
        self.addSubview(refresh)
    }
        
    override func layoutSubviews() {
        if(frame.width > frame.height) {
            label.frame = .init(x: 50, y: 150, width: 100, height: 50)
            definitionx.frame = .init(x: 50, y: 200, width: 600, height: 100)
        } else {
            label.frame = .init(x: 50, y: 150, width: 100, height: 50)
            definitionx.frame = .init(x: 50, y: 200, width: 300, height: 100)
        }
    }
    
    func setWordAndDefinition(word: String, defintiton: String) {
        label.text = word
        definitionx.text = defintiton
    }
    
    @objc func back() {
        vc?.back()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MathViewController : UIViewController {
    private var vieww: MathFacts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = ViewFactory.init().createMathFacts(frame: view.frame)
        self.view = v
    }
}

class LearnViewController : UIViewController {
    private var learnView: LearnView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = LearnView(frame: self.view.frame)
        self.view = v
        v.vc = self
        learnView = v
        
        loadWordAndDefintion()
    }
    
    @objc func showlearn() {
        let v = LearnView(frame: self.view.frame)
        self.view = v
        v.vc = self
        learnView = v
        loadWordAndDefintion()
    }
    
    @objc func showMathFacts() {
        let viewController = MathViewController()
        self.view.window?.rootViewController = viewController
    }
        
    @objc func loadWordAndDefintion() {
        Task {
            let wordList = WordList()
            try await wordList.generate()
            let word = wordList.getWord(5, NSMutableArray.init())
            let definition = try await wordList.getDefinition(targets: [word])
            learnView?.setWordAndDefinition(word: word, defintiton: definition[word]!)
        }
    }
    
    @objc func back() {
        let view = ViewController()
        self.view.window?.rootViewController = view
    }
}
