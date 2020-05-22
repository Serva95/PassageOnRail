require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  test "posti_disponibili should return number of places available on route" do
    r = routes(:ferrara_bologna_booked)
    assert_equal 3, r.posti_disponibili
  end

  test "find_passengers should return all booked users" do
    r = routes(:ferrara_bologna_booked)
    u = users(:one)
    u_unbooked = users(:two)
    assert_includes r.find_passengers, u
    assert_not_includes r.find_passengers, u_unbooked
  end

  test "self.find_journeys should return journeys from route" do
    r = routes(:bologna_milano_booked)
    j = journeys(:one)
    r_unbooked = routes(:ferrara_bologna_unbooked)
    assert_includes Route.find_journeys(r.id), j
    assert_empty Route.find_journeys(r_unbooked.id)
  end

  test "self.booked should return stage associated with the user booking the route" do
    r_booked = routes(:ferrara_bologna_booked)
    r_unbooked = routes(:ferrara_bologna_unbooked)
    u = users(:one)
    s = stages(:ferrara_bologna)
    assert_includes Route.booked(r_booked.id, u.id), s
    assert_empty Route.booked(r_unbooked, u.id)
  end

  # OBSOLETO
  # test "self.find_driver should return route driver" do
  #   r = routes(:ferrara_bologna_booked)
  #   u = users(:two)
  #   assert_equal Route.find_driver(r), u
  # end

  test "self.find_pay_method should return a user's valid payment methods" do
    r_contanti = routes(:ferrara_bologna_contanti)
    r_no_contanti = routes(:ferrara_bologna_not_contanti)
    u = users(:one)
    pay = pay_methods(:two)
    contanti = pay_methods(:contanti)
    assert_includes Route.find_pay_method(u.id, [r_contanti]), pay
    assert_includes Route.find_pay_method(u.id, [r_contanti]), contanti
    assert_includes Route.find_pay_method(u.id, [r_no_contanti,r_contanti]), pay
    assert_not_includes Route.find_pay_method(u.id, [r_contanti,r_no_contanti]), contanti
  end

  #date due route di una multitratta, ritorna true se quella passata come primo parametro è antecedente all'altra
  test "self.first_route(route1,route2) should return if the first route is older than the second" do
    rolder = routes(:ferrara_bologna_booked)
    ryounger = routes(:bologna_milano_booked)
    assert Route.first_route(rolder, ryounger)
    assert_not Route.first_route(ryounger, rolder)
  end

  # Controlla se due tratte del multiviaggio si sovrappongono
  test "self.overlying(route1,route2) should return if two route in multitrip overlying" do
    rolder = routes(:ferrara_bologna_booked)
    ryounger = routes(:bologna_milano_booked)
    roverlying = routes(:bologna_milano_overlying)
    assert_not Route.overlying(rolder, ryounger)
    assert Route.overlying(ryounger, roverlying)
  end

  # Elimina la route del driver e tutte le relative prenotazioni
  test "self.destroy_route_and_stages(route,current_user) should delete route of user and destroy all his stage and journey" do
    r = routes(:bologna_milano_booked)
    u = users(:two)
    Route.destroy_route_and_stages(r,u)
    j = Route.find_journeys(r.id)
    s = Stage.where("route_id = ? ", r.id)
    assert r.deleted
    assert_empty j
    assert_empty s
  end

  # Data una route e una journey multitratta a cui appartiene, trova lo stage dell'altra route della stessa journey
  test "self.find_second_stage(journey, route_id) should return second route of same journey" do
    r1 = routes(:ferrara_bologna_booked)
    j = Route.find_journeys(r1.id).first
    r2 = routes(:bologna_milano_booked)
    result = Route.find_second_stage(j, r1.id)
    assert_equal result , r2
  end

  test "self.find_associated_stage(route_id, user_id, j_id) should return if one route, user and journey are associated" do
    r_ok = routes(:bologna_milano_booked)
    r_error = routes(:ferrara_bologna_unbooked)
    j = Route.find_journeys(r_ok.id).first
    u = users(:one)
    assert Route.find_associated_stage(r_ok.id, u.id, j.id)
    assert_not Route.find_associated_stage(r_error.id, u.id, j.id)
  end

end
