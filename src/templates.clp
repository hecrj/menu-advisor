(deftemplate Preferencias
  (multislot tipos (type SYMBOL) (default desconocido))
  (slot alcohol (type SYMBOL) (default desconocido))
  (slot temperatura (type SYMBOL) (default desconocido))
)

(deftemplate Cliente
  (slot nombre (type STRING))
  (slot edad (type INTEGER) (default -1))
)
