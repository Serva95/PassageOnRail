class Search < ApplicationRecord

  def define_order(s_order)
    s_order=='Crescente' ? :asc : :desc
  end

  def hide_multitrip
    if multitrip
      return true
    else
      return false
    end
  end

  def search_routes

    select_clause= 'routes.*, (routes.tempo_percorrenza/60) AS ore, (routes.tempo_percorrenza%60) AS min'

    routes = Route.select(select_clause)

    routes = routes.where(["citta_partenza LIKE ?","%#{c_partenza}"])
    routes = routes.where(["citta_arrivo LIKE ?","%#{c_arrivo}"])
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = routes.joins(:driver).where(["drivers.rating_medio >= ?",rating]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    routes = routes.joins(:vehicle).where(["vehicles.marca LIKE ?","%#{tipo_mezzo}"]) if tipo_mezzo.present?
    routes = routes.joins(:vehicle).where(["vehicles.comfort >= ?",comfort]) if comfort.present?

    sorder=define_order(sort_order)

    routes = routes.order(costo: sorder) if sort_attribute.eql?('Costo')
    routes = routes.order(tempo_percorrenza: sorder) if sort_attribute.eql?('Tempo di percorrenza')
    routes = routes.joins(:vehicle).order(comfort: sorder) if sort_attribute.eql?('Comfort')

    return routes

  end

  def multi_routes_search

    #bisogna valutare se applicare tutti i filtri del singolo viaggio (es marchio veicolo, cambiando auto non ha molto senso) e terminare ordinamento per comfort

    select_clause= 'routes.id AS id1, routes.citta_partenza AS c_part, routes.data_ora_partenza AS part, routes.citta_arrivo AS tappa, routes.vehicle_id,
                    other_routes.id AS id2, other_routes.citta_arrivo AS c_arr,
                    first_vehicle.comfort AS comf,
                    SUM(routes.costo+other_routes.costo) AS c_tot, SUM(routes.tempo_percorrenza+other_routes.tempo_percorrenza) AS t_tot, (SUM(routes.tempo_percorrenza+other_routes.tempo_percorrenza)/60) AS ore,(SUM(routes.tempo_percorrenza+other_routes.tempo_percorrenza)%60) AS min'
    from_clause = 'routes, routes as other_routes, vehicles AS first_vehicle'
    where_clause = "routes.citta_arrivo = other_routes.citta_partenza AND routes.citta_partenza LIKE ? AND other_routes.citta_arrivo LIKE ?"
    group_clause = 'routes.id,other_routes.id'

    routes=Route.all
    routes =routes.select(select_clause).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).joins(:vehicle).from(from_clause).group(group_clause)

    sorder=define_order(sort_order)

    routes = routes.order(c_tot: sorder) if sort_attribute.eql?('Costo')
    routes = routes.order(t_tot: sorder) if sort_attribute.eql?('Tempo di percorrenza')

    return routes

  end

end
