; Recomendacion representa una recomendacion de un plato para el menu
(defclass Recomendacion 
	(is-a USER)
	(role concrete)
	(slot plato
		(type INSTANCE)
		(create-accessor read-write))
	(slot puntuacion
		(type INTEGER)
		(create-accessor read-write))
	(multislot justificaciones
		(type STRING)
		(create-accessor read-write))
)

; Menu representa la solucion final al problema
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
