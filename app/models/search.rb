class Search < ApplicationRecord

  def search_routes

    routes = Route.all

    routes = routes.where(["citta_partenza LIKE ?","%#{c_partenza}"]) if c_partenza.present?
    routes = routes.where(["citta_arrivo LIKE ?","%#{c_arrivo}"]) if c_arrivo.present?
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = Route.joins(:driver).where(["drivers.rating_medio >= ?",rating]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    routes = Route.joins(:vehicle).where(["vehicles.marca LIKE ?","%#{tipo_mezzo}"]) if tipo_mezzo.present?
    routes = Route.joins(:vehicle).where(["vehicles.comfort >= ?",comfort]) if comfort.present?

    return routes

  end

end
