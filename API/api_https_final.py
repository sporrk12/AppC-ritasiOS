from flask import Flask, jsonify, make_response, request, send_file
import json
import sys
import mysql.connector
import os
import logging

# logging basic definition
LOG_FILE = '/home/user01/var/log/api/api_https.log'
logging.basicConfig(filename=LOG_FILE, level=logging.DEBUG,
    format='%(asctime)s.%(msecs)03d %(levelname)s: %(message)s',
    datefmt='%d-%b-%y %H:%M:%S')

# Connect to MySQL dB from start
mysql_params = {}
mysql_params['DB_HOST'] = '100.80.80.6'
mysql_params['DB_NAME'] = 'caritas' #'alumno02'
mysql_params['DB_USER'] = 'root' #os.environ['MYSQL_USER']
mysql_params['DB_PASSWORD'] = 'user1234' #os.environ['MYSQL_PSWD']

#Locations of API certificates
API_CERT = './cer/equipo03.tc2007b.tec.mx.cer'
API_KEY = './cer/equipo03.tc2007b.tec.mx.key'
CA = './cer/ca.tc2007b.tec.mx.cer'

#Connect to SQL Database
try:
    cnx = mysql.connector.connect(
        user=mysql_params['DB_USER'],
        password=mysql_params['DB_PASSWORD'],
        host=mysql_params['DB_HOST'],
        database=mysql_params['DB_NAME'], 
        auth_plugin='mysql_native_password'
        )
except Exception as e:
    print("Cannot connect to MySQL server!: {}".format(e))
    sys.exit()

def module_path():
    import sys
    import os
    if (hasattr(sys, "frozen")):
        return os.path.dirname(sys.executable)
    if os.path.dirname(__file__) == "":
        return "."
    return os.path.dirname(__file__)

def mysql_connect():
    global mysql_params
    cnx = mysql.connector.connect(
        user=mysql_params['DB_USER'],
        password=mysql_params['DB_PASSWORD'],
        host=mysql_params['DB_HOST'],
        database=mysql_params['DB_NAME'], 
        auth_plugin='mysql_native_password'
        )
    return cnx



#mysql_read_where
#Parametros de entrada: 
#   table_name (nombre de la tabla que se va a leer)
#   d_where (lista json de todos los parametros que se les va a dar)
# Funcion que se conecta a la base de datos para leer informacion 
# modificada de la version del profe para incluir statements de LEFT JOIN
# Autor: Emilio Perez
def mysql_read_where(table_name, d_where):
    global cnx
    try:
        try:
            cnx.ping(reconnect=False, attempts=1, delay=3)
        except:
            cnx = mysql_connect()
        cursor = cnx.cursor(dictionary=True)
        read = ''
        if d_where is None:
            if(table_name == 'eventos'):
                read = 'SELECT * FROM %s ORDER BY fechainicio DESC' % table_name
            elif(table_name == 'tarjetas'):
                read = 'SELECT eventos.name AS "nombreEvento", users.name AS "nombreUsuario", horas.fecha, eventos.eventohoras AS "horas", horas.userid, horas.eventoid, users.foto FROM horas LEFT JOIN users ON horas.userid = users.iduser LEFT JOIN eventos ON horas.eventoid = eventos.idevento WHERE horas.status = 0'
            else: 
                read = 'SELECT * FROM %s' % table_name
        else:
            if(table_name == 'postulacionesA'):
                read = 'SELECT * FROM postulaciones LEFT JOIN eventos ON eventid = idevento WHERE '
            elif(table_name == 'postulacionesB'):
                read = 'SELECT postulaciones.userid AS "idusuario", users.foto AS "fotoPersona", users.username AS "usuarioPersona", users.name AS "nombrePersona"  FROM postulaciones LEFT JOIN users ON users.iduser = postulaciones.userid WHERE '
            elif(table_name == 'horas2'):
                read = 'SELECT eventoid, userid, fecha, horas.status, eventos.name, eventos.eventohoras AS "horas" FROM horas LEFT JOIN eventos ON eventos.idevento = horas.eventoid WHERE '
            else : 
                read = 'SELECT * FROM %s WHERE ' % table_name
            #if(table_name == 'postulaciones'):
                #read = 'SELECT * FROM postulaciones RIGHT JOIN eventos ON eventos.idevento=postulaciones.eventid WHERE '
            read += '('
            for k,v in d_where.items():
                if v is not None:
                    if isinstance(v,bool):
                        v = int(v == True)
                        read += '%s = "%s" AND ' % (k,v)
                    elif isinstance(v,str):
                        if '"' in v:
                            read += "%s = '%s' AND " % (k,v)
                        else:
                            read += '%s = "%s" AND ' % (k,v)
                    else:
                        read += '%s = "%s" AND ' % (k,v)
                else:
                    read += '%s is NULL AND ' % (k)
            # Remove last "AND "
            read = read[:-4]
            read += ')'
        #print(read)
        cursor.execute(read)
        a = cursor.fetchall()
        cnx.commit()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("mysql_read_where:%s" % e)

def mysql_insert_row_into(table_name, d):
    global cnxmysql_read
    try:
        try:
            cnx.ping(reconnect=False, attempts=1, delay=3)
        except:
            cnx = mysql_connect()
        cursor = cnx.cursor()
        keys = ""
        values = ""
        data = []
        #print("DATA: ", d)
        for k in d:
            keys += k + ','
            values += "%s,"
            if isinstance(d[k],bool):
                d[k] = int(d[k] == True)
            data.append(d[k])
        keys = keys[:-1]
        values = values[:-1]
        insert = 'INSERT INTO %s (%s) VALUES (%s)'  % (table_name, keys, values)
        #print(insert)
        #print(data)
        a = cursor.execute(insert,data)
        id_new = cursor.lastrowid
        cnx.commit()
        cursor.close()
        return d
    except Exception as e:
        raise TypeError("mysql_insert_row_into:%s" % e)

def mysql_update_where(table_name, d_field, d_where):
    global cnx
    try:
        try:
            cnx.ping(reconnect=False, attempts=1, delay=3)
        except:
            cnx = mysql_connect()
        cursor = cnx.cursor()
        update = 'UPDATE `%s` SET ' % table_name
        for k,v in d_field.items():
            if v is None:
                update +='`%s` = NULL, ' % (k)
            elif isinstance(v,bool):
                update +='`%s` = %s, ' % (k,int(v == True))
            elif isinstance(v,str):
                if '"' in v:
                    update +="`%s` = '%s', " % (k,v)
                else:
                    update +='`%s` = "%s", ' % (k,v)
            else:
                update +='`%s` = %s, ' % (k,v)
        # Remove last ", "
        update = update[:-2]
        update += ' WHERE ( '
        for k,v in d_where.items():
            if v is not None:
                if isinstance(v,bool):
                    v = int(v == True)
                elif isinstance(v,str):
                    if '"' in v:
                        update += "%s = '%s' AND " % (k,v)
                    else:
                        update += '%s = "%s" AND ' % (k,v)
                else:
                    update += '%s = %s AND ' % (k,v)
            else:
                update += '%s is NULL AND ' % (k)
        # Remove last "AND "
        update = update[:-4]
        update += ")"
        #print(update)
        a = cursor.execute(update)
        #print(update)
        cnx.commit()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("mysql_update_where:%s" % e)


def mysql_delete_where(table_name, d_where):
    global cnx
    try:
        try:
            cnx.ping(reconnect=False, attempts=1, delay=3)
        except:
            cnx = mysql_connect()
        cursor = cnx.cursor()
        delete = 'DELETE FROM %s ' % table_name
        delete += ' WHERE ( '
        for k,v in d_where.items():
            if v is not None:
                if isinstance(v,bool):
                    v = int(v == True)
                elif isinstance(v,str):
                    if '"' in v:
                        delete += "%s = '%s' AND " % (k,v)
                    else:
                        delete += '%s = "%s" AND ' % (k,v)
                else:
                    delete += '%s = "%s" AND ' % (k,v)
            else:
                delete += '%s is NULL AND ' % (k)
        # Remove last "AND "
        delete = delete[:-4]
        delete += ")"
        #print(delete)
        a = cursor.execute(delete)
        cnx.commit()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("mysql_delete_where:%s" % e)

app = Flask(__name__)

app.config.update(
    SESSION_COOKIE_SECURE=True,
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE='Lax',
)

@app.after_request
def add_header(r):

    import secure

    secure_headers = secure.Secure()

    secure_headers.framework.flask(r)

    r.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains' #Previene MITM attacks

    r.headers['X-Frame-Options'] = 'SAMEORIGIN' #Previene Clickjacking

    r.headers['X-Content-Type-Options'] = 'nosniff' # Previene ataques de XSS

    #r.set_cookie('username', 'flask', secure=True, httponly=True, samesite='Lax')
    #r.headers["Server"] = ""

    r.headers['Content-Security-Policy'] = "default-src 'self';"

    r.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"

    #r.headers["Expires"] = "0"

    r.headers['Cache-Control'] = 'public, max-age=0'

    return r

@app.route("/hello")
def hello():
    return "Shakira rocks!\n"

@app.route("/evento")
def event():
    d_event = mysql_read_where('eventos', None)
    return make_response(jsonify(d_event))

@app.route("/postulaciones")
def postulacion():
    user_id = request.args.get('userid', None)
    #d_postulaciones = mysql_read_where('postulaciones', {'userid': user_id})
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        #d_user = read_user_data('users', username)
        d_postulaciones = mysql_read_where('postulaciones', {'userid':user_id})
        if len(d_postulaciones) == 0:
            logging.info("Postulacion de usuario '{}' not found from '{}'".format(user_id, request.remote_addr))
        elif len(d_postulaciones) >= 1:
            logging.info("Postulaciones de usuario '{}' ok from '{}'".format(user_id, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(user_id, request.remote_addr, len(d_postulaciones)))
        return make_response(jsonify(d_postulaciones))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/get/postulacion")
def get_postulacion():
    user_id = request.args.get('userid', None)
    #d_postulaciones = mysql_read_where('postulaciones', {'userid': user_id})
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        #d_user = read_user_data('users', username)
        d_postulaciones = mysql_read_where('postulacionesA', {'userid':user_id, 'pstatus':2})
        if len(d_postulaciones) == 0:
            logging.info("Postulacion de usuario '{}' not found from '{}'".format(user_id, request.remote_addr))
        elif len(d_postulaciones) >= 1:
            logging.info("Postulaciones de usuario '{}' ok from '{}'".format(user_id, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(user_id, request.remote_addr, len(d_postulaciones)))
        return make_response(jsonify(d_postulaciones))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/get/postulaciones")
def get_postulaciones():
    event_id = request.args.get('eventid', None)
    #d_postulaciones = mysql_read_where('postulaciones', {'userid': user_id})
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        #d_user = read_user_data('users', username)
        d_postulaciones = mysql_read_where('postulacionesB', {'eventid':event_id, 'pstatus':1})
        if len(d_postulaciones) == 0:
            logging.info("Postulacion de usuario '{}' not found from '{}'".format(event_id, request.remote_addr))
        elif len(d_postulaciones) >= 1:
            logging.info("Postulaciones de usuario '{}' ok from '{}'".format(event_id, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(event_id, request.remote_addr, len(d_postulaciones)))
        return make_response(jsonify(d_postulaciones))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/get/tarjetas")
def get_tarjetas():
    user_id = request.args.get('userid', None)
    #d_postulaciones = mysql_read_where('postulaciones', {'userid': user_id})
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        #d_user = read_user_data('users', username)
        d_postulaciones = mysql_read_where('tarjetas', None)
        if len(d_postulaciones) == 0:
            logging.info("Postulacion de usuario '{}' not found from '{}'".format(user_id, request.remote_addr))
        elif len(d_postulaciones) >= 1:
            logging.info("Postulaciones de usuario '{}' ok from '{}'".format(user_id, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(user_id, request.remote_addr, len(d_postulaciones)))
        return make_response(jsonify(d_postulaciones))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/post/postulacion", methods=['POST'])
def postulacion_create():
    d = request.json
    idUser = mysql_insert_row_into('postulaciones', d)
    return make_response(jsonify(idUser))

@app.route("/post/horas", methods=['POST'])
def post_horas():
    d = request.json
    idUser = mysql_insert_row_into('horas', d)
    return make_response(jsonify(idUser))

@app.route("/get/horas")
def get_horas():
    userid = request.args.get('userid', None)
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        d_horas = mysql_read_where('horas', {'userid' : userid})
        if len(d_horas) == 0:
            logging.info("Horas de usuario '{}' not found from '{}'".format(userid, request.remote_addr))
        elif len(d_horas) >= 1:
            logging.info("Horas de usuario '{}' ok from '{}'".format(userid, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(userid, request.remote_addr, len(d_horas)))
        return make_response(jsonify(d_horas))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/crud/create", methods=['POST'])
def crud_create():
    d = request.json
    idUser = mysql_insert_row_into('users', d)
    return make_response(jsonify(idUser))

@app.route("/eventos/create", methods=['POST'])
def evento_create():
    d = request.json
    idUser = mysql_insert_row_into('eventos', d)
    return make_response(jsonify(idUser))

#Ruta de API /crud/read
# El programa lee parametros en la url y regresa informacion del usuario solicitado
# Previene filtros de informacion mediante la escritura de logs y respuestas de tipo 500 - Error Interno
# Autor: Emilio Perez

@app.route("/crud/read", methods=['GET'])
def crud_read():
    username = request.args.get('username', None)
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        d_user = mysql_read_where('users', {'username': username})
        if len(d_user) == 0:
            logging.info("User '{}' not found from '{}'".format(username, request.remote_addr))
        elif len(d_user) == 1:
            logging.info("User '{}' ok from '{}'".format(username, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(username, request.remote_addr, len(d_user)))
        return make_response(jsonify(d_user))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/get/usuarios/all", methods=['GET'])
def crud_read_all():
    username = request.args.get('username', None)
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        d_user = mysql_read_where('users', {"tipo":"o"})
        return make_response(jsonify(d_user))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

@app.route("/update/postulacion", methods=['POST'])
def up_postulacion():
    d = request.json
    d_field = {'pstatus':d['pstatus']}
    d_where = {'eventid':d['eventid'], 'userid':d['userid']}
    mysql_update_where('postulaciones', d_field, d_where)
    return 'ok'

@app.route("/update/horas", methods=['POST'])
def up_horas():
    d = request.json
    d_field = {'status':d['status']}
    d_where = {'eventoid':d['eventoid'], 'userid':d['userid']}
    mysql_update_where('horas', d_field, d_where)
    return 'ok'

@app.route("/get/approvedHours", methods=['GET'])
def get_approved_hours():
    user_id = request.args.get('userid', None)
    inicio = request.args.get('inicio', 0)
    fin = request.args.get('fin', 0)
    logging.debug("{}".format(request.user_agent))
    try:
        delta =int(fin) - int(inicio)
        logging.debug("delta: {}".format(delta))
        d_user = mysql_read_where('horas2', {'userid': user_id, 'horas.status':1})
        if len(d_user) == 0:
            logging.info("User '{}' not found from '{}'".format(user_id, request.remote_addr))
        elif len(d_user) >= 1:
            logging.info("User '{}' ok from '{}'".format(user_id, request.remote_addr))
        else:
            logging.warning("User '{}' ({}) resulted in  {} records".format(user_id, request.remote_addr, len(d_user)))
        return make_response(jsonify(d_user))
    except Exception as e:
        logging.error(str(e))
        return make_response("Error", 500)

if __name__ == '__main__':
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_verify_locations(CA)
    context.load_cert_chain(API_CERT, API_KEY)
    app.run(host='0.0.0.0', port=10202, ssl_context=context, debug=False)
    print ("Running API...")