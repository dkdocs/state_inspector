require 'test_helper'
require 'state_inspector/observers/internal_observer'
include StateInspector::Observers
class A; attr_writer :thing end
class B; attr_accessor :thing end

class ReporterTest < Minitest::Test
  def observer; StateInspector::Reporter[A] end
  def setup; StateInspector::Reporter[A] = InternalObserver; A.toggle_informant end
  def teardown; observer.purge end

  def test_reports_get_made_from_setter_methods
    a = A.new
    a.thing = 4
    assert_equal [[a, "@thing", nil, 4]], observer.values
    a.thing = 5
    assert_equal [
        [a, "@thing", nil, 4],
        [a, "@thing", 4, 5]
      ],
      observer.values
    a.thing = nil
    assert_equal [
        [a, "@thing", nil, 4],
        [a, "@thing", 4, 5],
        [a, "@thing", 5, nil]
      ],
      observer.values
  end

  def test_null_observer_for_no_obervers
    StateInspector::Reporter.default StateInspector::Observers::InternalObserver
    b = B.new
    b.toggle_informant
    b.thing = 42
    assert_equal [[b, "@thing", nil, 42]], StateInspector::Reporter[B].values
    StateInspector::Reporter.default StateInspector::Observers::NullObserver
    assert_equal StateInspector::Observers::NullObserver, StateInspector::Reporter[B]
  end
end