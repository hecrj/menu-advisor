(defmodule menus-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule puntuar-menu-platos "Puntúa un menú en función de la puntuación de sus platos"
    ?menu <- (object (is-a Menu) (primero ?prim) (segundo ?seg) (postre ?pos) (puntuacion ?punt) (justificaciones $?just))
    (not (platos-puntuados ?menu))
    =>
    (bind ?menu-punt
        (+
            (+
                (send ?prim get-puntuacion)
                (send ?seg get-puntuacion)
            )
            (send ?pos get-puntuacion)
        )
    )
    (send ?menu put-puntuacion (+ ?punt ?menu-punt))
    (assert (platos-puntuados ?menu))
)

(defrule puntuar-pesadez "Puntúa un menú demasiado pesado negativamente"
	?menu <- (object (is-a Menu) (primero ?prim) (segundo ?seg) (puntuacion ?punt) (justificaciones $?just))
	(not (pesadez-puntuada ?menu))
    (test (eq (send (plato ?prim) get-pesadez) PESADO))
    (test (eq (send (plato ?seg) get-pesadez) PESADO))
	=>
	(send ?menu put-puntuacion (- ?punt 50))
	(send ?menu put-justificaciones
		(add$ (str-cat "El primero y el segudo son platos pesados, los comensales lo pueden encontrar excesivo -> -50") $?just))
	(assert (pesadez-puntuada ?menu))
)

(defrule puntuar-ligereza "Puntúa un menú demasiado ligero negativamente"
	?menu <- (object (is-a Menu) (primero ?prim) (segundo ?seg) (puntuacion ?punt) (justificaciones $?just))
	(not (ligereza-puntuada ?menu))
	(test (eq (send (plato ?prim) get-pesadez) LIGERO))
	(test (eq (send (plato ?seg) get-pesadez) LIGERO))
	=>
	(send ?menu put-puntuacion (- ?punt 50))
	(send ?menu put-justificaciones
		(add$ (str-cat "El primero y el segudo son platos ligeros, los comensales pueden no saciarse -> -50") $?just))
	(assert (ligereza-puntuada ?menu))
)

(defrule ir-a-seleccionar "Empieza a seleccionar menús"
  (declare (salience -10000))
  =>
  (focus menus-seleccion)
)
