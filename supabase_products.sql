-- Dummy Data Script for SHOPON'S Products
-- Make sure to replace 'YOUR_VENDOR_ID' and category IDs with actual IDs from your database if they are foreign keys.
-- Assuming 'gen_random_uuid()' is available in PostgreSQL

-- 1. Insert Categories (assuming you need them or matching IDs)
-- INSERT INTO categories (id, name) VALUES 
--   ('cat_men', 'Men''s Clothing'),
--   ('cat_women', 'Women''s Clothing'),
--   ('cat_acc', 'Accessories'),
--   ('cat_shoes', 'Footwear')
-- ON CONFLICT (id) DO NOTHING;

-- 2. Insert Products
DO $$
DECLARE
    p_id_1 UUID := gen_random_uuid();
    p_id_2 UUID := gen_random_uuid();
    p_id_3 UUID := gen_random_uuid();
    p_id_4 UUID := gen_random_uuid();
    p_id_5 UUID := gen_random_uuid();
    p_id_6 UUID := gen_random_uuid();
    p_id_7 UUID := gen_random_uuid();
    p_id_8 UUID := gen_random_uuid();
    p_id_9 UUID := gen_random_uuid();
    p_id_10 UUID := gen_random_uuid();
    p_id_11 UUID := gen_random_uuid();
    p_id_12 UUID := gen_random_uuid();
BEGIN
    INSERT INTO products (id, name, description, price, stock, vendor_id, category_id, is_active)
    VALUES 
    -- Men's Clothing
    (p_id_1, 'Classic Black T-Shirt', 'Premium cotton classic fit t-shirt.', 1200, 50, 'vendor-001', 'cat_men', true),
    (p_id_2, 'Slim Fit Jeans', 'Comfortable stretch denim jeans.', 2500, 30, 'vendor-001', 'cat_men', true),
    (p_id_3, 'Casual Hoodie', 'Warm and cozy hoodie for everyday wear.', 3000, 25, 'vendor-001', 'cat_men', true),
    
    -- Women's Clothing
    (p_id_4, 'Floral Summer Dress', 'Lightweight floral dress perfect for summer.', 2800, 40, 'vendor-001', 'cat_women', true),
    (p_id_5, 'High Waist Trousers', 'Elegant high waist trousers for work or casual.', 2200, 35, 'vendor-001', 'cat_women', true),
    (p_id_6, 'Elegant Blouse', 'Silk blend elegant blouse for evening wear.', 1800, 45, 'vendor-001', 'cat_women', true),
    
    -- Accessories
    (p_id_7, 'Leather Belt', 'Genuine leather adjustable belt.', 800, 60, 'vendor-001', 'cat_acc', true),
    (p_id_8, 'Classic Watch', 'Stainless steel classic analog watch.', 5000, 20, 'vendor-001', 'cat_acc', true),
    (p_id_9, 'Sunglasses', 'UV protection premium sunglasses.', 1500, 30, 'vendor-001', 'cat_acc', true),
    
    -- Footwear
    (p_id_10, 'White Sneakers', 'Comfortable and stylish white sneakers.', 4500, 25, 'vendor-001', 'cat_shoes', true),
    (p_id_11, 'Formal Black Shoes', 'Classic leather formal shoes.', 3800, 20, 'vendor-001', 'cat_shoes', true),
    (p_id_12, 'Casual Sandals', 'Lightweight summer sandals.', 1200, 40, 'vendor-001', 'cat_shoes', true);

    -- 3. Insert Product Images
    INSERT INTO product_images (product_id, image_url)
    VALUES
    (p_id_1, 'https://source.unsplash.com/400x400/?tshirt'),
    (p_id_2, 'https://source.unsplash.com/400x400/?jeans'),
    (p_id_3, 'https://source.unsplash.com/400x400/?hoodie'),
    (p_id_4, 'https://source.unsplash.com/400x400/?dress'),
    (p_id_5, 'https://source.unsplash.com/400x400/?trousers'),
    (p_id_6, 'https://source.unsplash.com/400x400/?blouse'),
    (p_id_7, 'https://source.unsplash.com/400x400/?belt'),
    (p_id_8, 'https://source.unsplash.com/400x400/?watch'),
    (p_id_9, 'https://source.unsplash.com/400x400/?sunglasses'),
    (p_id_10, 'https://source.unsplash.com/400x400/?sneakers'),
    (p_id_11, 'https://source.unsplash.com/400x400/?shoes'),
    (p_id_12, 'https://source.unsplash.com/400x400/?sandals');
END $$;
