//
//  ViewControllerAgregarEventos.swift
//  Caritas
//
//  Created by Alumno on 05/10/22.
//

import UIKit

class ViewControllerAgregarEventos: UIViewController {

    let weekdays = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"]
    
    var pickerView = UIPickerView()
    
    @IBOutlet weak var tfNombreEvento: UITextField!
    
    @IBOutlet weak var tfDiasEvento: UITextField!
    
    
    @IBOutlet weak var tfFechaInicial: UITextField!
    
    @IBOutlet weak var tfFechaFinal: UITextField!

    @IBOutlet weak var tfDescripcion: UITextField!
    
    @IBOutlet weak var tfHorario: UITextField!
    
    @IBOutlet weak var tfHoraFin: UITextField!
    
    var foto = 0
    
    let datePickerIni = UIDatePicker()
    let datePickerFin = UIDatePicker()
    let timePickerIni = UIDatePicker()
    let timePickerFin = UIDatePicker()
    
    
    @IBAction func sgFoto(_ sender: UISegmentedControl) {
        foto = sender.selectedSegmentIndex + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        tfDiasEvento.inputView = pickerView
        
        createDatePickerIni()
        createDatePickerFin()
        createTimePickerIni()
        createTimePickerFin()
        
        
        // Dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Post(_ sender: Any) {
        
        makePostRequest()
        
        let alerta = UIAlertController(title: "Enhorabuena", message: "Proyecto registrado", preferredStyle: .alert)
        
        let botonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(botonCancel)
        
        self.present(alerta, animated: true)
        
        //ESTO ES LO QUE JALA EL VIEW CONTROLLER Y PERMITE LLAMAR LA FUNCION UPDATE, NO tuVE TIEMPO DE DEBUGGEAR
        
        //let parentView = presentingViewController as! ViewController
        //parentView.llamadaAlAPI()
    }
    func makePostRequest(){
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/eventos/create") else{
                return
            }
        print("Making API call...")
        var request = URLRequest(url:url)

        
        var horas1:Float!
        var minutos1:Float!
        var horas2:Float!
        var minutos2:Float!
        
        var totalH:Float!
        
        var texto = tfHorario.text!
        
        var stInd = texto.startIndex
        var endInd = texto.index(texto.endIndex, offsetBy: -3)
        var range = stInd..<endInd
        
        var tx = texto[range]
        
        print(tx)
        
        let arrMH1 = tx.split(separator: ":")
        horas1 = Float(String(arrMH1[0]))
        minutos1 = Float(String(arrMH1[1]))
        minutos1 = minutos1/60
        
        texto = tfHoraFin.text!
        
        stInd = texto.startIndex
        endInd = texto.index(texto.endIndex, offsetBy: -3)
        range = stInd..<endInd
        
        tx = texto[range]
        
        let arrMH2 = tx.split(separator: ":")
        horas2 = Float(String(arrMH2[0]))
        minutos2 = Float(String(arrMH2[1]))
        minutos2 = minutos2/60
        
        totalH = ((horas2 + minutos2) - (horas1 + minutos1))
        
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "descripcion": tfDescripcion.text,
            "dias": tfDiasEvento.text,
            "fechainicio": tfFechaInicial.text,
            "fechafinal": tfFechaFinal.text,
            "foto": foto+1,
            "horario": tfHorario.text! + "-" + tfHoraFin.text!,
            "name": tfNombreEvento.text,
            "eventohoras": totalH
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(EventoPost.self, from: data)
                print("SUCCESS: \(response)")
            }
            catch {
                print (error)
            }
        }
        task.resume()
    }
    
    // Se crea el DatePicker para que el usuario pueda ecoger la fecha inicial del evento con una ruleta y los datos se guardan en el TextField
    //Autor: Emmanuel Granados
    
    func createDatePickerIni () {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        datePickerIni.preferredDatePickerStyle = .wheels
        
        let doneBtnIni = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedIni))
        toolbar.setItems([doneBtnIni], animated: true)
        
        
        tfFechaInicial.inputAccessoryView = toolbar
        
        tfFechaInicial.inputView = datePickerIni
        
        
        datePickerIni.datePickerMode = .date
        
    }
    
    // Se crea el DatePicker para que el usuario pueda ecoger la fecha final del evento con una ruleta y los datos se guardan en el TextField
    //Autor: Emmanuel Granados
    
    func createDatePickerFin () {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        datePickerFin.preferredDatePickerStyle = .wheels
        
        let doneBtnFin = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedFin))
        toolbar.setItems([doneBtnFin], animated: true)
        
        
        tfFechaFinal.inputAccessoryView = toolbar
        
        tfFechaFinal.inputView = datePickerFin
        
        
        datePickerFin.datePickerMode = .date
        
    }
    
    // Se crea el DatePicker para que el usuario pueda ecoger la hora inicial del evento con una ruleta y los datos se guardan en el TextField
    //Autor:Alberto Guajardo
    
    func createTimePickerIni () {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        timePickerIni.preferredDatePickerStyle = .wheels
        
        let doneBtnTimeIni = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedTimeIni))
        toolbar.setItems([doneBtnTimeIni], animated: true)
        
        
        tfHorario.inputAccessoryView = toolbar
        
        tfHorario.inputView = timePickerIni
        
        
        timePickerIni.datePickerMode = .time
        
    }
    
    // Se crea el DatePicker para que el usuario pueda ecoger la hora final del evento con una ruleta y los datos se guardan en el TextField
    //Autor:Alberto Guajardo
    
    func createTimePickerFin () {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        timePickerFin.preferredDatePickerStyle = .wheels
        
        let donePressedTimeFin = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedTimeFin))
        toolbar.setItems([donePressedTimeFin], animated: true)
        
        
        tfHoraFin.inputAccessoryView = toolbar
        
        tfHoraFin.inputView = timePickerFin
        
        
        timePickerFin.datePickerMode = .time
        
    }
    
    @objc func donePressedIni() {
        
        let formatterIn = DateFormatter()
        formatterIn.dateFormat = "yyyy/MM/dd"
        
        tfFechaInicial.text = formatterIn.string(from: datePickerIni.date)
        self.view.endEditing(true)
        
    }
    
    @objc func donePressedFin() {
        let formatterFin = DateFormatter()
        formatterFin.dateFormat = "yyyy/MM/dd"
        
        
        tfFechaFinal.text = formatterFin.string(from: datePickerFin.date)
        self.view.endEditing(true)
        
    }
    
    @objc func donePressedTimeIni() {
        let formatterTimeIni = DateFormatter()
        formatterTimeIni.dateStyle = .none
        formatterTimeIni.timeStyle = .short
        
        
        tfHorario.text = formatterTimeIni.string(from: timePickerIni.date)
        self.view.endEditing(true)
        
    }
    
    @objc func donePressedTimeFin() {
        let formatterTimeFin = DateFormatter()
        formatterTimeFin.dateStyle = .none
        formatterTimeFin.timeStyle = .short
        
        
        tfHoraFin.text = formatterTimeFin.string(from: timePickerFin.date)
        self.view.endEditing(true)
        
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

extension ViewControllerAgregarEventos: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weekdays.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weekdays[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfDiasEvento.text = weekdays[row]
        tfDiasEvento.resignFirstResponder()
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

