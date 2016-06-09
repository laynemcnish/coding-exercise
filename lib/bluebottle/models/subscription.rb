require 'active_support/all'

module BlueBottle
  module Models
    class Subscription
      attr_accessor :customer,
                    :coffee,
                    :status,
                    :created_at

      def initialize(customer, coffee, status)
        @customer = customer
        @coffee = coffee
        @status = status ||= :active
        @created_at = Time.now
      end

      def paused?
        status == :paused
      end

      def cancelled?
        status == :cancelled
      end

      def validate_cancellation(last_subscription)
        if last_subscription && last_subscription.paused? && cancelled?
          raise "You may not cancel a paused subscription."
        end
      end
    end
  end
end
