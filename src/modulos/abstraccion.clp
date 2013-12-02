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

(defrule pregunta-tipos-menu "Preguntar los tipos de cocina preferidas para el menú"
  (declare (salience 9900))
  ?prefs <- (Preferencias (tipos-menu desconocido))
  =>
  (bind $?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" (class-subclasses Plato)))
  (modify ?prefs (tipos-menu $?respuesta))
)

(defrule pregunta-tipos-comensal "Preguntar los tipos de cliente del menú"
  (declare (salience 9800))
  ?prefs <- (Preferencias (tipos-comensal desconocido))
  =>
  (bind $?respuesta (seleccionar-instancias TipoComensal nombre "¿Qué tipo(s) de comensales tendrá el menú?"))
  (modify ?prefs (tipos-comensal $?respuesta))
)

(defrule ir-a-filtrar "Empieza a filtrar resultados"
  (declare (salience -10000))
  (Preferencias)
  =>
  (focus filtracion)
)