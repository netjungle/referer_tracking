require "./test/test_helper"

class HasTrackingTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should be ok to access tracking through user" do
    u = User.first
    u.create_tracking
    u.tracking_add_log_line('should not error even if nil')
    u.tracking_update_status('active')

    assert_equal 2, u.tracking.log.lines.count
    assert_equal 'active', u.tracking.status
  end

  test "should not error on nils" do
    u = User.first
    assert_nil u.tracking
    u.tracking_add_log_line('should not error even if nil')
  end

  test "should not remove tracking even when removing trackable" do
    u = User.first
    tracking = u.create_tracking
    u.destroy
    assert RefererTracking::Tracking.where(:id => tracking.id).exists?
  end


end

