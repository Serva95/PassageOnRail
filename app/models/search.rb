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

    #tutto ciò che è commentato sono tentativi disperati o bozze di idee...COME FACCIO A TIRAR FUORI DUE ROUTE ACCOPPIATE????
    #select_clause1 = 'routes.*'
    select_clause1= 'routes.id AS id1, routes.citta_partenza AS c_part, routes.data_ora_partenza AS part, routes.citta_arrivo AS tappa, other_routes.id AS id2, other_routes.citta_arrivo AS c_arr, SUM(routes.costo+other_routes.costo) AS c_tot'
    select_clause2 = 'routes.*, other_routes.*'
    from_clause = 'routes, routes as other_routes'
    where_clause = "routes.citta_arrivo = other_routes.citta_partenza AND routes.citta_partenza LIKE ? AND other_routes.citta_arrivo LIKE ?"
    group_clause = 'routes.id,other_routes.id'

      routes=Route.all
      routes1 =routes.select(select_clause1).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).from(from_clause).group(group_clause)

   # routes2=Route.select(select_clause2).where([where_clause,"%#{c_partenza}","%#{c_arrivo}"]).from(from_clause)
    # routes=Route.select(select_clause1).where([routes.citta_arrivo = other_routes.citta_partenza AND routes.citta_partenza LIKE ? AND other_routes.citta_arrivo LIKE ? AND routes.id=?","%#{c_partenza}","%#{c_arrivo}",routes1.id]).from(from_clause)


    #$routeprima=routes1.ids #PARE che ci metta dentro gli id di tutte le prime tratte -> provare a sfruttarla per tirare fuori coppie di id
    #$routeprima.each do |rp|
    #  routes=Route.select(select_clause1).where([routes.citta_arrivo = other_routes.citta_partenza AND routes.citta_partenza LIKE ? AND other_routes.citta_arrivo LIKE ? AND routes.id=?","%#{c_partenza}","%#{c_arrivo}",rp]).from(from_clause)
     #MAGARI SE LO METTO IN UN'ALTRA FUNZIONE FUNZIONA (DEVO AVERE LA CERTEZZA DI POTERGLI PASSARE routeprima)


    #routes1=Route.find_by_id(routes1.id) però come fare se routes1 ne tira fuori di più?
    return routes1 #, routes2

  end

end
