//
//  RecordSoundsController.swift
//  Pitch_Perfect
//
//  Created by admin on 10/3/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsController: UIViewController, AVAudioRecorderDelegate {
    
    var recordedAudioURL: URL!
    
    
    let micIconSize: CGFloat = 150.0
    var audioRecorder: AVAudioRecorder!
    
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isRecording = false
    
    let recordButton: UIButton = {
        let openingImage = UIImage(named: imageNames.microphone.rawValue)
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(openingImage, for: .normal)
        button.backgroundColor = UIColor.teal
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    @objc private func handleRecordButton(){
        if isRecording == false {
            let openingImage = UIImage(named: imageNames.stop.rawValue)
            recordButton.setImage(openingImage, for: .normal)
            print("isRecording = false")
            recordAudio()
        } else {
            stopRecording()
            let openingImage = UIImage(named: imageNames.microphone.rawValue)
            recordButton.setImage(openingImage, for: .normal)
        }
        isRecording = !isRecording
        updateInstructionLabel()
    }
    
    private func updateRecordButton(){
        recordButton.layer.cornerRadius = micIconSize / 2
    }
    
    
    func setupNavigationBar(){
        navigationItem.title = "Pitch Perfect"
    }
    
    private func setupUI(){
        recordButton.addTarget(self, action: #selector(handleRecordButton), for: .touchDown)
        updateRecordButton()
        [instructionLabel, recordButton].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            recordButton.widthAnchor.constraint(equalToConstant: micIconSize),
            recordButton.heightAnchor.constraint(equalToConstant: micIconSize),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    private func updateInstructionLabel(){
        instructionLabel.text = isRecording ? "Tap to stop recording" : "Tap to start recording"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        updateInstructionLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
        setupUI()
    }
}

