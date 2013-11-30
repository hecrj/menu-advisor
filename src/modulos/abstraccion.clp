(defmodule abstraccion
  (import MAIN ?ALL)
  (export ?ALL)
)

(defrule pregunta-nombre "Preguntar el nombre al cliente"
  (not (Cliente))
  =>
  (assert (Cliente (nombre (pregunta-general "¿Cuál es su nombre?"))))
)

(defrule pregunta-edad "Preguntar la edad al cliente"
  ?cliente <- (Cliente (edad -1))
  =>
  (bind ?edad (pregunta-numerica-positiva "¿Qué edad tiene?"))
  (bind ?alcohol (if (<= ?edad 17)
                     then FALSE
                     else desconocido
                 )
  )
  (modify ?cliente (edad ?edad))
  (assert (Preferencias (alcohol ?alcohol)))
)

(defrule pregunta-tipo "Preguntar el tipo de comida preferida"
  ?prefs <- (Preferencias (tipos desconocido))
  =>
  (bind ?tipos (create$ Tradicional Moderno))
  (bind ?respuesta (pregunta-multi "¿Qué tipo(s) de menú prefiere?" ?tipos))
  (modify ?prefs (tipos ?respuesta))
)

(defrule pregunta-alcohol "Preguntar si el cliente bebe alcohol"
  ?prefs <- (Preferencias (alcohol desconocido))
  =>
  (modify ?prefs (alcohol (pregunta-si-no "¿Bebe alcohol?")))
)

(defrule pregunta-temperatura "Preguntar la temperatura de comida preferida"
  ?prefs <- (Preferencias (temperatura desconocido))
  =>
  (bind ?tipos (create$ Caliente Frio))
  (bind ?respuesta (pregunta-indice "¿Prefiere comida caliente of fria?" ?tipos))
  (modify ?prefs (temperatura ?respuesta))
)


(defrule ir-a-filtrar "Empieza a filtrar resultados"
  (declare (salience -10000))
  (Cliente)
  (Preferencias)
  =>
  (focus filtracion)
)