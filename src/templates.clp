(deftemplate Preferencias
  (multislot tipos-menu (type SYMBOL) (default desconocido))
  (multislot tipos-comensal (type SYMBOL) (default desconocido))
  (slot alcohol (type SYMBOL) (default desconocido))
)

(deftemplate Cliente
  (slot nombre (type STRING))
  (slot edad (type INTEGER) (default -1))
)
