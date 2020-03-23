SELECT routes.*, vehicles.comfort,vehicles.tipo_mezzo,drivers.rating_medio, vehicles.posti
FROM routes
INNER JOIN vehicles ON routes.vehicle_id=vehicles.id
INNER JOIN drivers ON routes.driver_id=drivers.id;