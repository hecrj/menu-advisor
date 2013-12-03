(defmodule puntuacion
	(import MAIN ?ALL)
	(export ?ALL)
)

(deftemplate Pesos
    (slot tipo-preferido (type INTEGER) (default 100))
    (slot temperatura-preferida (type INTEGER) (default 75))
    (slot caliente-en-verano (type INTEGER) (default -25))
    (slot caliente-en-invierno (type INTEGER) (default 40))
)

(defrule inicializa-Pesos "Define la ponderación de factores"
	(declare (salience 10000))
	=>
	(assert (Pesos))
)

(defrule puntuar-tipos "Puntúa una recomendación en función del tipo de plato"
	(Preferencias (tipos-menu $?tipos_menu))
	(Pesos (tipo-preferido ?peso))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(not (tipo-puntuado ?rec))
	=>
	(bind ?tipo_plato (class ?plato))
	(if (member$ ?tipo_plato $?tipos_menu) then
		(send ?rec put-puntuacion
			(+ ?punt ?peso))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato es de tipo " ?tipo_plato ", preferido por el cliente -> +" ?peso) $?just))
	else (if (neq ?tipo_plato Generico) then
		(send ?rec put-puntuacion
			(- ?punt ?peso))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato no es de un tipo genérico/preferido por el cliente: " ?tipo_plato " -> -" ?peso) $?just))
		)
	)
	(assert (tipo-puntuado ?rec))
)

(defrule puntuar-temperatura "Puntúa los platos en función de la temperatura preferida"
	(Preferencias (temperatura ?temperatura_preferida))
	(Pesos (temperatura-preferida ?peso))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(not (temperatura-puntuada ?rec))
	=>
	(bind ?temperatura_plato (send ?plato get-temperatura))
	(if (eq ?temperatura_preferida ?temperatura_plato) then
		(send ?rec put-puntuacion
			(+ ?punt ?peso))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato se sirve " (lowcase (str-cat ?temperatura_plato)) ", preferido por el cliente -> +" ?peso) $?just))
	else 
		(send ?rec put-puntuacion
			(- ?punt ?peso))
		(send ?rec put-justificaciones
			(add$ (str-cat "El plato se sirve " (lowcase (str-cat ?temperatura_plato)) ", no preferido por el cliente -> -" ?peso) $?just))
		
	)
	(assert (temperatura-puntuada ?rec))
)

(defrule puntuar-verano "Puntúa los platos calientes negativamente en verano"
	(Contexto (estacion "Verano"))
	(Pesos (caliente-en-verano ?peso))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(test (eq (send ?plato get-temperatura) CALIENTE))
	(not (caliente-puntuado ?rec))
	=>
	(send ?rec put-puntuacion (- ?punt ?peso))
	(send ?rec put-justificaciones
		(add$ (str-cat "Los platos calientes no suelen apetecer en verano -> -" ?peso) $?just))
	(assert (caliente-puntuado ?rec))
)

(defrule puntuar-invierno "Puntúa los platos calientes positivamente en invierno"
	(Contexto (estacion "Invierno"))
	(Pesos (caliente-en-invierno ?peso))
	?rec <- (object (is-a Recomendacion) (plato ?plato) (puntuacion ?punt) (justificaciones $?just))
	(test (eq (send ?plato get-temperatura) CALIENTE))
	(not (caliente-puntuado ?rec))
	=>
	(send ?rec put-puntuacion (+ ?punt ?peso))
	(send ?rec put-justificaciones
		(add$ (str-cat "Los platos calientes suelen apetecer en invierno -> +" ?peso) $?just))
	(assert (caliente-puntuado ?rec))
)

(defrule ir-a-seleccionar "Empieza a seleccionar resultados"
  (declare (salience -10000))
  (Preferencias)
  =>
  (focus seleccion)
)
