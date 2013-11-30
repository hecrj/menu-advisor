(defmodule filtracion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule crear-recomendaciones-iniciales "Crea las recomendaciones iniciales en función de los tipos preferidos"
	(Preferencias (tipos $?tipos))
	=>
	(bind $?platos (find-all-instances ((?inst Plato)) TRUE))
	(progn$ (?plato $?platos)
		(make-instance (gensym) of Recomendacion (plato ?plato))
	)
)

(defrule ir-a-puntuar "Empieza a puntuar resultados"
  (declare (salience -10000))
  (Cliente)
  (Preferencias)
  =>
  (focus puntuacion)
)
