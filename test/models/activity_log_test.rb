require 'test_helper'

class ActivityLogTest < ActiveSupport::TestCase
  test 'validations' do
    log = ActivityLog.new
    assert_not log.valid?
    assert_equal [:object_id, :object_type, :timestamp], log.errors.keys

    log.object_id = 1
    assert_not log.valid?
    assert_equal [:object_type, :timestamp], log.errors.keys

    log.object_type = 'Order'
    assert_not log.valid?
    assert_equal [:timestamp], log.errors.keys

    log.timestamp = 2.hours.ago.to_i
    assert log.valid?
    assert_empty log.errors.keys
  end

  test 'compute object_state' do
    log = ActivityLog.new
    assert log.object_state == {}

    log = ActivityLog.new(object_id: 101, object_type: 'Order', timestamp: 1.day.ago.to_i, object_changes: { address: 'address1, test', status: 'new' })
    assert log.save
    assert_equal log.object_changes, log.object_state
    log.reload
    assert_equal log.object_changes, log.object_state

    log1 = activity_logs(:order_1)
    assert_equal 'unpaid', log1.object_state['status']
    log2 = log1.dup.tap { |l| l.object_changes = { 'status' => 'paid' }; l.save! }
    assert_equal 'paid', log2.object_state['status']
    assert_nil log2.object_state['mobile']
    log3 = log2.dup.tap { |l| l.object_changes = { 'mobile' => '+686 478123' }; l.save! }
    assert_equal '+686 478123', log3.object_state['mobile']
  end

  test 'ordered scope' do
    log1 = ActivityLog.ordered.first
    log2 = ActivityLog.ordered.last

    assert_equal activity_logs(:order_1), log1
    assert_equal activity_logs(:invoice_1_latest), log2
  end

  test 'for_object scope' do
    scope = ActivityLog.for_object(1, 'Invoice')
    assert_equal 2, scope.count
    assert_equal activity_logs(:invoice_1_latest), scope.last

    scope = ActivityLog.for_object(1, 'Invoice', '1484732820')
    assert_equal 1, scope.count
    assert_equal activity_logs(:invoice_1), scope.last

    scope = ActivityLog.for_object(1, 'Invoice', 1484722821)
    assert_equal 0, scope.count
  end
end
