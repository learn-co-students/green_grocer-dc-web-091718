def consolidate_cart(cart)
	cons = {}
	cart.each do |item|
		item.each do |name, info|
			
			if !cons.key?(name)
				cons[name] = info
				cons[name][:count] = 1
			else
				cons[name][:count] += 1
			end
		end
	end
	cons
end

def apply_coupons(cart, coupons)
	coupons.each do |coupon|

		item = coupon[:item]
		num_disc = coupon[:num]
		info = cart[item]

		if info == nil
			break
		elsif info[:count] < num_disc
			false
		elsif cart.key?("#{item} W/COUPON")

			cart["#{item} W/COUPON"][:count] += 1
			info[:count] -= num_disc

		elsif cart.key?(item)

			new_info = {price: coupon[:cost],
						clearance: info[:clearance],
						count: 1} 
			cart["#{item} W/COUPON"] = new_info 
			info[:count] -= num_disc
			
		end

	end
	cart
end

def apply_clearance(cart)
	cart.each do |item, info|
		if info[:clearance]
			discount = info[:price] * 0.2
			info[:price] -= discount
		end
	end
	cart
end

def checkout(cart, coupons)
	cons_cart = consolidate_cart(cart)
	coupons_applied = apply_coupons(cons_cart, coupons)
	clearance_applied = apply_clearance(coupons_applied)

	cart_total = 0.0
	clearance_applied.each do |item, info|
		cart_total += info[:price] * info[:count]
	end

	if cart_total > 100.0
			discount = cart_total * 0.1
			cart_total -= discount
	end
	cart_total

end
