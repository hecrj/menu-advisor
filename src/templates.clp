(deftemplate Preferencias
  (multislot tipos-menu (type SYMBOL) (default desconocido))
  (multislot tipos-comensal (type SYMBOL) (default desconocido))
  (slot temperatura (type SYMBOL) (default desconocido))
  (slot evento
        (type STRING)
        (allowed-strings "Boda"
                         "Comunión"
                         "Comida de empresa"
                         "Comida familiar"
        )
  )
  (slot comensales (type INTEGER) (range 0 ?VARIABLE))
)

(deftemplate Contexto
  (slot estacion
        (type STRING)
        (allowed-strings "Primavera"
                         "Verano"
                         "Otoño"
                         "Invierno"
        )
  )
)
