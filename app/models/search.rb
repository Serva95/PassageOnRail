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

    routes = Route.select(select_clause).where('data_ora_partenza > NOW()')

    routes = routes.where(["citta_partenza ILIKE ?","%#{c_partenza}"])
    routes = routes.where(["citta_arrivo ILIKE ?","%#{c_arrivo}"])
    routes = routes.where(["data_ora_partenza >= ?", data_ora]) if data_ora.present?
    routes = routes.joins(:driver).where(["drivers.rating_medio >= ?",rating]) if rating.present?
    routes = routes.where(["costo <= ?",costo]) if costo.present?
    routes = routes.joins(:vehicle).where(["vehicles.tipo_mezzo ILIKE ?","%#{tipo_mezzo}"]) if !tipo_mezzo.eql?('Altro')
    routes = routes.joins(:vehicle).where(["vehicles.comfort >= ?",comfort]) if comfort.present?

    sorder=define_order(sort_order)

    routes = routes.order(costo: sorder) if sort_attribute.eql?('Costo')
    routes = routes.order(tempo_percorrenza: sorder) if sort_attribute.eql?('Tempo di percorrenza')
    routes = routes.joins(:vehicle).order(comfort: sorder) if sort_attribute.eql?('Comfort')

    return routes

  end

  def multi_routes_search

    #bisogna valutare se applicare tutti i filtri del singolo viaggio (es marchio veicolo, cambiando auto non ha molto senso) e terminare ordinamento per comfort

    select_clause= 'Ms1.id AS id1, Ms1.citta_partenza AS c_part, Ms1.data_ora_partenza AS part,Ms1.citta_arrivo AS tappa,
                   Ms2.id AS id2,Ms2.citta_arrivo AS c_arr,
                  SUM(Ms1.costo+Ms2.costo) AS c_tot, (EXTRACT(DAY FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza) * 24 +
                                                      EXTRACT(HOUR FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza)) AS ore,
                                                      ((EXTRACT(DAY FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza) * 24 +
                                                      EXTRACT(HOUR FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza))*60)+
                                                      EXTRACT(MINUTE FROM Ms2.data_ora_arrivo - Ms1.data_ora_partenza) AS min'
    from_clause = 'multitrip_search_results Ms1, multitrip_search_results as Ms2'
    where_clause = 'Ms1.citta_partenza ILIKE ? AND Ms2.citta_arrivo ILIKE ? AND Ms1.citta_arrivo = Ms2.citta_partenza
                   AND Ms2.data_ora_partenza >= Ms1.data_ora_arrivo AND (EXTRACT(DAY FROM Ms2.data_ora_partenza - Ms1.data_ora_arrivo) * 24 + EXTRACT(HOUR FROM Ms2.data_ora_partenza - Ms1.data_ora_arrivo)) <= 5'
   group_clause = 'Ms1.id,Ms2.id,Ms1.citta_partenza,Ms1.data_ora_partenza,Ms1.citta_arrivo,Ms2.citta_arrivo,Ms2.data_ora_arrivo'


    routes =MultitripSearchResult.select(select_clause).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).from(from_clause).group(group_clause)
    routes=routes.where('Ms1.data_ora_partenza > NOW()')
    routes = routes.where(["Ms1.data_ora_partenza >= ?", data_ora]) if data_ora.present?


    sorder=define_order(sort_order)

   routes = routes.order(c_tot: sorder) if sort_attribute.eql?('Costo')
   routes = routes.order(min: sorder) if sort_attribute.eql?('Tempo di percorrenza')

    return routes

  end

end
