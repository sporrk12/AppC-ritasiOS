//
//  Model.swift
//  Caritas
//
//  Created by Alumno on 20/09/22.
//

import Foundation

struct Usuario:Codable{
    let iduser: Int
    let password: String
    let username: String
    let name: String
    let email: String
    let tipo: String
    let foto: Int
}

struct UsuarioPost:Codable{
    //let idUser: Int
    let password: String
    let username: String
    let name: String
    let email: String
    let tipo: String
    let foto: Int
}

struct Evento:Codable{
    let idevento: Int
    let name: String
    let descripcion: String
    let fechainicio: String
    let fechafinal: String
    let dias: String
    let horario: String
    let foto: Int //THIS MIGHT NEED TO CHANGE
    var status: Int
    let eventohoras: Float//THIS MIGHT NEED TO CHANGE
}

struct EventoPost:Codable{
    //let idevento: Int
    let name: String
    let descripcion: String
    let fechainicio: String
    let fechafinal: String
    let dias: String
    let horario: String
    let foto: Int //THIS MIGHT NEED TO CHANGE
    var status: String
    let eventohoras: Float//THIS MIGHT NEED TO CHANGE
}


struct postulacion:Codable{
    let eventid: Int
    let idpostulaciones: Int
    let pstatus: Int
    let userid: Int
}

struct horasAprob:Codable{
    let nombreEvento: String
    let nombreUsuario: String
    let fecha: String
    let horas: Float
    let foto: Int
    let eventoid: Int
    let userid: Int
}

struct personasAprob:Codable{
    let nombrePersona: String
    let usuarioPersona: String
    let fotoPersona: Int
    let idusuario: Int
}

struct Horas:Codable{
    let eventoid: Int
    let userid: Int
    let fecha: String
    let status: Int
}

struct updatePost:Codable {
    let pstatus:Int
    let eventid:Int
    let userId:Int
}

struct AprobacionPost:Codable{
    let idpostulaciones: Int
    let userid: Int
    let eventid: Int
    let pstatus: Int
    let idevento: Int
    let name: String
    let descripcion: String
    let fechainicio: String
    let fechafinal: String
    let dias: String
    let horario: String
    let foto: Int
    let status: Int
    let eventohoras: Float
}
struct eventosHoras:Codable{
    let eventoid: Int
    let userid: Int
    let fecha: String
    let status: Int
    let name: String
    var horas: Float
}
