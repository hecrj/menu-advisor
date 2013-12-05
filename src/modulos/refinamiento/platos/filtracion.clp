(defmodule platos-filtracion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule crear-recomendaciones-iniciales "Crea las recomendaciones iniciales"
	(declare (salience 10000))
	=>
	(bind $?platos (find-all-instances ((?inst Plato)) TRUE))
	(progn$ (?plato $?platos)
		(make-instance (gensym) of Recomendacion (plato ?plato))
	)
)

(defrule ingredientes-prohibidos "Elimina las recomendaciones de platos con ingredientes prohibidos"
	(declare (salience 9900))
	(Preferencias (ingredientes-prohibidos $?prohibidos))
	?rec <- (object (is-a Recomendacion) (plato ?plato))
	=>
	(bind $?ingredientes (send ?plato get-ingredientes))
	(progn$ (?ingrediente $?ingredientes)
		(if (member$ (send (instance-address * ?ingrediente) get-nombre) $?prohibidos) then
			(send ?rec delete)
			(break)
		)
	)
)

(defrule platos-demasiado-caros "Elimina las recomendaciones de platos que exceden el precio"
	(declare (salience 9800))
	(Preferencias (precio-maximo ?max))
	(test (> ?max -1))
	?rec <- (object (is-a Recomendacion) (plato ?plato))
	(test (> (send ?plato get-precio) ?max))
	=>
	(send ?rec delete)
)

(defrule ir-a-puntuar "Empieza a puntuar platos"
  (declare (salience -10000))
  =>
  (focus platos-puntuacion)
)
