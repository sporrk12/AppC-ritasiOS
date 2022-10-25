//
//  ViewController_postulacion.swift
//  Caritas
//
//  Created by Alumno on 20/09/22.
//

import UIKit

class ViewController_postulacion: UIViewController {
    
    
    @IBOutlet weak var lbDescripcion: UILabel!
    
    @IBOutlet weak var imgEvento: UIImageView!
    
    @IBOutlet weak var lbFecha: UILabel!
    
    @IBOutlet weak var lbDetalle: UITextView!
    
    @IBOutlet weak var btnPostularme: UIButton!
    
    let singleton = UserDefaults.standard
    
    

    var evento = Evento(idevento: 0, name: "", descripcion: "", fechainicio: "", fechafinal: "", dias: "", horario: "", foto: 0, status: 0, eventohoras: 1)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        print(evento.status)
        if(evento.status == 0){
            btnPostularme.isEnabled = true
            btnPostularme.isHidden = false
        }
        else {
            btnPostularme.isHidden = true
            btnPostularme.isEnabled = false
            //btnPostularme.setTitle("-----", for: .normal)
//            btnPostularme.backgroundColor = UIColor.systemGray
        }
        
        imgEvento.layer.cornerRadius = imgEvento.frame.height / 7
        // Do any additional setup after loading the view.
        
        imgEvento.image = UIImage(named: String(evento.foto))
        
        lbDescripcion.text = evento.name
        lbDetalle.text = evento.descripcion
        
        var texto = evento.fechainicio
        
        var stInd = texto.index(texto.startIndex, offsetBy: 5)
        var endInd = texto.index(texto.endIndex, offsetBy: -13)
        var range = stInd..<endInd
        
        let tx = texto[range]
        
        texto = evento.fechafinal
        
        stInd = texto.index(texto.startIndex, offsetBy: 5)
        endInd = texto.index(texto.endIndex, offsetBy: -13)
        range = stInd..<endInd
    
        let tx2 = texto[range]
        
        lbFecha.text = "De: " + tx + " a " + tx2
    }
    
    @IBAction func botonPostularme(_ sender: Any) {
        
        makePostRequest()
        
        let alerta = UIAlertController(title: "Enhorabuena", message: "¡Te acabas de postular!", preferredStyle: .alert)
        
        let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(botonCancel)
        
        present(alerta, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "volun"){
            let vistaDestino = segue.destination as! ViewController_personas
            
            vistaDestino.eventid = evento.idevento
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func makePostRequest(){
        let iduser = self.singleton.integer(forKey: "iduser")
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/post/postulacion") else{
                return
            }
        print("Making API call...")
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "userid": singleton.integer(forKey: "iduser"),
            "eventid": evento.idevento,//evento.status,
            "pstatus": 1
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(postulacion.self, from: data)
                print("SUCCESS: \(response)")
            }
            catch {
                //self.success = 0
                print (error)
            }
        }
        task.resume()
    }

}
