//
//  AddViewController.swift
//  HotUrls
//
//  Line Stettler & Agovino Marco
// 
//  Workshop 6


import UIKit
import Speech

class AddViewController: UIViewController {

    var delegate: HotUrlDelegate?
    // Hilfsvariablen
    private let audioEngine = AVAudioEngine()
    // Aktuelle Spracheinstellung
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    // Anfrage
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    @IBOutlet weak var nameAudioBtn: UIButton!
    @IBOutlet weak var urlAudioBtn: UIButton!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    
    @IBAction func saveTapped(_ sender: AnyObject) {
        guard let name = nameInput.text, let url = urlInput.text else {
            print("name oder url nicht gesetzt")
            return
        }
        
        delegate?.hotUrlAdded(withName: name, andUrl: url)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameBtnTapped(_ sender: AnyObject) {
        speechInput(forField: nameInput, andButton: nameAudioBtn)
    }
    
    @IBAction func urlBtnTapped(_ sender: AnyObject) {
        speechInput(forField: urlInput, andButton: urlAudioBtn)
    }
    
    private func showError(_ errorMsg: String) {
        
        let alert = UIAlertController(title: "Fehler", message: errorMsg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setRecordingImage(forButton: UIButton) {
        forButton.setImage(UIImage(named: "micro-recording"), for: .normal)
    }
    
    private func setDefaultImage(forButton: UIButton) {
        forButton.setImage(UIImage(named: "micro-default"), for: .normal)
    }
    
    private func resetButtons() {
        setDefaultImage(forButton: nameAudioBtn)
        setDefaultImage(forButton: urlAudioBtn)
    }
    
    // Speech Input
    private func speechInput(forField: UITextField, andButton: UIButton) {
        // wenn AudioEngine schon läuft -> stoppen
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()  // auch beenden
            
            setDefaultImage(forButton: andButton)

        } else {
            
            setRecordingImage(forButton: andButton)
            
            do {
                try getTranscription {
                    (transcript) in
                
                    self.setDefaultImage(forButton: andButton)
            // was transcripiert wurde wird im Feld gespeichert
                    forField.text = transcript
                }
                
            } catch let error as NSError {
                showError(error.localizedDescription)
                setDefaultImage(forButton: andButton)
            }
        }
    }
    // Completion Handler -> Fertigstellen
    private func getTranscription(withHandler: @escaping (_ transcript: String) -> ()) throws {
        
        // alten Task beenden
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Audio aufnehmen vorbereiten
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        // 1. request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            showError("kein inputnode gefunden")
            
            self.resetButtons()
            return
        }
        // 2. Request nicht null
        guard let recognitionRequest = recognitionRequest else {
            print("Request nicht erstellbar")
            
            self.resetButtons()
            return
        }
        // Kein Diktiergerät
        recognitionRequest.shouldReportPartialResults = false
        
        // Mikrophone Zugriff
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.recognitionRequest?.append(buffer)
        }
        
        // Umwandeln von der Aufnahme nach Text
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            self.audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            
            self.recognitionRequest = nil
            self.recognitionTask = nil
            
            guard error == nil else {
                self.showError("Konnte Transkript nicht erstellen")
                
                self.resetButtons()
                return
            }
            
            if let result = result {
                withHandler(result.bestTranscription.formattedString)
            }
        })
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
