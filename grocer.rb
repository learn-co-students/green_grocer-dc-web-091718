require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  
  cart.each do |item|
    item.each do |name, values|
      if new_cart.keys.include?(name)
        new_cart[name][:count] = new_cart[name][:count] + 1
      else
        new_cart[name] = values
        new_cart[name][:count] = 1
      end
    end
  end

  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    new_name = name + " W/COUPON"
    
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart[new_name]
        cart[new_name][:count] += 1
      else
        cart[new_name] = { count: 1, price: coupon[:cost] }
        cart[new_name][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  
  cart
end

def apply_clearance(cart)
  clearance_discount = 0.2
  cart.each do |item, details|
    if details[:clearance] == true
      amount_saved = details[:price] * clearance_discount
      details[:price] -= amount_saved
    end
  end
  
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
  total = 0
  
  cart.each do |item, details|
    total += details[:price] * details[:count]
  end
  
  if total > 100
    total -= total*0.1
  end
  total

end
