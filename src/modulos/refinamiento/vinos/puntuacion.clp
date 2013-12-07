(defmodule vinos-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate Pesos
    
)

(defrule inicializa-Pesos "Define la ponderación de factores"
    (declare (salience 10000))
    (not (Pesos))
    =>
    (estado "Catando vinos...")
    (assert (Pesos))
)

(defrule ir-a-seleccionar "Empieza a seleccionar vinos"
    (declare (salience -10000))
    =>
    (focus vinos-seleccion)
)
