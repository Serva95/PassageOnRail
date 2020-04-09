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

  def already_booked(current_user)
    routes_id=Stage.select('stages.route_id').joins(:journey).where(['journeys.user_id =?',current_user])
  end

  def search_routes(current_user,booked_routes)

    select_clause= 'routes.*, (routes.tempo_percorrenza/60) AS ore, (routes.tempo_percorrenza%60) AS min, vehicles.comfort, vehicles.tipo_mezzo, drivers.rating_medio'
    if current_user.nil?
      where_clause='data_ora_partenza > NOW()'
    else
      where_clause='data_ora_partenza > NOW() AND routes.driver_id != ? ', current_user
    end


    routes = Route.select(select_clause).joins(:vehicle).joins(:driver).where(where_clause).joins(:vehicle)

    routes = routes.where("routes.id NOT IN (?)",booked_routes)
    routes = routes.where(["citta_partenza ILIKE ?","%#{c_partenza}"])
    routes = routes.where(["citta_arrivo ILIKE ?","%#{c_arrivo}"])
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = routes.joins(:driver).where(["drivers.rating_medio >= ?",rating]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    routes = routes.joins(:vehicle).where(["vehicles.tipo_mezzo ILIKE ?","%#{tipo_mezzo}"]) if !tipo_mezzo.eql?('Altro')
    routes = routes.joins(:vehicle).where(["vehicles.comfort >= ?",comfort]) if comfort.present?
    routes = routes.joins(:vehicle).where(["n_passeggeri < vehicles.posti"])

    sorder=define_order(sort_order)

    routes = routes.order(costo: sorder) if sort_attribute.eql?('Costo')
    routes = routes.order(tempo_percorrenza: sorder) if sort_attribute.eql?('Tempo di percorrenza')
    routes = routes.joins(:vehicle).order(comfort: sorder) if sort_attribute.eql?('Comfort')

    return routes

  end

  def multi_routes_search(current_user,booked_routes)

    #bisogna valutare se applicare tutti i filtri del singolo viaggio (es marchio veicolo, cambiando auto non ha molto senso) e terminare ordinamento per comfort

    select_clause= 'Ms1.id AS id1, Ms1.driver_id AS did1, Ms1.citta_partenza AS c_part, Ms1.data_ora_partenza AS part,Ms1.citta_arrivo AS tappa,Ms1.n_passeggeri, Ms1.posti,
                   Ms2.id AS id2, Ms2.driver_id AS did2, Ms2.citta_arrivo AS c_arr,Ms2.n_passeggeri,Ms2.posti,
                  SUM(Ms1.costo+Ms2.costo) AS c_tot, (EXTRACT(DAY FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza) * 24 +
                                                      EXTRACT(HOUR FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza)) AS ore,
                                                      ((EXTRACT(DAY FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza) * 24 +
                                                      EXTRACT(HOUR FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza))*60)+
                                                      EXTRACT(MINUTE FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza) AS min,
                  SUM(Ms1.comfort+Ms2.comfort)/2 AS comfort_medio, SUM(Ms1.rating_medio+Ms2.rating_medio)/2 AS rat'
    from_clause = 'multitrip_search_results Ms1, multitrip_search_results as Ms2'
    if current_user.nil?
      where_clause='Ms1.citta_partenza ILIKE ? AND Ms2.citta_arrivo ILIKE ? AND Ms1.citta_arrivo = Ms2.citta_partenza
                    AND Ms1.id NOT IN (?) AND Ms2.id NOT IN (?)
                   AND Ms2.data_ora_partenza >= Ms1.data_ora_arrivo AND (EXTRACT(DAY FROM Ms2.data_ora_partenza - Ms1.data_ora_arrivo) * 24 + EXTRACT(HOUR FROM Ms2.data_ora_partenza - Ms1.data_ora_arrivo)) <= 5',"%#{c_partenza}","%#{c_arrivo}",booked_routes,booked_routes
    else
      where_clause='Ms1.citta_partenza ILIKE ? AND Ms2.citta_arrivo ILIKE ? AND Ms1.citta_arrivo = Ms2.citta_partenza AND Ms2.driver_id != ?
                    AND Ms1.id NOT IN (?) AND Ms2.id NOT IN (?)
                   AND Ms2.data_ora_partenza >= Ms1.data_ora_arrivo AND (EXTRACT(DAY FROM Ms2.data_ora_partenza - Ms1.data_ora_arrivo) * 24 + EXTRACT(HOUR FROM Ms2.data_ora_partenza - Ms1.data_ora_arrivo)) <= 5',"%#{c_partenza}","%#{c_arrivo}",current_user,current_user,booked_routes,booked_routes
    end
   group_clause = 'Ms1.driver_id,Ms2.driver_id,Ms1.id,Ms2.id,Ms1.citta_partenza,Ms1.data_ora_partenza,Ms1.citta_arrivo,Ms2.citta_arrivo,Ms2.data_ora_arrivo,Ms2.n_passeggeri,Ms2.posti,Ms1.n_passeggeri, Ms1.posti'


    routes =MultitripSearchResult.select(select_clause).where(where_clause).from(from_clause).group(group_clause)
    routes=routes.where('Ms1.data_ora_partenza > NOW()')
    routes = routes.where(["Ms1.data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = routes. where(['Ms1.n_passeggeri < Ms1.posti AND Ms2.n_passeggeri < Ms2.posti'])
    routes = routes.where(['Ms1.comfort >= ? AND Ms2.comfort >= ?', comfort,comfort]) if comfort.present?
    routes = routes.where(['Ms1.rating_medio >= ? AND Ms2.rating_medio >= ?', rating,rating]) if rating.present?
    routes = routes.where(["Ms1.tipo_mezzo ILIKE ? AND Ms2.tipo_mezzo=Ms1.tipo_mezzo","%#{tipo_mezzo}"]) if !tipo_mezzo.eql?('Altro')

    sorder=define_order(sort_order)

   routes = routes.order(c_tot: sorder) if sort_attribute.eql?('Costo')
   routes = routes.order(min: sorder) if sort_attribute.eql?('Tempo di percorrenza')
   routes = routes.order(comfort_medio: sorder) if sort_attribute.eql?('Comfort')

    return routes

  end

end
