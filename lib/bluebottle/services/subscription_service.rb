module BlueBottle
  module Services
    class SubscriptionService

      def initialize(data_store)
        @data_store = data_store
      end

      def add_subscription(customer, coffee, status: :active)
        subscription = BlueBottle::Models::Subscription.new(customer, coffee, status)
        subscription.validate_cancellation(find_latest_customer_subscription_by_coffee(customer, coffee))
        @data_store.subscriptions << subscription
      end

      def pause_subscription(customer, coffee)
        add_subscription(customer, coffee, status: :paused)
      end

      def cancel_subscription(customer, coffee)
        add_subscription(customer, coffee, status: :cancelled)
      end

      def find_latest_customer_subscription_by_coffee(customer, coffee)
        find_all_subscriptions_by_customer(customer).select {|s| s.coffee == coffee}.try(:first)
      end

      def find_all_subscriptions_by_customer(customer)
        @data_store.subscriptions
          .select {|s| s.customer == customer }
          .sort_by {|s| s.created_at }
          .reverse
          .uniq {|s| [s.customer, s.status, s.coffee] }
      end

      def find_active_subscriptions_by_customer(customer)
        all_subscriptions = find_all_subscriptions_by_customer(customer)
        all_subscriptions.any? {|s| s.paused? || s.cancelled?} ? [] : all_subscriptions
      end

      def find_customer_subscriptions_by_status(customer, status)
        find_all_subscriptions_by_customer(customer).select {|s| s.status == status}
      end

      def find_all_subscriptions_by_coffee(coffee)
        @data_store.subscriptions
          .select {|s| s.coffee == coffee }
          .sort_by {|s| s.created_at }
          .reverse
          .uniq {|s| [s.customer, s.status, s.coffee] }
      end

      def find_active_subscriptions_by_coffee(coffee)
        customer_subscriptions = find_all_subscriptions_by_coffee(coffee).group_by(&:customer)
        customer_subscriptions.reject! { |c, s| s.first.cancelled? }
        customer_subscriptions
      end
    end
  end
end
