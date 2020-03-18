class Search < ApplicationRecord

  def define_order(s_order)
    s_order=='Crescente' ? :asc : :desc
  end

  def search_routes

    routes = Route.all

    routes = routes.where(["citta_partenza LIKE ?","%#{c_partenza}"])
    routes = routes.where(["citta_arrivo LIKE ?","%#{c_arrivo}"])
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = Route.joins(:driver).where(["drivers.rating_medio >= ?",rating]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    routes = Route.joins(:vehicle).where(["vehicles.marca LIKE ?","%#{tipo_mezzo}"]) if tipo_mezzo.present?
    routes = Route.joins(:vehicle).where(["vehicles.comfort >= ?",comfort]) if comfort.present?

    sorder=define_order(sort_order)

    routes = routes.order(costo: sorder) if sort_attribute.eql?('Costo')
    routes = routes.order(tempo_percorrenza: sorder) if sort_attribute.eql?('Tempo di percorrenza')
    routes = routes.joins(:vehicle).order(comfort: sorder) if sort_attribute.eql?('Comfort')

    return routes

  end

  def multi_routes_search

    select_clause= 'routes.id AS id1, routes.citta_partenza AS c_part, routes.data_ora_partenza AS part, routes.citta_arrivo AS tappa, other_routes.id AS id2, other_routes.citta_arrivo AS c_arr,
                    SUM(routes.costo+other_routes.costo) AS c_tot, SUM(routes.tempo_percorrenza+other_routes.tempo_percorrenza) AS t_tot, (SUM(routes.tempo_percorrenza+other_routes.tempo_percorrenza)/60) AS ore,(SUM(routes.tempo_percorrenza+other_routes.tempo_percorrenza)%60) AS min'
    from_clause = 'routes, routes as other_routes'
    where_clause = "routes.citta_arrivo = other_routes.citta_partenza AND routes.citta_partenza LIKE ? AND other_routes.citta_arrivo LIKE ?"
    group_clause = 'routes.id,other_routes.id'

    routes=Route.all
    routes =routes.select(select_clause).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).from(from_clause).group(group_clause)

    sorder=define_order(sort_order)

    routes = routes.order(c_tot: sorder) if sort_attribute.eql?('Costo')
    routes = routes.order(t_tot: sorder) if sort_attribute.eql?('Tempo di percorrenza')

    return routes

  end

end
