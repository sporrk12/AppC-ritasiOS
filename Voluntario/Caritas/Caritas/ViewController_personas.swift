//
//  ViewController_personas.swift
//  Caritas
//
//  Created by Emmanuel  Granados on 17/10/22.
//

import UIKit

class ViewController_personas: UIViewController {
    
    @IBOutlet weak var PersonasView: UITableView!
    
    var cards = [personasAprob]()
    
    var eventid = 0
    
    let singleton = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(eventid)
        
        llamadaAlAPI()
        
        PersonasView.delegate = self
        PersonasView.dataSource = self
        /*
        let card1 = personasAprob(nombrePersona: "Jessica", usuarioPersona: "jess1", fotoPersona: "Maria")
        let card2 = personasAprob(nombrePersona: "Martha", usuarioPersona: "martis", fotoPersona: "Martha")
        let card3 = personasAprob(nombrePersona: "Diego", usuarioPersona: "diego123", fotoPersona: "Diego")
        
        cards.append(card1)
        cards.append(card2)
        cards.append(card3)*/
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "aprobacionVoluntarios"){
            let vistaDestino = segue.destination as! ViewControllerAprobacionPersonas
            let renglonSeleccionado = PersonasView.indexPathForSelectedRow!
            vistaDestino.persona = cards[renglonSeleccionado.row]
            
            vistaDestino.eventid = eventid
            
        }
        
    }
}


extension ViewController_personas : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell3 = PersonasView.dequeueReusableCell(withIdentifier: "customCell3") as! CustomCell3
        
       //declaration of cell elements
        let namePersona = cards[indexPath.row].nombrePersona
        let userPersona = cards[indexPath.row].usuarioPersona
        let picturePersona = cards[indexPath.row].fotoPersona
        
        //assigning cell elements to actual cell
        
        
        cell3.nombrePersona.text = namePersona
        cell3.usuarioPersona.text = userPersona
        cell3.fotoPersona.image = UIImage(named: "avatar\(picturePersona)")
        
        //beautifying cell
    
        cell3.viewBackground.layer.cornerRadius = cell3.layer.frame.height/12
        
        
        return cell3
         
        
    }
    
    
    func llamadaAlAPI(){
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/get/postulaciones?eventid=\(eventid)") else{
                return
            }
        
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([personasAprob].self, from: data)
                    if (!tasks.isEmpty){
                        tasks.forEach{ i in
                            self.cards.append(i)
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
