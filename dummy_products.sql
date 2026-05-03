-- SHOPON'S Dummy Data Insertion Script
-- This script inserts categories, a vendor profile, and 12+ fashion products

-- 1. INSERT CATEGORIES
INSERT INTO categories (name, image_url) VALUES
('Men\'s Clothing', 'https://source.unsplash.com/400x400/?mens-clothing'),
('Women\'s Clothing', 'https://source.unsplash.com/400x400/?womens-clothing'),
('Accessories', 'https://source.unsplash.com/400x400/?accessories'),
('Footwear', 'https://source.unsplash.com/400x400/?shoes');

-- 2. CREATE A VENDOR PROFILE (replace user_id with an actual vendor user)
-- First, you need to create a vendor user in the users table with role='vendor'
-- For now, we'll use a placeholder that you should replace
INSERT INTO vendor_profiles (user_id, store_name, store_logo_url, description, is_approved, rating) 
SELECT id, 'SHOPON\'S Luxury Store', 'https://source.unsplash.com/400x400/?logo', 'Premium fashion and lifestyle products', TRUE, 4.8
FROM users WHERE role = 'vendor' LIMIT 1;

-- Alternative: If no vendor exists, create one first
-- INSERT INTO vendor_profiles (user_id, store_name, store_logo_url, description, is_approved, rating) 
-- VALUES ('vendor-uuid-here', 'SHOPON\'S Luxury Store', 'https://source.unsplash.com/400x400/?logo', 'Premium fashion and lifestyle products', TRUE, 4.8);

-- 3. INSERT PRODUCTS WITH IMAGES
-- Men's Clothing Products

-- Product 1: Classic Black T-Shirt
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Classic Black T-Shirt', 'Premium quality black t-shirt, perfect for everyday wear. Made from 100% organic cotton.', 1200, 50, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Men\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?tshirt,black', true
FROM products p WHERE p.name = 'Classic Black T-Shirt' LIMIT 1;

-- Product 2: Slim Fit Jeans
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Slim Fit Jeans', 'Stylish slim fit jeans with a modern cut. Comfortable stretch fabric for all-day wear.', 2500, 30, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Men\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?jeans', true
FROM products p WHERE p.name = 'Slim Fit Jeans' LIMIT 1;

-- Product 3: Casual Hoodie
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Casual Hoodie', 'Cozy and comfortable hoodie, perfect for casual outings. Soft fleece lining inside.', 3000, 25, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Men\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?hoodie', true
FROM products p WHERE p.name = 'Casual Hoodie' LIMIT 1;

-- Women's Clothing Products

-- Product 4: Floral Summer Dress
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Floral Summer Dress', 'Beautiful floral print summer dress, light and breathable. Perfect for warm weather.', 2800, 40, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Women\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?dress,floral', true
FROM products p WHERE p.name = 'Floral Summer Dress' LIMIT 1;

-- Product 5: High Waist Trousers
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'High Waist Trousers', 'Elegant high waist trousers with a flattering silhouette. Perfect for both casual and formal occasions.', 2200, 35, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Women\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?trousers', true
FROM products p WHERE p.name = 'High Waist Trousers' LIMIT 1;

-- Product 6: Elegant Blouse
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Elegant Blouse', 'Sophisticated blouse with delicate details. Versatile piece for office and casual wear.', 1800, 45, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Women\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?blouse', true
FROM products p WHERE p.name = 'Elegant Blouse' LIMIT 1;

-- Accessories Products

-- Product 7: Leather Belt
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Leather Belt', 'Premium genuine leather belt with adjustable sizing. Classic design that matches any outfit.', 800, 60, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Accessories'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?belt,leather', true
FROM products p WHERE p.name = 'Leather Belt' LIMIT 1;

-- Product 8: Classic Watch
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Classic Watch', 'Timeless stainless steel watch with elegant design. Water-resistant and durable.', 5000, 20, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Accessories'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?watch', true
FROM products p WHERE p.name = 'Classic Watch' LIMIT 1;

-- Product 9: Sunglasses
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Sunglasses', 'Stylish sunglasses with UV protection. Comfortable fit and trendy design.', 1500, 30, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Accessories'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?sunglasses', true
FROM products p WHERE p.name = 'Sunglasses' LIMIT 1;

-- Footwear Products

-- Product 10: White Sneakers
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'White Sneakers', 'Comfortable white sneakers perfect for everyday activities. Durable and stylish.', 4500, 25, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Footwear'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?sneakers,white', true
FROM products p WHERE p.name = 'White Sneakers' LIMIT 1;

-- Product 11: Formal Black Shoes
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Formal Black Shoes', 'Professional black formal shoes. Perfect for office and special occasions.', 3800, 20, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Footwear'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?shoes,black', true
FROM products p WHERE p.name = 'Formal Black Shoes' LIMIT 1;

-- Product 12: Casual Sandals
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Casual Sandals', 'Comfortable casual sandals for warm weather. Lightweight and easy to wear.', 1200, 40, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Footwear'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?sandals', true
FROM products p WHERE p.name = 'Casual Sandals' LIMIT 1;

-- Additional Products for better variety

-- Product 13: Denim Jacket
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Denim Jacket', 'Classic denim jacket, versatile and timeless. Perfect layering piece for any season.', 3500, 22, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Men\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?jacket,denim', true
FROM products p WHERE p.name = 'Denim Jacket' LIMIT 1;

-- Product 14: Silk Scarf
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Silk Scarf', 'Luxurious silk scarf with beautiful patterns. Add elegance to any outfit.', 2000, 35, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Women\'s Clothing'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?scarf,silk', true
FROM products p WHERE p.name = 'Silk Scarf' LIMIT 1;

-- Product 15: Canvas Backpack
INSERT INTO products (vendor_id, category_id, name, description, price, stock, is_active)
SELECT vp.id, c.id, 'Canvas Backpack', 'Durable canvas backpack with multiple compartments. Perfect for travel and daily use.', 2500, 28, true
FROM vendor_profiles vp, categories c 
WHERE vp.store_name = 'SHOPON\'S Luxury Store' AND c.name = 'Accessories'
LIMIT 1;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT p.id, 'https://source.unsplash.com/400x400/?backpack,canvas', true
FROM products p WHERE p.name = 'Canvas Backpack' LIMIT 1;
