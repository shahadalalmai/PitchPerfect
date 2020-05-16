//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by ShahadAlalmai on 06/05/2020.
//  Copyright © 2020 ShahadAlshareef. All rights reserved.
//

// UIKit is the framework which provides us the UIViewController, UILabel
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Meaning the stopRecordingButton is disabled right from the start after the view is loaded in the memory but not yet displayed
        stopRecordingButton.isEnabled = false
    }

    // This function will be called/excuted whenever the user presses Record button
    // An IBAction (Interface Builder action) is a function which is called when a specific user interaction occurs. Meaning From a user interface element(button) to the code. However, IBOutlet is the action for the code to the interface element. see line 13
    @IBAction func recordAudio(_ sender: Any) { // omit external parameter names by _ and I asume that Any means it accepts any type of value either String, int or event other types of objects
        // This is called cave man debugging when printing out and testing funcs in the consol
        recordingLable.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        print("started recording")

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
           let recordingName = "recordedVoice.wav"
           let pathArray = [dirPath, recordingName]
           let filePath = URL(string: pathArray.joined(separator: "/"))
           let session = AVAudioSession.sharedInstance()
           try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

           try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
           audioRecorder.delegate = self
           audioRecorder.isMeteringEnabled = true
           audioRecorder.prepareToRecord()
           audioRecorder.record()

    }
    
    @IBAction func stopRecording(_ sender: Any) {
//        print("Stop Recording button was pressed")
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLable.text = "Tap to Record"

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)


    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController // forced upcasting the UIViewController to PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL // we set the recordedAudioURL in the PlaySoundsViewController, meaning I can reach the recoded audio in the second controller by the constant recordedAudioURL which is the path of the audio file
            
        }
    }
    
} // end class RecordSoundsViewController

