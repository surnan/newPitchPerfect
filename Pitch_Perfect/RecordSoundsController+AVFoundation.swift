//
//  RecordSoundsController+AVFoundation.swift
//  Pitch_Perfect
//
//  Created by admin on 11/4/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation

extension RecordSoundsController {

//    private func recordAudio(_ sender: AnyObject) {

    func recordAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! session.setCategory(.playAndRecord, mode: .default, options: [])
        
        print("filePath = \(filePath?.absoluteString ?? "xxx")")
        
        guard let tempRecordedAudioURL = filePath else {
            print("Well that was no bueno \nUnable to set tempRecordedAudioURL")
            return
        }
        
        recordedAudioURL =  tempRecordedAudioURL
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func stopRecording(){
        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
        print("stop recording audio")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            fatalError("Did not properly finish recording")
        }
        
        print("finished recording")
        let newPlaySoundController = PlaySoundsController()
        newPlaySoundController.recordedAudioURL = recordedAudioURL
        navigationController?.pushViewController(newPlaySoundController, animated: true)
    }
}
