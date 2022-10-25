//
//  ViewControllerConfirmarAsistencia.swift
//  Caritas
//
//  Created by Alberto  Guajardo on 10/18/22.
//

import UIKit

class ViewControllerConfirmarAsistencia: UIViewController {

    
    @IBOutlet weak var imgImageEvento: UIImageView!
    
    @IBOutlet weak var lbEventoName: UILabel!
    
    @IBOutlet weak var lbFechaParticipacion: UILabel!
    
    let singleton = UserDefaults.standard
    
    var def = AprobacionPost(idpostulaciones: 0, userid: 0, eventid: 0, pstatus: 0, idevento: 0, name: "", descripcion: "", fechainicio: "", fechafinal: "", dias: "", horario: "", foto: 0, status: 0, eventohoras: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        print(dateFormatter.string(from: date))
        lbFechaParticipacion.text = dateFormatter.string(from: date)
        lbEventoName.text = def.name
        imgImageEvento.image = UIImage(named: String(def.foto))
        imgImageEvento.layer.cornerRadius = imgImageEvento.frame.height / 7
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnConfAsistencia(_ sender: Any) {
        if(def.idevento != 0){
            makePostRequest()
            let alerta = UIAlertController(title: "Enhorabuena", message: "¡Se registraron las horas!", preferredStyle: .alert)
            
            let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(botonCancel)
            
            present(alerta, animated: true)
            
        }
    }
    
    func makePostRequest(){
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        print(dateFormatter.string(from: date))
        
        /*let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let horas = "\(hour):\(minutes)"*/
        
        let iduser = self.singleton.integer(forKey: "iduser")

        
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/post/horas") else{
                return
            }
        print("Making API call...")
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "eventoid": self.def.idevento,
            "userid": iduser,
            "fecha": dateFormatter.string(from: date),
            "status": 0
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(Horas.self, from: data)
                print("SUCCESS: \(response)")
            }
            catch {
                print (error)
            }
        }
        task.resume()
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
