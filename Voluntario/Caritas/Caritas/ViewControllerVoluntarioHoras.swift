//
//  ViewControllerVoluntarioHoras.swift
//  Caritas
//
//  Created by Alberto  Guajardo on 10/17/22.
//

import UIKit
import Foundation

class ViewControllerVoluntarioHoras: UIViewController {
    
    let singleton = UserDefaults.standard
        
    var posts = [AprobacionPost]()
    
    var eventos = [String]()
    
    var selRow = 0
    
    @IBOutlet weak var eventosAprob: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    
    @IBAction func Boton(_ sender: UIButton) {
        if(posts[selRow].idevento != 0){
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
            "eventoid": self.posts[selRow].idevento,
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventosAprob.delegate = self
        eventosAprob.dataSource = self
        
        //        refresh
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        eventosAprob.addSubview(refreshControl)
        //        refresh
        
        
        llamadaAlAPI()
        
        let def = AprobacionPost(idpostulaciones: 0, userid: 0, eventid: 0, pstatus: 0, idevento: 0, name: "-", descripcion: "-", fechainicio: "", fechafinal: "-", dias: "-", horario: "-", foto: 0, status: 0, eventohoras: 0)
        
        //posts.append(def)
        //eventos.append("-")
        
       
        
//        tlEventName.inputView = picker
        // Do any additional setup after loading the view.
    }
    
    func llamadaAlAPI(){
        let iduser = self.singleton.integer(forKey: "iduser")
        
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/get/postulacion?userid=\(iduser)") else{
                return
            }
    
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([AprobacionPost].self, from: data)
                    if (!tasks.isEmpty){
                        tasks.forEach{ i in
                            if (i.pstatus == 2){
                                self.posts.append(i)
                                self.eventos.append(i.name)
                            }
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

extension ViewControllerVoluntarioHoras : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell5 = eventosAprob.dequeueReusableCell(withIdentifier: "customCell5") as! CustomCell5
        
       //declaration of cell elements
//        let nameUser = cards[indexPath.row].nombreUsuario
        let picture = String(posts[indexPath.row].foto)
        let eventoName = posts[indexPath.row].name
        
        
        //assigning cell elements to actual cell
        cell5.lbEventoNameActual.text = eventoName
        cell5.imgImageEvento.image = UIImage(named: String(picture))
        //beautifying cell
        cell5.imgImageEvento.layer.cornerRadius = cell5.imgImageEvento.frame.height/2
        cell5.viewBackground.layer.cornerRadius = cell5.layer.frame.height/12
        cell5.viewBackground.layer.masksToBounds = true
        
        return cell5
    }
    //    refresh function
        @objc func refresh(send: UIRefreshControl){
            DispatchQueue.main.async {
    //            removes existing stuff
                self.posts.removeAll()
    //            calls api
                self.llamadaAlAPI()
    //            reload data
                self.eventosAprob.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "registrar"){
            
            let vistaDestino = segue.destination as! ViewControllerConfirmarAsistencia
            
            let renglonSeleccionado = eventosAprob.indexPathForSelectedRow!
            
            vistaDestino.def = posts[renglonSeleccionado.row]
        }
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
