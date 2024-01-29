//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class TrainerViewController: UIViewController {
    
    let h1 = UILabel()
    
    let leftBtn = LeftButton()
    
    let closeBtn = CloseButton()
    
    let statusLab = UILabel()
    
    let errorTitleLab = UILabel()
    let errorTitleImg = UIImageView()
    let errorDescLab = UILabel()
    
    let nextQuestion = RedButton()
    
    let progressBar = UIProgressView()
//    var background = UIImageView()
    
    let viewBody = UIScrollView()
    var navigationBar:[UIButton] = []
    var finishElements:[Any] = []
    
    let components = [TopicButton.self,VariantButton.self,LevelButton.self,QuestionButton.self,AnswerButton.self]
    
    var elemens:[ [String:Any]] = []
    
    var historyElemens:[Any] = []
    var answers:[Any] = []
    
    var uiElements:[UIButton] = []
    
    var IndexQuestion = 0
    var mainStep = 0
    var level = 0
    var category = 0
    var variant = 0
    var resSuccess = 0
    var resError = 0
    override func viewDidLoad() {
//        self.background = view.addBackground(image: "bgMenu")
        view.addBackground(image: "bgMenu")
        setupUI()
        loadData()
        super.viewDidLoad()
        
    }
    
    func setupUI(){
        navigationBar = view.addNavigation(i:0)

        
        navigationBar[0].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        navigationBar[1].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        navigationBar[2].addTarget(self, action: #selector(self.click), for:.touchUpInside)
       
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        
       
        h1.frame = CGRect(x: 24, y: 66, width: view.bounds.maxX-48, height: 32)
        h1.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        h1.font = UIFont(name: "SFProDisplay-Bold", size: 32)
        h1.autoresizesSubviews = true
        h1.lineBreakMode = .byWordWrapping
        h1.numberOfLines = 0
        viewBody.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 150)
        view.addSubview(viewBody)
        viewBody.addSubview(h1)
        viewBody.addSubview(statusLab)
        viewBody.addSubview(errorTitleImg)
        viewBody.addSubview(errorTitleLab)
        viewBody.addSubview(errorDescLab)
        view.addSubview(nextQuestion)
       
        paragraphStyle.lineHeightMultiple = 0.94
        h1.attributedText = NSMutableAttributedString(string: "Тренажеры", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        leftBtn.isHidden = true
        closeBtn.isHidden = true
        statusLab.isHidden = true
        errorTitleImg.isHidden = true
        errorTitleLab.isHidden = true
        errorDescLab.isHidden = true
        nextQuestion.isHidden = true
        nextQuestion.isEnabled = false
        
        closeBtn.frame = CGRect(x: (self.view.bounds.maxX) - 30-24, y: 50, width: 36, height: 36);
        
        statusLab.frame = CGRect(x: 24, y: 444, width: (self.view.bounds.maxX) - 48, height: 13);
        statusLab.textAlignment = .center
        statusLab.textColor = UIColor(red: 0.592, green: 0.612, blue: 0.62, alpha: 1)
        statusLab.font = UIFont(name: "SFProText-Regular", size: 11)

        errorTitleImg.image = UIImage(named: "errorLabel")
        errorTitleImg.frame = CGRect(x: view.bounds.midX-16, y: statusLab.frame.maxY + 70, width: 32, height: 32);
        
        errorTitleLab.frame = CGRect(x: 24, y: errorTitleImg.frame.maxY + 4, width: (self.view.bounds.maxX) - 48, height: 24);
        errorTitleLab.textAlignment = .center
        errorTitleLab.textColor = UIColor(red: 0.882, green: 0.016, blue: 0.012, alpha: 1)
        errorTitleLab.font = UIFont(name: "SFProDisplay-Bold", size: 20)

        errorTitleLab.text = "Essa é a resposta errada."
        
        
        errorDescLab.frame = CGRect(x: 24, y: errorTitleLab.frame.maxY + 20, width: (self.view.bounds.maxX) - 48, height: 60 );
        errorDescLab.textAlignment = .center
        errorDescLab.textColor = UIColor(red: 0.592, green: 0.612, blue: 0.62, alpha: 1)
        errorDescLab.font = UIFont(name: "SFProText-Regular", size: 11)
        errorDescLab.numberOfLines = 0
        errorDescLab.lineBreakMode = .byWordWrapping
    

        nextQuestion.frame = CGRect(x: 24, y: view.bounds.maxY - 55 - 56, width: (self.view.bounds.maxX) - 48, height: 56 );
    
        
        self.viewBody.addSubview(leftBtn)
        self.viewBody.addSubview(closeBtn)
        
        nextQuestion.addTarget(self, action: #selector(self.nextQuestionAction), for:.touchUpInside)
        leftBtn.addTarget(self, action: #selector(self.leftAction), for:.touchUpInside)
        closeBtn.addTarget(self, action: #selector(self.leftAction), for:.touchUpInside)

    }
    
    
    func loadData(parent:Int=0){
        self.leftBtn.isHidden = parent == 0
        if( category==0 || (level>0 && variant>0) ){
            self.category = parent
        } else {
            if(variant==0){
                variant = parent
            } else if (level==0){
                level = parent
            }
        }
        if(self.mainStep==2) {
            level = 0
        } else if(self.mainStep==1){
            variant = 0
        } else if(self.mainStep==0){
            category = 0
        }
       
        
        Api().get(url:"training?category=" + String(category) + "&level=" + String(level) + "&variant=" + String(variant)) { result in
            switch result {
                case .success(let res):
                DispatchQueue.main.async {
//                    print(res)
                    self.paintNewObjects(res: res)
                }
                case .failure(let error):
                    switch(error){
                        case .notAuthenticated:
                            DispatchQueue.main.async {
                               print(error)
                           }
                        default:
                        DispatchQueue.main.async {
                            print(error)
                       }
                    }
            }
            
        }
    }
    
 
    @objc func click(btn:UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil)
        let trenagerController = vc.instantiateViewController(withIdentifier: "trainer") as! TrainerViewController
        let profile = vc.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        let dopController = vc.instantiateViewController(withIdentifier: "about") as! DopViewController
        

        self.present((btn.tag==1 ? trenagerController : (btn.tag==2 ? profile : (btn.tag==3  ? dopController : dopController))), animated: true)
    }
    
    @objc func choseTopicAction() {
        for e in self.finishElements {
            (e as AnyObject).removeFromSuperview()
        }
        self.changeNavAndBg(bool:false)
        self.mainStep -= 1;
        loadData(parent: (self.historyElemens.popLast() as! [String:Any])["parent_id"] as! Int)
        h1.isHidden = false
    }
    @objc func leftAction() {
        self.changeNavAndBg(bool:false)
        self.mainStep -= 1;
        let lastEl = (self.historyElemens.popLast() as! [String:Any]);
        
        loadData(parent: lastEl["parent_id"] as! Int)
    }
    @objc func nextQuestionAction() {
        let questions = self.answers as! [[String:Any]];
        nextQuestion.isEnabled = false
        nextQuestion.titleLabel?.textColor = UIColor(red: 0.36, green: 0.42, blue: 0.6, alpha: 1)
        if((questions.count-1)<IndexQuestion + 1){
            showFinishView()
        } else {
            showQuestions(data: questions, index: IndexQuestion + 1)
        }
    }
    
    @objc func action(btn: UIButton){
        let first = elemens.first{$0["id"] as! Int == btn.tag};
        if(first != nil) {
            self.historyElemens.append(first as Any)
            self.mainStep += 1;
        
            if(first?["parent_id"] as! Int != 0 && level > 0 && variant > 0){
                resSuccess = 0
                resError = 0
                
                let index = (first!["completeCount"] as! Int) < (first!["questions_count"] as! Int) ? first!["completeCount"] as! Int : 0
                
                Api().get(url:"training?category=" + String(btn.tag) + "&level=" + String(level) + "&variant=" + String(variant)) { result in
                    switch result {
                        
                        case .success(let res):
                        DispatchQueue.main.async {
                            self.changeNavAndBg(bool:true)
                          
                            self.showQuestions(data: res["data"] as! [[String:Any]],index:index)
                            self.answers = res["data"] as! [[String:Any]]
                        }
                        case .failure(let error):
                            switch(error){
                                case .notAuthenticated:
                                    DispatchQueue.main.async {
                                       print(error)
                                   }
                                default:
                                DispatchQueue.main.async {
                                    print(error)
                               }
                            }
                    }
                    
                }
                
            } else {
                loadData(parent: btn.tag)
            }

        } else {
            print("Error action")
        }
    }
    
    func changeNavAndBg(bool:Bool=false){
        for e in self.navigationBar {
            e.isHidden = bool
        }
        nextQuestion.isHidden = !bool
        nextQuestion.titleLabel?.textColor = UIColor(red: 0.36, green: 0.42, blue: 0.6, alpha: 1)
        
        nextQuestion.setBackgroundImage(UIImage(named: "nextBgDis"), for: .disabled)
        nextQuestion.setTitleColor(.white, for: .normal)
        nextQuestion.setTitleColor(UIColor(red: 0.36, green: 0.42, blue: 0.6, alpha: 1), for: .disabled)
        
        
//        background.image = UIImage(named: bool ? "bg" :"bgMenu")!
//        background.image = UIImage(named: bool ? "bg" :"bgMenu")!
        view.addBackground(image: bool ? "bg" :"bgMenu")
        leftBtn.isHidden = bool
        progressBar.isHidden = !bool
        closeBtn.isHidden = !bool
        statusLab.isHidden = !bool
        errorTitleImg.isHidden = true
        errorTitleLab.isHidden = true
        errorDescLab.isHidden = true
    }
    
    func showFinishView(){
        for e in self.uiElements {
            e.removeFromSuperview()
        }
        changeNavAndBg()
        h1.isHidden = true
        
        let finishImg = UIImageView(image: UIImage(named: "finishBg"));
        var y = 123;
        finishImg.frame = CGRect(x: Int(self.view.bounds.midX) - 87, y: y, width: 174, height: 140)
        viewBody.addSubview(finishImg)
        finishElements.append(finishImg)
        y += Int(finishImg.bounds.height) + 36;
        
        let finishLabel = UILabel(frame: CGRect(x: 24, y: y, width: Int(self.view.bounds.maxX)-48, height: 100))
        leftBtn.isHidden = true
        finishLabel.text = "Поздравляем!\nВы только что прошли тему: \((self.historyElemens.last as! [String:Any])["name"] as! String)."
        
        finishLabel.textColor = .white
        finishLabel.textAlignment = .center
        finishLabel.font = UIFont(name: "SFProDisplay-Bold", size: 20)
        finishLabel.numberOfLines = 0
        finishLabel.lineBreakMode = .byWordWrapping
        viewBody.addSubview(finishLabel)
        
        finishElements.append(finishLabel)
        
        let finishResultLabel = UILabel();
        finishResultLabel.text = "Ваш результат:"
        finishResultLabel.textColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)
        finishResultLabel.font = UIFont(name: "SFProText-Medium", size: 17)
        y += Int(finishLabel.bounds.height) + 24;
        finishResultLabel.frame = CGRect(x: 24, y: y, width: Int(self.view.bounds.maxX)-48, height: 20)
        finishResultLabel.textAlignment = .center

        viewBody.addSubview(finishResultLabel)
        finishElements.append(finishResultLabel)
        
        y += Int(finishResultLabel.bounds.height) + 16;
        let successAnswer = UIView()
        successAnswer.layer.backgroundColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        successAnswer.layer.cornerRadius = 20
        successAnswer.frame = CGRect(x: 24, y: y, width: Int(self.view.bounds.maxX)-48, height: 56)
       
        let successAnswerImg = UIImageView(image: UIImage(named: "fSuc"))
        successAnswerImg.frame = CGRect(x: 20, y: 16, width: 24, height: 24);
        let successAnswerLabel = UILabel(frame: CGRect(x: 52, y: 19, width: Int(successAnswer.bounds.maxX) - 52 - 70, height: 20))
        successAnswerLabel.text = "Верных ответов:"
        successAnswerLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        successAnswerLabel.font = UIFont(name: "SFProText-Medium", size: 15)
        let successAnswerLabel2 = UILabel(frame: CGRect(x: Int(successAnswerLabel.bounds.maxX), y: 19, width: 50, height: 20))
        successAnswerLabel2.text = String(self.resSuccess)
        successAnswerLabel2.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        successAnswerLabel2.font = UIFont(name: "SFProText-Medium", size: 15)
        successAnswerLabel2.textAlignment = .right

        successAnswer.addSubview(successAnswerImg)
        successAnswer.addSubview(successAnswerLabel)
        successAnswer.addSubview(successAnswerLabel2)
        viewBody.addSubview(successAnswer)
        finishElements.append(successAnswer)
        
        y += Int(successAnswer.bounds.height) + 8
        
        let badAnswer = UIView()
        badAnswer.layer.backgroundColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        badAnswer.layer.cornerRadius = 20
        badAnswer.frame = CGRect(x: 24, y: y, width: Int(self.view.bounds.maxX)-48, height: 56)
    
        let badAnswerImg = UIImageView(image: UIImage(named: "fSuc"))
        badAnswerImg.frame = CGRect(x: 20, y: 16, width: 24, height: 24);
        let badAnswerLabel = UILabel(frame: CGRect(x: 52, y: 19, width: Int(badAnswer.bounds.maxX) - 52 - 70, height: 20))
        badAnswerLabel.text = "Неверных ответов:"
        badAnswerLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        badAnswerLabel.font = UIFont(name: "SFProText-Medium", size: 15)
        let badAnswerLabel2 = UILabel(frame: CGRect(x: Int(badAnswerLabel.bounds.maxX), y: 19, width: 50, height: 20))
        badAnswerLabel2.text = String(self.resError)
        badAnswerLabel2.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        badAnswerLabel2.font = UIFont(name: "SFProText-Medium", size: 15)
        badAnswerLabel2.textAlignment = .right

        badAnswer.addSubview(badAnswerImg)
        badAnswer.addSubview(badAnswerLabel)
        badAnswer.addSubview(badAnswerLabel2)
        viewBody.addSubview(badAnswer)
        finishElements.append(badAnswer)
        
        y += Int(badAnswer.bounds.height) + 24
        
        let choseTopic = RedButton(frame:  CGRect(x: 24, y: y, width: Int(self.view.bounds.maxX)-48, height: 56))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.84
        choseTopic.setAttributedTitle(NSMutableAttributedString(string: "Выбрать новую тему", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
        
        viewBody.addSubview(choseTopic)
        
        finishElements.append(choseTopic)
        choseTopic.addTarget(self, action: #selector(self.choseTopicAction), for: .touchUpInside)
        
    }
    
    @objc func actionAnswer(btn: AnswerButton){
        btn.isEnabled = false
        btn.setSelected()
        
        DispatchQueue.main.async {
            Api().post(url:"training/" + String(self.level) + "/" + String(self.variant) + "/" + String(btn.tag), parameters: [:]) {result in}
        }
        
        let answers  = self.answers[IndexQuestion] as! [String:Any]
        

        let countVariants = (answers["answers"] as! [[String:Any]]).filter{$0["correct"] as! Bool}.count
        
        let countSelect = self.uiElements.filter{ $0.hasSelect() }.count
        
        if(countVariants<=countSelect){
            for e in self.uiElements {
                let answerEl = e as? AnswerButton;
                if(answerEl?.data["correct"] != nil && (answerEl!.isSelect as Bool)){
                    
                    
                    if((answerEl?.data["correct"] as! Int) != 0) {
                        answerEl?.success()
                        self.resSuccess += 1
                    } else {
                        self.resError += 1
                        answerEl?.bad()
                        
                        statusLab.frame = CGRect(x: 24, y: CGFloat(Float.init(((self.uiElements.last  as? AnswerButton)?.frame.maxY)!)) + 30, width: (self.view.bounds.maxX) - 48, height: 13);
                        errorTitleImg.frame = CGRect(x: view.bounds.midX-16, y: statusLab.frame.maxY + 70, width: 32, height: 32);
                        
                        errorTitleLab.frame = CGRect(x: 24, y: errorTitleImg.frame.maxY + 4, width: (self.view.bounds.maxX) - 48, height: 24);
                        errorDescLab.frame = CGRect(x: 24, y: errorTitleLab.frame.maxY + 20, width: (self.view.bounds.maxX) - 48, height: 60 );
                        if(answers["comment"] != nil){
                            errorDescLab.text = answers["comment"] as? String
                        }
                        errorTitleImg.isHidden = false
                        errorTitleLab.isHidden = false
                        errorDescLab.isHidden = false
                    }
                }
                e.isEnabled = false
            }
            nextQuestion.isEnabled = true
            nextQuestion.titleLabel?.textColor = .white
        }
    }
    
    func showQuestions(data:[[String:Any]],index:Int=0){
        self.IndexQuestion = index
        
        for e in self.uiElements {
            e.removeFromSuperview()
        }
        errorTitleImg.isHidden = true
        errorTitleLab.isHidden = true
        errorDescLab.isHidden = true
        
        progressBar.progressViewStyle = .bar
        progressBar.center = view.center

        progressBar.setProgress(Float(Double(index+1) / Double(data.count)), animated: true)

        
        progressBar.trackTintColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 0.08)
        progressBar.tintColor = UIColor(red: 0.96, green: 0.75, blue: 0, alpha: 1)
        
        viewBody.addSubview(progressBar)
        
        progressBar.frame = CGRect(x: 24, y: 64, width: self.view.bounds.maxX - 108, height: 8)
        
    
        h1.text = (data[index]["name"] as! String)
        statusLab.text = "Вы прошли \(index+1)/\(data.count) вопросов"
        
        self.h1.frame = CGRect(x: 24, y: 120, width:  self.h1.bounds.maxX, height: self.h1.font.pointSize*(CGFloat(Int(Int((self.h1.text!.count > 20 ? self.h1.text?.count : 1) ?? 1)/20))+1.25))
        
        var q = 0
        uiElements = []
        
        for tr in (data[index]["answers"] as! [[String:Any]])  {
            paintRows(row:tr,i:q,isQuestion: true)
            q += 1
        }
        let y = Int(h1.bounds.height) + 120 + uiElements.count * 62 + 18 + 29
        statusLab.frame = CGRect(x: 24, y: y, width: Int(self.view.bounds.maxX) - 48, height: 13);
        
    }
    
    func paintNewObjects(res:[String:Any]){
        let data = res["data"] as! [Any]
        errorTitleImg.isHidden = true
        errorTitleLab.isHidden = true
        errorDescLab.isHidden = true
        
        for e in self.uiElements {
            e.removeFromSuperview()
        }

        self.elemens = data as! [[String:Any]]
        if(!data.isEmpty) {
            
            switch mainStep {
                case 0: self.h1.text = "Тренажеры"; break;
                case 1: self.h1.text = "Выберите вариант португальского"; break;
                case 2: self.h1.text = "Ваш уровень языка"; break;
                
            default:
                self.h1.text = "Выберите тему";
            }
            
            self.h1.frame = CGRect(x: 24, y: (self.leftBtn.isHidden ? 56 : 120), width:  self.h1.bounds.maxX, height: self.h1.font.pointSize*(CGFloat(Int(Int((self.h1.text!.count > 20 ? self.h1.text?.count : 1) ?? 1)/20))+1.25))
        }
        
        var i = 0
        for tr in data {
            let row = tr as! [String:Any]
            paintRows(row:row,i:i)
            i += 1;
        }
    }
    
    func paintRows(row:[String:Any],i:Int,isQuestion:Bool=false){
        let el = self.components[isQuestion ? 4 : row["module"] as! Int].init()
        
        let y = Int(self.h1.frame.maxY) + 30 + (i * el.getHeight());
    
        el.setPosition(frame: ["x": 40, "y": y, "width": Int(self.view.bounds.maxX) - 48, "height": 78])
        
        el.setText(text: row["name"] as! String)
        el.setIndex(index: i)
        
        
        if (row["linkImage"] != nil && !(row["linkImage"]  is NSNull)){
            el.setLinkImage(link: row["linkImage"] as! String)
        }
        
        if (row["id"] != nil){
            el.setTag(id: row["id"] as! Int)
        }
        
        el.setData(data: row)
        
        if(isQuestion){
            el.addTarget(self, action: #selector(self.actionAnswer), for: .touchUpInside)
        } else {
            el.addTarget(self, action: #selector(self.action), for: .touchUpInside)
        }
        
        self.viewBody.addSubview(el)
        self.viewBody.contentSize = CGSize(width: view.frame.width, height: CGFloat(y + 98))
        uiElements.append(el)
    }
    
}
