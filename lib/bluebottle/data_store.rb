module BlueBottle

  class DataStore
    def initialize
      @store = {
        customers: [],
        coffees: []
      }
    end

    def customers
       @store[:customers]
    end

    def add_coffee(coffee)
      @store[:coffees] << coffee
    end

    def add_customer(customer)
      @store[:customers] << customer
    end
  end
end
