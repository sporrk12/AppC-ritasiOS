//
//  DemoViewController.swift
//  Caritas
//
//  Created by Alumno on 20/09/22.
//

import UIKit
import CommonCrypto
import Foundation

class DemoViewController: UIViewController {

    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfUsuario: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfContrasena: UITextField!
    
    @IBOutlet weak var txEmailWarning: UILabel!
    
    @IBOutlet weak var txPasswordWarning: UILabel!
    
    @IBOutlet weak var txPassConfirm: UITextField!
    
    @IBOutlet weak var txContraCoin: UILabel!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var avatarID = 0
    
    var encryptedPassword: String!
    
    var success = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txEmailWarning.isHidden = true
        txPasswordWarning.isHidden = true
        txContraCoin.isHidden = true
        
        // Dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
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
    
    @IBAction func ListoBoton(_ sender: Any) {
        var emailValid = false
        var passValid = false
        var samePass = false
        
        emailValid = isValidEmailAddress(emailAddressString: tfEmail.text!)
        passValid = isValidPassword(passwordString: tfContrasena.text!)
        samePass = passConfirmPassSame(pass: tfContrasena.text!, cpass: txPassConfirm.text!)
        
        txEmailWarning.isHidden = emailValid
        txPasswordWarning.isHidden = passValid
        txContraCoin.isHidden = samePass
        
        
        if emailValid && passValid && samePass{
            makePostRequest()
        }
        else {
            let alerta = UIAlertController(title: "Error", message: "Algún Campo Invalido", preferredStyle: .alert)
            
            let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(botonCancel)
            
            self.present(alerta, animated: true)
        }
//        makePostRequest()
        print(success)
        if success{
            //ALERTA USUARIO POSTEADO
            let alerta = UIAlertController(title: "Enhorabuena", message: "Te has registrado", preferredStyle: .alert)
            
            let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(botonCancel)
            
            self.present(alerta, animated: true)
        }
        else {
//            alerta
            let alerta = UIAlertController(title: "Error", message: "Usuario o correo en uso", preferredStyle: .alert)
            
            let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(botonCancel)
            
            self.present(alerta, animated: true)
//            alerta
        }
    }
    
    func makePostRequest(){
        var activities = false
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/crud/create") else{
                return
            }
        print("Making API call...")
        var request = URLRequest(url:url)
        
        encryptedPassword = toBase64(word: tfContrasena.text!)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "password": encryptedPassword,
            "username": tfUsuario.text,
            "name": tfNombre.text,
            "email": tfEmail.text,
            "tipo": "u",
            "foto": avatarID
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(UsuarioPost.self, from: data)
                print("SUCCESS: \(response)")
                activities = true
            }
            catch {
                activities = false
                print (error)
            }
        }
        task.resume()
        self.success = activities
    }
    func passConfirmPassSame(pass: String, cpass: String) -> Bool{
        if cpass == pass{
            return true
        } else {
            return false
        }
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
            
            var returnValue = true
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            
            do {
                let regex = try NSRegularExpression(pattern: emailRegEx)
                let nsString = emailAddressString as NSString
                let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
                
                if results.count == 0
                {
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            
            return  returnValue
        }
    func isValidPassword(passwordString: String) -> Bool {
            
            var returnValue = true
            let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&])[A-Za-z[0-9]@$!%*?&]{8,}$"
            
            do {
                let regex = try NSRegularExpression(pattern: passwordRegEx)
                let nsString = passwordString as NSString
                let results = regex.matches(in: passwordString, range: NSRange(location: 0, length: nsString.length))
                
                if results.count == 0
                {
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            
            return  returnValue
        }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func updateAvatar (){
        imgAvatar.image = UIImage(named: "avatar\(avatarID)")
    }
    

}
