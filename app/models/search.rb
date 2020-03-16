class Search < ApplicationRecord

  def define_order(s_order)
    s_order=='Crescente' ? :asc : :desc
  end

  def search_routes

    routes = Route.all

    routes = routes.where(["citta_partenza LIKE ?","%#{c_partenza}"]) if c_partenza.present?
    routes = routes.where(["citta_arrivo LIKE ?","%#{c_arrivo}"]) if c_arrivo.present?
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = Route.joins(:driver).where(["drivers.rating_medio >= ?",rating]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    routes = Route.joins(:vehicle).where(["vehicles.marca LIKE ?","%#{tipo_mezzo}"]) if tipo_mezzo.present?
    routes = Route.joins(:vehicle).where(["vehicles.comfort >= ?",comfort]) if comfort.present?

    order=define_order(sort_order)

    routes = routes.order(costo: order) if sort_attribute.eql?('Costo')
    routes = routes.order(tempo_percorrenza: order) if sort_attribute.eql?('Tempo di percorrenza')
    routes = Route.joins(:vehicle).order(comfort: order) if sort_attribute.eql?('Comfort')

    return routes

  end

  def multi_routes_search

    select_clause1 = 'DISTINCT routes.*'
    #select_clause2 = 'DISTINCT routes.*, other_routes.*'
    from_clause = 'routes, routes as other_routes'
    where_clause = "routes.citta_arrivo = other_routes.citta_partenza AND routes.citta_partenza LIKE ? AND other_routes.citta_arrivo LIKE ?"

    routes1 =Route.select(select_clause1).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).from(from_clause)
   # routes2=Route.select(select_clause2).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).from(from_clause)

    return routes1 #, routes2

  end

end
