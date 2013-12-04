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
)
