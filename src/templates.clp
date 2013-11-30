(deftemplate Preferencias
  (multislot tipos (type SYMBOL) (default desconocido))
  (slot alcohol (type SYMBOL) (default desconocido))
)

(deftemplate Cliente
  (slot nombre (type STRING))
  (slot edad (type INTEGER) (default -1))
)

; AbstractMenu representa la solucion abstracta del problema
(deftemplate MenuAbstracto
  (multislot tipos
             (type SYMBOL)
             (default desconocido))
)
