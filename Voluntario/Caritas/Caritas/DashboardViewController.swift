//
//  DashboardViewController.swift
//  Caritas
//
//  Created by Alumno on 19/09/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var proyectsView: UITableView!
    
    var proyects = [Evento]()
    var postulaciones = [postulacion]()
    var refreshControl = UIRefreshControl()
    let singleton = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //code for refresh
        self.proyectsView.delegate = self
        self.proyectsView.dataSource = self
        
//        proyectsView.allowsMultipleSelection = true //maybe remove
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        proyectsView.addSubview(refreshControl)
        //end of code for refresh
        
        llamadaAlAPI()
        llamadaAlAPI2()
        makePostulacionGood()
       
        
        proyectsView.delegate = self
        proyectsView.dataSource = self
        //beautifying tableView
        proyectsView.separatorStyle = .none
        proyectsView.showsVerticalScrollIndicator = false
        
        //declaring events
        /*let evento1 = Evento(idevento: 1, name: "Banco de Sangre", descripcion: "Ayuda al control de los donadores de sangre", fechainicio: "23 Agosto", fechafinal: "20 diciembre", dias: "Lunes y Viernes", horario: "8:00 am", foto: 1, status: 0, eventohoras: 1.0)
        let evento2 = Evento(idevento: 1, name: "Banco de Alimentos", descripcion: "n/a", fechainicio: "n/a", fechafinal: "n/a", dias: "n/a", horario: "n/a", foto: 1, status: 1, eventohoras: 1)
        let evento3 = Evento(idevento: 1, name: "Banco de Alimentos", descripcion: "n/a", fechainicio: "n/a", fechafinal: "n/a", dias: "n/a", horario: "n/a", foto: 0, status: 2, eventohoras: 1)
        let evento4 = Evento(idevento: 1, name: "Banco de Alimentos", descripcion: "n/a", fechainicio: "n/a", fechafinal: "n/a", dias: "n/a", horario: "n/a", foto: 2, status: 3, eventohoras: 1)
        
        proyects.append(evento1)
        proyects.append(evento2)
        proyects.append(evento3)
        proyects.append(evento4)*/
        //end of delcaration of events
    }
    
    func makePostulacionGood(){
        for p in postulaciones{
            for e in 0...(proyects.count-1) {
                if(p.eventid == proyects[e].idevento){
                    proyects[e].status = p.pstatus
                }
            }
        }
        
    }
    //realiza el refrescar de un table view, borra los elementos existentes,
    //llama al api, formateo los datos y finalmente los recarga en el api
    //params: refresh control
    //returns: void
    //Autor: José Carlos de la Torre Hernández
//    refresh function
    @objc func refresh(send: UIRefreshControl){
        DispatchQueue.main.async {
//            removes existing stuff
            self.proyects.removeAll()
            self.postulaciones.removeAll()
//            calls api
            self.llamadaAlAPI()
            self.llamadaAlAPI2()
            self.makePostulacionGood()
//            reload data
            self.proyectsView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func llamadaAlAPI(){
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/evento") else{
                return
            }
    
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([Evento].self, from: data)
                    if (!tasks.isEmpty){
                        tasks.forEach{ i in

                            let evento = Evento(idevento: i.idevento, name: i.name, descripcion: i.descripcion, fechainicio: i.fechainicio, fechafinal: i.fechafinal, dias: i.dias, horario: i.horario, foto: i.foto, status: 0, eventohoras: i.eventohoras)
                            self.proyects.append(evento)
                            /*self.proyectos = i.//nombre de la variable en el archivo Model (tambien cambiarlo ahi)
                            self.dias = i.//nombre de la variable en el archivo Model (tambien cambiarlo ahi)
                            self.postulado = i.//nombre de la variable en el archivo Model (tambien cambiarlo ahi)*/
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
    
    func llamadaAlAPI2(){
        let userid = singleton.integer(forKey: "iduser")
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/postulaciones?userid=\(userid)") else{// user id esta hardcoded, cambiar
                return
            }
    
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([postulacion].self, from: data)
                    if (!tasks.isEmpty){
                        tasks.forEach{ i in
                            let postulacion = postulacion(eventid: i.eventid, idpostulaciones: i.idpostulaciones, pstatus: i.pstatus, userid: i.userid)
                            self.postulaciones.append(postulacion)
                            /*self.proyectos = i.//nombre de la variable en el archivo Model (tambien cambiarlo ahi)
                            self.dias = i.//nombre de la variable en el archivo Model (tambien cambiarlo ahi)
                            self.postulado = i.//nombre de la variable en el archivo Model (tambien cambiarlo ahi)*/
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detalle"){
            let vistaDestino = segue.destination as! ViewController_postulacion
            let renglonSeleccionado = proyectsView.indexPathForSelectedRow!
            
            vistaDestino.evento = proyects[renglonSeleccionado.row]
        }
    }
    
}


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 234
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proyects.count
    }
    //llena el tableview de infromacion, en la primera etapa asigna los valores avariables
    //define el color del statust
    //asigna las variables a los outlets
    //le da un poco formato
    //regresa la celda
    //autor: José Carlos de la Torre Hernández
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = proyectsView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        
        let title = proyects[indexPath.row].name
        let picture = proyects[indexPath.row].foto
        let day = proyects[indexPath.row].dias
        let stat = proyects[indexPath.row].descripcion
        let statColor = proyects[indexPath.row].status
        
        cell.bg_Img.image = UIImage(named: String(picture))
        
        //cell.statLabel.text = stat
        
        //defining Status
        if (statColor == 0){
            cell.statLabel.backgroundColor = UIColor.systemRed
            cell.statLabel.text = "No Postulado"
        }
        else if(statColor == 1){
            cell.statLabel.backgroundColor = UIColor.systemCyan
            cell.statLabel.text = "En Proceso"
        }
        else if(statColor == 2){
            cell.statLabel.backgroundColor = UIColor.systemGreen
            cell.statLabel.text = "Voluntario Activo"
        }
        else if(statColor == 3){
            cell.statLabel.backgroundColor = UIColor.systemGray
            cell.statLabel.text = "Poyecto Inactivo"
        }
        //end of status definition
        
        cell.titleLabel.text = title
        cell.nameLabel.text = day //this si the field called days on the viewcontroller
        //beautifying cell
        cell.bg_Img.layer.cornerRadius = cell.bg_Img.frame.height / 7
        cell.statLabel.layer.cornerRadius = 13
        cell.statLabel.layer.masksToBounds = true
        
        return cell
    }
}
