; Recomendacion representa una recomendacion de un plato para el menu
(defclass Recomendacion 
    (is-a USER)
    (pattern-match reactive)
    (role concrete)
    (slot plato
        (type INSTANCE)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (multislot justificaciones
        (type STRING)
        (create-accessor read-write))
)

; MenuAbstracto representa un menú con unos colores de vinos en concreto.
; Esto es útil para evitar computar toda combinación de platos - vinos.
(defclass MenuAbstracto
    (is-a USER)
    (role concrete)
    (slot primero
        (type INSTANCE)
        (create-accessor read-write))
    (slot segundo
        (type INSTANCE)
        (create-accessor read-write))
    (slot postre
        (type INSTANCE)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (multislot color-vinos
        (type STRING))
)

; Menu representa la solucion final al problema
; Menu es una clase, porque el problema requiere generar tres menús
(defclass Menu
    (is-a USER)
    (role concrete)
    (slot primero
        (type INSTANCE)
        (create-accessor read-write))
    (slot segundo
        (type INSTANCE)
        (create-accessor read-write))
    (slot postre
        (type INSTANCE)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot precio
        (type FLOAT)
        (default 0.0)
        (create-accessor read-write))
    (slot franja
        (type STRING)
        (allowed-strings "Barato"
                     "Medio"
                     "Caro"
        )
    )
    (multislot vinos
        (type INSTANCE)
        (allowed-classes Vino))
    (multislot justificaciones
        (type STRING)
        (create-accessor read-write))
)


(defclass SeleccionMenus
    (is-a USER)
    (role concrete)
    (multislot baratos
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write))
    (multislot medios
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write))
    (multislot caros
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write))
)