class Coin < ApplicationRecord
  validate_uniqueness_of :cmc_id, :name, :symbol, {case_sensitive: false}
  validate_presence_of :cmc_id, :name, :symbol

  has_many :watched_coins, dependent: :destroy
  has_many :users, through: :watched_coins

  def self.create_by_cmc_id(res)
    match = res['data'].with_indifferent_access

    coin_params = {
      name: matched[:name],
      symbol: matched[:symbol],
      cmc_id: matched[:id]
    }

    Coin.find_or_create_by(coin_params) do |coin|
      coin.price = match[:quotes][:USD][:price]
      coin.last_fetched = DateTime.now
  end
end
