module DisplayPrice

  def display_price
    s = self.price.to_s
    price = sprintf('%.2f', s)
    return "#{price}"
  end

end