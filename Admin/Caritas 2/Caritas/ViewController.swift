//
//  ViewController.swift
//  Caritas
//
//  Created by Alumno on 06/09/22.
//
//LOGIN
import UIKit
import Foundation
import CoreMotion
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var txUser: UITextField!
    
    @IBOutlet weak var txPassword: UITextField!
    
    var username: String!
    var password: String!
    var usuario: String!
    var pass: String!
    var decryptedPassword: String!
    
    let singleton = UserDefaults.standard
    
    let manager = CMMotionManager()
    var player: AVAudioPlayer?
    var playing = false
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "audio", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(playing)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //GUARDAR DATO DE USER EN EL SINGLETON
    
    /*var proyectos: String!
    var dias: String!
    var postulado: String!*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        manager.startAccelerometerUpdates()
        manager.startGyroUpdates()
        //self.playSound()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if let data = self.manager.accelerometerData{
                
                let x1 = data.acceleration.x
                let y1 = data.acceleration.y
                let z1 = data.acceleration.z
                
            }
            
            if let dataG = self.manager.gyroData{
                
                let x2 = dataG.rotationRate.x
                let y2 = dataG.rotationRate.y
                let z2 = dataG.rotationRate.z
                
                
                if(y2 > 3){
                    if(playing){
                        print("Entre")
                        playing = false
                        self.playSound()
                    }
                    else {
                        print("Entre")
                        playing = true
                        self.playSound()
                    }
                    
                }
                
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func toBase64(word: String) -> String{
        let base64Encoded = word.data(using: String.Encoding.utf8)!.base64EncodedString()
        
        return base64Encoded
    }

    func fromBase64(word: String) -> String{
        let base64Encoded = Data(base64Encoded: word)!
        let decodedString = String(data: base64Encoded, encoding: .utf8)!
        
        return decodedString
    }

    @IBAction func loginCheck(_ sender: Any) {
        username = txUser.text!
        password = txPassword.text!
        llamadaAlAPI()

        /*print(usuario)
        print(pass)
        */
        //usuario != nil && pass != nil && password == pass && username == usuario
        if(usuario != nil && pass != nil && password == pass && username == usuario){
            //Segue loginSegue
            singleton.set(username, forKey: "usuario")
            
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{
            //ERROR
            print("ERROR")
            let alerta = UIAlertController(title: "Error", message: "Usuario o Contraseña incorrectos", preferredStyle: .alert)
            
            let botonCancel = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alerta.addAction(botonCancel)
            
            present(alerta, animated: true)
            //print("ELSE")
        }
    }
    
    /*
     Esta funcion llama al API, esta función se repite varias veces.
     Funciona cambiando el link y los datos que queremos obtener.
     Traemos datos de la base de datos.
     Luis Delgado
     */
    
    func llamadaAlAPI(){
        let usuarioBuscar = txUser.text!
        print(usuarioBuscar)
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/crud/read?username=\(usuarioBuscar)") else{
                return
            }
    
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([Usuario].self, from: data)
                    if (!tasks.isEmpty){
                        tasks.forEach{ i in
                            self.usuario = i.username
                            self.pass = self.fromBase64(word: i.password)
                            self.singleton.set(i.iduser, forKey: "iduser")
                            self.singleton.set(i.foto, forKey: "foto")
                            self.singleton.set(i.name, forKey: "nombre")
                        }
                    }else{
                        print("error")
                    }
                }catch{
                    print(error)
                }
            }
            grupo.leave()
        }
        task.resume()
        grupo.wait()
    }
}

