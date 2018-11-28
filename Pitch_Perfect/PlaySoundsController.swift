//
//  PlaySoundsController.swift
//  Pitch_Perfect
//
//  Created by admin on 10/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsController: UIViewController {
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var tempFloat2: CGFloat = 0
    var tempFloat3: CGFloat = 0.7

    enum ButtonType: Int {
        case slow = 0, echo, fast, chipmunk, darthvader, reverb
    }
    
    let slowButton: UIButton = {
        let openingImage = UIImage(named: "slow")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.red
        button.tag = ButtonType.slow.rawValue
        button.layer.cornerRadius = button.bounds.size.width / 2
        return button
    }()
    
    let echoButton: UIButton = {
        let openingImage = UIImage(named: "echo")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.tag = ButtonType.echo.rawValue

        return button
    }()
    
    let fastButton: UIButton = {
        let openingImage = UIImage(named: "fast")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.yellow
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.tag = ButtonType.fast.rawValue
        return button
    }()

    let chipmunkButton: UIButton = {
        let openingImage = UIImage(named: "chipmunk")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.teal
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.tag = ButtonType.chipmunk.rawValue
        return button
    }()
    
    
    let darthvaderButton: UIButton = {
        let openingImage = UIImage(named: "darthvader")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.tag = ButtonType.darthvader.rawValue
        return button
    }()
    
    let reverbButton: UIButton = {
        let openingImage = UIImage(named: "reverb")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.tag = ButtonType.reverb.rawValue
        return button
    }()
    
    let stopButton: UIButton = {
        let openingImage = UIImage(named: "_stop")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
       let button = UIButton()
        let myString = "RECORD A NEW SOUND"
        let myAttrString = NSAttributedString(string: myString, attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 16.0) as Any,
                                                                             NSAttributedString.Key.foregroundColor : UIColor.teal,
                                                                            ])
        button.setAttributedTitle(myAttrString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a sound filter"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    
    let horizontalRowTop: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let horizontalRowMiddle: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let horizontalRowBtm: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let finalVerticalStack: UIStackView = {
       var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            [self.slowButton, self.echoButton, self.fastButton, self.reverbButton, self.chipmunkButton, self.darthvaderButton, self.stopButton].forEach{

                
                $0.transform = self.view.transform.scaledBy(x: self.tempFloat3, y: self.tempFloat3)
                
                
                $0.layer.cornerRadius =  $0.bounds.size.width / 2
                $0.clipsToBounds = true
            }
        }
       configureUI(.notPlaying)  //set the buttons when music is playing
    }
    
    func removeBackButton(){
        backButton.removeFromSuperview()
    }
    
    func removeStopButton(){
        stopButton.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = UIColor.darkBlue
        
        [slowButton, echoButton, fastButton, reverbButton, chipmunkButton, darthvaderButton].forEach{
            $0.addTarget(self, action: #selector(handleSoundButton), for: .touchDown)
        }
        
        stopButton.addTarget(self, action: #selector(handleStopButton), for: .touchDown)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchDown)
        
        guard let tempFloat:CGFloat = stopButton.imageView?.image?.size.height else {return}
        tempFloat2 = tempFloat * tempFloat3
        
        setupSoundButtonStack()
        
        [horizontalRowTop, horizontalRowMiddle, horizontalRowBtm, backButton, titleLabel].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            horizontalRowTop.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            horizontalRowMiddle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            horizontalRowBtm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            horizontalRowTop.bottomAnchor.constraint(equalTo: horizontalRowMiddle.bottomAnchor, constant: -tempFloat2),
            horizontalRowMiddle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horizontalRowBtm.topAnchor.constraint(equalTo: horizontalRowMiddle.topAnchor, constant: tempFloat2),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: horizontalRowTop.topAnchor),
            ])
        
        
        
        
        
        
        
        
        
        
        
        
        setupAudio()  //loads up the recorded file from RecordSoundsController()
    }
    
    
    private func setupNavigationBar(){
        navigationItem.title = "Pitch Perfect"
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func handleSoundButton(_ sender: UIButton?){
        switch(ButtonType(rawValue: (sender?.tag)!)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .darthvader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }

    
    @objc func handleStopButton(_ sender: UIButton?){
        stopAudio()
    }

    
    @objc func handleBackButton(_ sender: UIButton?){
        print("RECORD NEW SOUND PRESSED")
        navigationController?.popViewController(animated: true)
    }
    
    
    func setupSoundButtonStack(){
        [slowButton, fastButton].forEach{horizontalRowTop.addArrangedSubview($0)}
        [chipmunkButton, stopButton, darthvaderButton].forEach{horizontalRowMiddle.addArrangedSubview($0)}
        [echoButton, reverbButton].forEach{horizontalRowBtm.addArrangedSubview($0)}
        [horizontalRowTop, horizontalRowMiddle, horizontalRowBtm].forEach{finalVerticalStack.addArrangedSubview($0)}
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


/*
     override func viewDidLayoutSubviews() {
         slowButton.layer.cornerRadius = slowButton.bounds.size.width / 2
         slowButton.clipsToBounds = true
         echoButton.layer.cornerRadius = echoButton.bounds.size.width / 2
         echoButton.clipsToBounds = true
         fastButton.layer.cornerRadius = echoButton.bounds.size.width / 2
         fastButton.clipsToBounds = true
     }
 

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == .compact {
            finalVerticalStack.axis = .horizontal
            [horizontalRowTop, horizontalRowMiddle, horizontalRowBtm].forEach{$0.axis = .vertical}
            print("vertical class = compact")
        } else if traitCollection.verticalSizeClass == .regular{
            finalVerticalStack.axis = .vertical
            [horizontalRowTop, horizontalRowMiddle, horizontalRowBtm].forEach{$0.axis = .horizontal}
            print("vertical class = regular")
        }
    }
*/
