//
//  ViewControllerAprobacionHoras.swift
//  Caritas
//
//  Created by Alumno on 17/10/22.
//

import UIKit

class ViewControllerAprobacionHoras: UIViewController {
    
    var hora = horasAprob(nombreEvento: "", nombreUsuario: "", fecha: "", horas: 0, foto: 0, eventoid: 0, userid: 0)
    
    @IBOutlet weak var tlNombre: UILabel!
    
    @IBOutlet weak var tlNombreEvento: UILabel!
    
    @IBOutlet weak var tlFecha: UILabel!
    
    @IBOutlet weak var tlCantidadDeHoras: UILabel!
    
    @IBOutlet weak var imgImagenUsuario: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tlNombre.text = hora.nombreUsuario
        tlNombreEvento.text = hora.nombreEvento
        tlFecha.text = "Fecha: \(hora.horas)"
        tlCantidadDeHoras.text = "Otorgar \(hora.horas) horas"
        imgImagenUsuario.image = UIImage(named: String(hora.foto))
        imgImagenUsuario.layer.cornerRadius = imgImagenUsuario.frame.height / 7
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func aprobarHoras(_ sender: Any) {
        makePostRequest(status: 1)
        
        let alerta = UIAlertController(title: "Enhorabuena", message: "¡Se aprobaron las horas!", preferredStyle: .alert)
        
        let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(botonCancel)
        
        present(alerta, animated: true)
    }
    
    @IBAction func negarHoras(_ sender: Any) {
        makePostRequest(status: -1)
        
        let alerta = UIAlertController(title: "Rechazado", message: "¡Se denegaron las horas!", preferredStyle: .alert)
        
        let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(botonCancel)
        
        present(alerta, animated: true)
    }
    
    func makePostRequest(status:Int){
        var activities = false
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/update/horas") else{
                return
            }
        print("Making API call...")
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "status": status,
            "eventoid": hora.eventoid,
            "userid": hora.userid
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(updatePost.self, from: data)
                print("SUCCESS: \(response)")
                activities = true
            }
            catch {
                activities = false
                print (error)
            }
        }
        task.resume()
        //self.success = activities
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
