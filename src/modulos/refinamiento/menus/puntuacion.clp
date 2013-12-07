(defmodule menus-puntuacion
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate Pesos
    (slot pesadez (type INTEGER) (default 50))
    (slot ligereza (type INTEGER) (default 50))
    (slot vino-primero (type INTEGER) (default 50))
    (slot vino-segundo (type INTEGER) (default 50))
)

(defrule inicializa-Pesos "Define la ponderación de factores"
    (declare (salience 10000))
    =>
    (assert (Pesos))
)


(defrule puntuar-pesadez "Puntúa un menú demasiado pesado negativamente"
    (Pesos (pesadez ?peso-pesadez))
    ?menu <- (object (is-a Menu) (primero ?prim) (segundo ?seg) (puntuacion ?punt) (justificaciones $?just))
    (not (pesadez-puntuada ?menu))
    (test (eq (send (plato ?prim) get-pesadez) PESADO))
    (test (eq (send (plato ?seg) get-pesadez) PESADO))
    =>
    (send ?menu put-puntuacion (- ?punt ?peso-pesadez))
    (send ?menu put-justificaciones
        (add$ (str-cat "El primero y el segundo son platos pesados, los comensales lo pueden encontrar excesivo -> -" ?peso-pesadez) $?just))
    (printout t "Pesadez: " ?menu crlf)
    (assert (pesadez-puntuada ?menu))
)

(defrule puntuar-ligereza "Puntúa un menú demasiado ligero negativamente"
    (Pesos (ligereza ?peso-ligereza))
    ?menu <- (object (is-a Menu) (primero ?prim) (segundo ?seg) (puntuacion ?punt) (justificaciones $?just))
    (not (ligereza-puntuada ?menu))
    (test (eq (send (plato ?prim) get-pesadez) LIGERO))
    (test (eq (send (plato ?seg) get-pesadez) LIGERO))
    =>
    (send ?menu put-puntuacion (- ?punt ?peso-ligereza))
    (send ?menu put-justificaciones
        (add$ (str-cat "El primero y el segundo son platos ligeros, los comensales pueden no saciarse -> -" ?peso-ligereza) $?just))
        (printout t "Ligereza: " ?menu crlf)
    (assert (ligereza-puntuada ?menu))
)

(defrule puntuar-vino-primero "Puntúa los menús en función de si el vino encaja con el primer plato"
    (Pesos (vino-primero ?peso-vino-primero))
    ?menu <- (object (is-a Menu) (primero ?prim) (puntuacion ?punt) (justificaciones $?just) (vinos $?vinos))
    (test (> (length $?vinos) 0)) ; tiene que ser un menú con vino
    (not (vino-primero-puntuado ?menu))
    =>
    (bind ?genPrim (send (plato ?prim) get-genero))
    (bind ?predPrim (send (instance-address * ?genPrim) get-predilecto))
    (bind ?color (send (nth 1 $?vinos) get-color))
    (if (eq ?color ?predPrim)
        then (send ?menu put-puntuacion (+ ?punt ?peso-vino-primero))
             (send ?menu put-justificaciones
                 (add$ (str-cat "El primer plato es de un género que encaja bien con el color del vino -> +" ?peso-vino-primero) $?just))
    )
    (assert (vino-primero-puntuado ?menu))
)

(defrule puntuar-vino-segundo "Puntúa los menús en función de si el vino encaja con el segundo plato"
    (Pesos (vino-segundo ?peso-vino-segundo))
    ?menu <- (object (is-a Menu) (segundo ?seg) (puntuacion ?punt) (justificaciones $?just) (vinos $?vinos))
    (test (> (length $?vinos) 0)) ; tiene que ser un menú con vino
    (not (vino-segundo-puntuado ?menu))
    =>
    (bind ?vino (nth (length $?vinos) $?vinos))
    (bind ?genSeg (send (plato ?seg) get-genero))
    (bind ?predSeg (send (instance-address * ?genSeg) get-predilecto))
    (bind ?color (send ?vino get-color))
    (if (eq ?color ?predSeg)
        then (send ?menu put-puntuacion (+ ?punt ?peso-vino-segundo))
             (send ?menu put-justificaciones
                 (add$ (str-cat "El segundo plato es de un género que encaja bien con el color del vino -> +" ?peso-vino-segundo) $?just))
    )
    (assert (vino-segundo-puntuado ?menu))
)

(defrule ir-a-seleccionar "Empieza a seleccionar menús"
  (declare (salience -10000))
  =>
  (printout t "A seleccionar" crlf)
  (focus menus-seleccion)
)
