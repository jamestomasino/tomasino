package com.tomasino.tracking.omniture
{
	public class OmnitureProduct
	{
		/*
		 * [Category] - This represents the Product Category.  It is not recommended that you use this parameter
		 * due to the fact that it ties the Product to the first Category that it is associated with and it cannot
		 * be changed.  There are now better ways to assign Products to Product Categories so this parameter is
		 * normally not set and remains primarily for historical purposes.
		 *
		 * [Product] - This represents the name or ID of the Product.  If you pass an ID, you can always use
		 * Classifications to upload friendly names and roll products into Categories.  If you will be passing a
		 * lot of Products at one time, it is recommended that you use ID’s instead of full product names to limit
		 * the length of the overall product string so you do not exceed browser character limits.
		 *
		 * [Quantity] - When used with the Purchase Success Event, this represents the quantity of the Product
		 * being purchased (i.e. visitor is buying two memory cards)
		 *
		 * [Total Price] - When used with the Purchase Success Event, this represents the total price for the
		 * Product being purchased (i.e. two memory cards total $200 for both)
		 *
		 * [Incrementor] - You can set an Incrementor Success Event such that you manually pass a currency amount
		 * or number to it. For example, you charge $2.50 shipping for a product and want to show that separate from
		 * Revenue, you can devote a Success Event to “Shipping Costs” and pass "2.5" in this part of the Product
		 * String to add $2.50 with each purchase.
		 *
		 * [Merchandising] - You can use this parameter to bind Products to different eVar values for each Product
		 * instead of tying all Products to one eVar value.  This is often used to capture which product category
		 * the visitor used to find the Product.
		 */
		
		private var _category:String;
		private var _product:String;
		private var _quantity:String;
		private var _totalPrice:String;
		private var _incrementor:String;
		private var _merchandising:String;
		
		public function OmnitureProduct (category:String = '', product:String = '', quantity:String = '', totalPrice:String = '', incrementor:String = '', merchandising:String = '')
		{
			_category = category;
			_product = product;
			_quantity = quantity;
			_totalPrice = totalPrice;
			_incrementor = incrementor;
			_merchandising = merchandising;
		}
		
		public function toString ():String
		{
			return _category + ';' + _product + ';' + ((_quantity) ? _quantity : '') + ';' + ((_totalPrice) ? _totalPrice : '') + ';' + ((_incrementor) ? _incrementor : '') + ';' + _merchandising;
		}
		
		public function get merchandising():String { return _merchandising; }
		
		public function set merchandising(value:String):void
		{
			_merchandising = value;
		}
		
		public function get incrementor():String { return _incrementor; }
		
		public function set incrementor(value:String):void
		{
			_incrementor = value;
		}
		
		public function get totalPrice():String { return _totalPrice; }
		
		public function set totalPrice(value:String):void
		{
			_totalPrice = value;
		}
		
		public function get quantity():String { return _quantity; }
		
		public function set quantity(value:String):void
		{
			_quantity = value;
		}
		
		public function get product():String { return _product; }
		
		public function set product(value:String):void
		{
			_product = value;
		}
		
		public function get category():String { return _category; }
		
		public function set category(value:String):void
		{
			_category = value;
		}
	}
}