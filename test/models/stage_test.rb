require 'test_helper'

class StageTest < ActiveSupport::TestCase
  test "#already_checked(route_id, journey_id) should return accepted nil" do
   j = journeys(:five)
   r = routes(:verona_milano)
   s = Stage.already_checked(r.id,j.id)
   assert_nil s.accepted
  end

  test "#already_checked(route_id, journey_id) should return accepted true" do
    j = journeys(:five)
    r = routes(:milano_venezia)
    s = Stage.already_checked(r.id,j.id)
    assert_equal true, s.accepted
  end

  test "#delete_stage should delete a stage" do
    j = journeys(:five)
    r = routes(:verona_milano)
    assert Stage.delete_stage(j, r)
    assert_equal 0, r.n_passeggeri
  end

  test "#stage.reject(n_passeggeri) should decremente a stage" do
    s = stages(:milano_venezia_nil)
    j = journeys(:five)
    assert s.reject(j.n_prenotati)
    r = routes(:milano_venezia)
    assert_equal 0, r.n_passeggeri
  end

end