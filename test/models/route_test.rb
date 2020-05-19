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

  test "self.find_driver should return route driver" do
    r = routes(:ferrara_bologna_booked)
    u = users(:two)
    assert_equal Route.find_driver(r), u
  end

  test "self.find_pay_method should return a user's valid payment methods" do

  end

  #date due route di una multitratta, ritorna true se quella passata come primo parametro è antecedente all'altra
  test "self.first_route(route1,route2)" do
    assert true
  end

  # Controlla se due tratte del multiviaggio si sovrappongono
  test "self.overlying(route1,route2)" do
    assert true
  end

  # Decrementa il numero di passeggeri
  test "self.decrease(route_id, n_passeggeri)" do
    assert true
  end

  # Elimina la route del driver e tutte le relative prenotazioni
  test "self.destroy_route_and_stages(route,current_user)" do
    assert true
  end

  # Data una route e una journey multitratta a cui appartiene, trova lo stage dell'altra route della stessa journey
  test "self.find_second_stage(journey, route_id)" do
    assert true
  end

  # @param [Numeric] user_id
  # @param [Numeric] route_id
  # @param [Numeric] j_id
  test "self.find_associated_stage(route_id, user_id, j_id)" do
    assert true
  end

end
