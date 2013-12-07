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
    (not (pesadez-puntuada TRUE))
    =>
    (progn$ (?menu (find-all-instances ((?menu Menu)) TRUE))
        (bind ?prim (plato (send ?menu get-primero)))
        (bind ?seg (plato (send ?menu get-segundo)))
        (if (and (eq PESADO (send ?prim get-pesadez)) (eq PESADO (send ?seg get-pesadez)))
            then (bind ?punt (send ?menu get-puntuacion))
                 (bind $?just (send ?menu get-justificaciones))
                 (send ?menu put-puntuacion (- ?punt ?peso-pesadez))
                 (send ?menu put-justificaciones
                     (add$ (str-cat "El primero y el segundo son platos pesados, los comensales lo pueden encontrar excesivo -> -" ?peso-pesadez) $?just))
                 ;(printout t "Pesadez: " ?menu crlf))
        )
    (assert (pesadez-puntuada TRUE))
)

(defrule puntuar-ligereza "Puntúa un menú demasiado ligero negativamente"
    (Pesos (ligereza ?peso-ligereza))
    (not (ligereza-puntuada TRUE))
    =>
    (progn$ (?menu (find-all-instances ((?menu Menu)) TRUE))
        (bind ?prim (plato (send ?menu get-primero)))
        (bind ?seg (plato (send ?menu get-segundo)))
        (if (and (eq LIGERO (send ?prim get-pesadez)) (eq LIGERO (send ?seg get-pesadez)))
            then (bind ?punt (send ?menu get-puntuacion))
                 (bind $?just (send ?menu get-justificaciones))
                 (send ?menu put-puntuacion (- ?punt ?peso-ligereza))
                 (send ?menu put-justificaciones
                     (add$ (str-cat "El primero y el segundo son platos ligeros, los comensales pueden no saciarse -> -" ?peso-ligereza) $?just))
                 ;(printout t "Ligereza: " ?menu crlf))
        )
    (assert (ligereza-puntuada TRUE))
)

(defrule puntuar-vino-primero "Puntúa los menús en función de si el vino encaja con el primer plato"
    (Pesos (vino-primero ?peso-vino-primero))
    (not (vino-primero-puntuado TRUE))
    =>
    (progn$ (?menu (find-all-instances ((?menu Menu)) TRUE))
        (bind $?vinos (send ?menu get-vinos))
        (if (> (length $?vinos) 0) then
            (bind ?prim (send ?menu get-primero))
            (bind ?genPrim (send (plato ?prim) get-genero))
            (bind ?predPrim (send (instance-address * ?genPrim) get-predilecto))
            (bind ?color (send (nth 1 $?vinos) get-color))
            (if (eq ?color ?predPrim) then
                (bind ?punt (send ?menu get-puntuacion))
                (bind $?just (send ?menu get-justificaciones))
                (send ?menu put-puntuacion (+ ?punt ?peso-vino-primero))
                (send ?menu put-justificaciones
                    (add$ (str-cat "El primer plato es de un género que encaja bien con el color del vino -> +" ?peso-vino-primero) $?just)))
            ))
    (assert (vino-primero-puntuado TRUE))
)

(defrule puntuar-vino-segundo "Puntúa los menús en función de si el vino encaja con el segundo plato"
    (Pesos (vino-segundo ?peso-vino-segundo))
    (not (vino-segundo-puntuado TRUE))
    =>
    (progn$ (?menu (find-all-instances ((?menu Menu)) TRUE))
        (bind $?vinos (send ?menu get-vinos))
        (if (> (length $?vinos) 0) then ; tiene que ser un menú con vino
            (bind ?vino (nth (length $?vinos) $?vinos))
            (bind ?seg (send ?menu get-segundo))
            (bind ?genSeg (send (plato ?seg) get-genero))
            (bind ?predSeg (send (instance-address * ?genSeg) get-predilecto))
            (bind ?color (send ?vino get-color))
            (if (eq ?color ?predSeg) then
                (bind ?punt (send ?menu get-puntuacion))
                (bind $?just (send ?menu get-justificaciones))
                (send ?menu put-puntuacion (+ ?punt ?peso-vino-segundo))
                (send ?menu put-justificaciones
                    (add$ (str-cat "El segundo plato es de un género que encaja bien con el color del vino -> +" ?peso-vino-segundo) $?just)))
            ))
    (assert (vino-segundo-puntuado TRUE))
)

(defrule ir-a-seleccionar "Empieza a seleccionar menús"
  (declare (salience -10000))
  =>
  (printout t "A seleccionar" crlf)
  (focus menus-seleccion)
)
