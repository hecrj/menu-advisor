(defmodule filtracion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule crear-recomendaciones-iniciales "Crea las recomendaciones iniciales en función de los tipos de comensal"
	(Preferencias (tipos-comensal $?tipos))
	=>
	(bind $?total-problemas (find-all-instances ((?inst IngredienteProblematico)) TRUE))
	(bind $?problemas (create$))
	(progn$ (?tipo $?tipos)
		(bind $?problemas-tipo (send ?tipo get-conflictos))
		(progn$ (?problema $?problemas-tipo)
			(if (not (member$ ?problema $?problemas)) then
				(bind $?problemas (add$ (send (instance-address * ?problema) get-nombre) $?problemas))
			)
		)
	)
	(progn$ (?problema $?total-problemas)
		(if (not (member$ (send ?problema get-nombre) $?problemas)) then
			(bind $?platos (send ?problema get-platos))
			(progn$ (?plato $?platos)
				(bind ?conflicto_indirecto FALSE)
				(bind ?problemas-plato (send (instance-address * ?plato) get-problemas))
				(progn$ (?problema-plato ?problemas-plato)
					(if (member$ (send (instance-address * ?problema-plato) get-nombre) $?problemas) then
						(bind ?conflicto_indirecto TRUE)
					)
				)
				(if (eq ?conflicto_indirecto FALSE) then
					(make-instance (gensym) of Recomendacion (plato (instance-address * ?plato)))
				)
			)
		)
	)
)

(defrule ir-a-puntuar "Empieza a puntuar resultados"
  (declare (salience -10000))
  (Cliente)
  (Preferencias)
  =>
  (focus puntuacion)
)
