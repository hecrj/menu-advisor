(defmodule abstraccion
  (import MAIN ?ALL)
  (export ?ALL)
)

;(defrule pregunta-nombre "Preguntar el nombre al cliente"
;  (not (Cliente))
;  =>
;  (assert (Cliente (nombre (pregunta-general "¿Cuál es su nombre?"))))
;)

(defrule pregunta-evento "Preguntar el tipo de evento al cliente"
  (declare (salience 10000))
  =>
  (bind ?evento (pregunta-indice "¿Qué tipo de evento va a realizar?" (deftemplate-slot-allowed-values MAIN::Preferencias evento)))
  (assert (Preferencias (evento ?evento)))
)

(defrule pregunta-num-comensales "Preguntar el número de comensales al cliente"
  (declare (salience 9950))
  ?prefs <- (Preferencias (comensales 0))
  =>
  (bind ?comensales (pregunta-numerica-positiva "¿Cuántos comensales van a ser?"))
  (modify ?prefs (comensales ?comensales))
)

(defrule pregunta-tipos-menu "Preguntar los tipos de cocina preferidas para el menú"
  (declare (salience 9900))
  ?prefs <- (Preferencias (tipos-menu desconocido))
  =>
  (bind $?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" (class-subclasses Plato)))
  (modify ?prefs (tipos-menu $?respuesta))
)

(defrule pregunta-regional "Preguntar si el cliente prefiere platos regionales"
  (declare (salience 9850))
  (not (regional))
  =>
  (bind ?respuesta (pregunta-si-no "¿Prefiere comida de alguna zona geográfica concreta?"))
  (assert (regional ?respuesta))
)

(defrule pregunta-regiones "Preguntar las regiones preferidas"
  (declare (salience 10000))
  (regional TRUE)
  ?prefs <- (Preferencias (regiones "desconocido"))
  =>
  (bind $?respuesta (seleccionar-instancias Region nombre "¿De qué zonas geográficas prefiere que sea la comida?"))
  (bind $?regiones (create$))
  (progn$ (?region $?respuesta)
          (bind $?regiones (add$ (send ?region get-nombre) $?regiones)))
  (modify ?prefs (regiones $?regiones))
)

(defrule pregunta-tipos-comensal "Preguntar los tipos de cliente del menú"
  (declare (salience 9800))
  ?prefs <- (Preferencias (ingredientes-prohibidos "desconocido"))
  =>
  (bind $?respuesta (seleccionar-instancias TipoComensal nombre "¿Qué tipo(s) de comensales tendrá el menú?"))
  
  (bind $?ingredientes-prohibidos (create$))
  (progn$ (?tipo $?respuesta)
    (bind $?conflictos (send ?tipo get-conflictos))
    (progn$ (?conflicto $?conflictos)
      (bind $?ingredientes-prohibidos (add$ (send (instance-address * ?conflicto) get-nombre) $?ingredientes-prohibidos))
    )
  )
  (modify ?prefs (ingredientes-prohibidos $?ingredientes-prohibidos))
)

(defrule pregunta-temperatura "Preguntar la temperatura de comida preferida"
  (declare (salience 9700))
  ?prefs <- (Preferencias (temperatura desconocido))
  =>
  (bind ?respuesta (pregunta-indice "¿Prefiere comida caliente o fría?" (slot-allowed-values MAIN::Plato temperatura)))
  (modify ?prefs (temperatura ?respuesta))
)

(defrule pregunta-estacion "Preguntar la estacion del año"
  (declare (salience 9600))
  (not (estacion preguntada))
  ?prefs <- (Preferencias (ingredientes-prohibidos $?prohibidos))
  =>
  (bind ?est (seleccionar-instancia Epoca nombre "¿En qué época desea consumir el menú?"))
  ; TODO Añadir ingredientes prohibidos!
  (bind $?disponibles (send ?est get-dispone-de))
  (bind $?epocas (find-all-instances ((?inst Epoca)) TRUE))
  (progn$ (?epoca $?epocas)
    (if (neq ?epoca ?est) then
      (bind $?dispone (send ?epoca get-dispone-de))
      (progn$ (?ingrediente $?dispone)
        (if (not (member$ ?ingrediente $?disponibles)) then
          (bind $?prohibidos (add$ (send (instance-address * ?ingrediente) get-nombre) $?prohibidos))
        )
      )
    )
  )
  (assert (Contexto (estacion (send ?est get-nombre))))
  (modify ?prefs (ingredientes-prohibidos $?prohibidos))
  (assert (estacion preguntada))
)

(defrule ir-a-filtrar "Empieza a filtrar resultados"
  (declare (salience -10000))
  (Preferencias)
  =>
  (focus filtracion)
)
