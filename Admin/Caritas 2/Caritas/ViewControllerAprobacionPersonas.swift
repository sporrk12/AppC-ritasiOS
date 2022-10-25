//
//  ViewControllerAprobacionPersonas.swift
//  Caritas
//
//  Created by Emmanuel  Granados on 18/10/22.
//

import UIKit

class ViewControllerAprobacionPersonas: UIViewController {

    @IBOutlet weak var tlusuarioPersona: UILabel!
    @IBOutlet weak var tlNombrePersona: UILabel!
    @IBOutlet weak var fotoPersona: UIImageView!
    
    var eventid = 0
    
    var persona = personasAprob(nombrePersona: "", usuarioPersona: "", fotoPersona: 1, idusuario: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tlNombrePersona.text = persona.nombrePersona
        tlusuarioPersona.text = persona.usuarioPersona
        fotoPersona.image = UIImage(named: "avatar\(persona.fotoPersona)")

        // Do any additional setup after loading the view.
    }
    
    func makePostRequest(status:Int){
        var activities = false
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/update/postulacion") else{
                return
            }
        print("Making API call...")
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "pstatus": status,
            "eventid": eventid,
            "userid": persona.idusuario,
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


    @IBAction func aprobarUsuario(_ sender: Any) {
        makePostRequest(status: 2)
        let alerta = UIAlertController(title: "Enhorabuena", message: "¡Voluntario Aceptado!", preferredStyle: .alert)
        
        let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(botonCancel)
        
        present(alerta, animated: true)
    }
    
    @IBAction func denegarUsuario(_ sender: Any) {
        makePostRequest(status: 3)
        let alerta = UIAlertController(title: "Rechazado", message: "¡Voluntario rechazado para este proyecto!", preferredStyle: .alert)
        
        let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(botonCancel)
        
        present(alerta, animated: true)
    }
    // MARK: - Navigation
     
    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
