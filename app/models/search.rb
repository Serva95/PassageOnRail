class Search < ApplicationRecord

  def search_routes

    routes = Route.all

    routes = routes.where(["citta_partenza LIKE ?","%#{c_partenza}"]) if c_partenza.present?
    routes = routes.where(["citta_arrivo LIKE ?","%#{c_arrivo}"]) if c_arrivo.present?
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    #routes = routes.where(["rating LIKE ?","%#{rating}"]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    #routes = routes.where(["tipo_mezzo LIKE ?","%#{tipo_mezzo}"]) if tipo_mezzo.present?

    return routes

  end

end
