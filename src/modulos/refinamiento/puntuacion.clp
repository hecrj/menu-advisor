(defmodule puntuacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule puntuar-tipos "Puntúa los tipos de plato que coinciden con el tipo de menú abstracto"
	(Preferencias (tipos $?tipos_menu))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(not (tipo-puntuado ?rec))
	=>
	(bind ?tipo_plato (send ?plato get-tipo))
	(if (member$ ?tipo_plato $?tipos_menu) then
		(send ?rec put-puntuacion
			(+ ?punt 100))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato es de tipo " ?tipo_plato ", preferido por el cliente -> +100") $?just))
	)
	(assert (tipo-puntuado ?rec))
)

(defrule ir-a-seleccionar "Empieza a seleccionar resultados"
  (declare (salience -10000))
  (Cliente)
  (Preferencias)
  =>
  (focus seleccion)
)
