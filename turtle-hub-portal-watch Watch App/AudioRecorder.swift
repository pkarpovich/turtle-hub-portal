//
//  AudioRecorder.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    private var recordingURL: URL = {
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent("temp_recording.m4a")
    }()
    
    func startRecording() throws {
        try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }
    
    func stopRecording() throws -> Data? {
        audioRecorder?.stop()
        audioRecorder = nil
        
        let recordedData = try Data(contentsOf: recordingURL)
        try FileManager.default.removeItem(at: recordingURL)
        
        return recordedData
    }
}
