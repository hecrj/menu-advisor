(defmodule puntuacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(defrule puntuar-tipos "Puntúa una recomendación en función del tipo de plato"
	(Preferencias (tipos-menu $?tipos_menu))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(not (tipo-puntuado ?rec))
	=>
	(bind ?tipo_plato (class ?plato))
	(if (member$ ?tipo_plato $?tipos_menu) then
		(send ?rec put-puntuacion
			(+ ?punt 100))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato es de tipo " (lowcase ?tipo_plato) ", preferido por el cliente -> +100") $?just))
	else (if (neq ?tipo_plato Generico) then
		(send ?rec put-puntuacion
			(- ?punt 100))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato no es de un tipo genérico/preferido por el cliente: " (lowcase ?tipo_plato) " -> -100") $?just))
		)
	)
	(assert (tipo-puntuado ?rec))
)

(defrule puntuar-temperatura "Puntúa los platos en función de la temperatura preferida"
	(Preferencias (temperatura ?temperatura_preferida))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(not (temperatura-puntuada ?rec))
	=>
	(bind ?temperatura_plato (send ?plato get-temperatura))
	(if (eq ?temperatura_preferida ?temperatura_plato) then
		(send ?rec put-puntuacion
			(+ ?punt 75))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato se sirve " (lowcase ?temperatura_plato) ", preferido por el cliente -> +75") $?just))
	else 
		(send ?rec put-puntuacion
			(- ?punt 75))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato se sirve " (lowcase ?temperatura_plato) ", no preferido por el cliente -> -75") $?just))
		
	)
	(assert (temperatura-puntuada ?rec))
)

(defrule puntuar-verano "Puntúa los platos calientes negativamente en verano"
	(Contexto (estacion "Verano"))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(test (eq (send ?plato get-temperatura) CALIENTE))
	(not (caliente-puntuado ?rec))
	=>
	(send ?rec put-puntuacion (- ?punt 25))
	(send ?rec put-justificaciones
		(add$ (str-cat "Los platos calientes no suelen apetecer en verano -> -25") $?just))
	(assert (caliente-puntuado ?rec))
)

(defrule puntuar-invierno "Puntúa los platos calientes positivamente en invierno"
	(Contexto (estacion "Invierno"))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(test (eq (send ?plato get-temperatura) CALIENTE))
	(not (caliente-puntuado ?rec))
	=>
	(send ?rec put-puntuacion (+ ?punt 40))
	(send ?rec put-justificaciones
		(add$ (str-cat "Los platos calientes suelen apetecer en invierno -> +40") $?just))
	(assert (caliente-puntuado ?rec))
)

(defrule ir-a-seleccionar "Empieza a seleccionar resultados"
  (declare (salience -10000))
  (Preferencias)
  =>
  (focus seleccion)
)
