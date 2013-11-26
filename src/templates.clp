(deftemplate Preferencias
	(multislot tipos (type SYMBOL) (default desconocido))
)

(deftemplate Cliente
	(slot nombre (type STRING))
)

; AbstractMenu representa la solucion abstracta del problema
(deftemplate MenuAbstracto
	(multislot tipos
		(type SYMBOL)
		(default desconocido))
)
