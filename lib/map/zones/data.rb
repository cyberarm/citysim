module CitySim
  class Map
    class Data
      attr_accessor :power, :residents, :workers,
                    :shoppers, :goods
      def initialize(power     = 0,
                    residents  = 0,
                    workers    = 0,
                    shoppers   = 0,
                    goods      = 0)
        @power     = power.is_a?(Numeric)     ? power     : raise("Power must be a number!")
        @residents = residents.is_a?(Numeric) ? residents : raise("Residents must be a number!")
        @workers   = workers.is_a?(Numeric)   ? workers   : raise("Workers must be a number!")
        @shoppers  = shoppers.is_a?(Numeric)  ? shoppers  : raise("Shoppers must be a number!")
        @goods     = goods.is_a?(Numeric)     ? goods     : raise("Goods must be a number!")
      end    
    end
  end
end