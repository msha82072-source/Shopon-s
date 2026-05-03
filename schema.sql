-- SQL Migration for ANTIGRAVITY Multi-vendor Marketplace

-- 1. Create Enums
CREATE TYPE user_role AS ENUM ('customer', 'vendor', 'admin');
CREATE TYPE order_status AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');

-- 2. Users Table (extends Supabase Auth)
CREATE TABLE users (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    role user_role DEFAULT 'customer',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Vendor Profiles
CREATE TABLE vendor_profiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    store_name TEXT NOT NULL,
    store_logo_url TEXT,
    description TEXT,
    is_approved BOOLEAN DEFAULT FALSE,
    rating FLOAT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Categories
CREATE TABLE categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id UUID REFERENCES categories(id),
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Products
CREATE TABLE products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    vendor_id UUID REFERENCES vendor_profiles(id) ON DELETE CASCADE NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Product Variants
CREATE TABLE product_variants (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    size TEXT,
    color TEXT,
    stock INTEGER DEFAULT 0
);

-- 7. Product Images
CREATE TABLE product_images (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    image_url TEXT NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE
);

-- 8. Addresses
CREATE TABLE addresses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    label TEXT, -- Home / Work
    full_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    city TEXT NOT NULL,
    street TEXT NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 9. Cart
CREATE TABLE cart (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 10. Favorites (Wishlist)
CREATE TABLE favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    UNIQUE(user_id, product_id)
);

-- 11. Orders
CREATE TABLE orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    vendor_id UUID REFERENCES vendor_profiles(id) NOT NULL,
    address_id UUID REFERENCES addresses(id) NOT NULL,
    status order_status DEFAULT 'pending',
    payment_method TEXT NOT NULL, -- cod / online
    total_amount NUMERIC NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 12. Order Items
CREATE TABLE order_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL,
    price_at_purchase NUMERIC NOT NULL
);

-- 13. Reviews
CREATE TABLE reviews (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    image_url TEXT,
    vendor_reply TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- RLS POLICIES --

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Users can read their own profile
CREATE POLICY "Users can read own record" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own record" ON users FOR UPDATE USING (auth.uid() = id);

-- Vendor profiles
CREATE POLICY "Public can view active vendors" ON vendor_profiles FOR SELECT USING (is_approved = TRUE);
CREATE POLICY "Vendors can update own profile" ON vendor_profiles FOR UPDATE USING (auth.uid() = user_id);

-- Categories are public
CREATE POLICY "Everyone can view categories" ON categories FOR SELECT TO PUBLIC USING (TRUE);

-- Products
CREATE POLICY "Everyone can view active products" ON products FOR SELECT USING (is_active = TRUE);
CREATE POLICY "Vendors can manage own products" ON products FOR ALL USING (
    EXISTS (SELECT 1 FROM vendor_profiles WHERE user_id = auth.uid() AND id = vendor_id)
);

-- Product variants & images
CREATE POLICY "Everyone can view variants" ON product_variants FOR SELECT USING (TRUE);
CREATE POLICY "Everyone can view images" ON product_images FOR SELECT USING (TRUE);

-- Addresses
CREATE POLICY "Users can manage own addresses" ON addresses FOR ALL USING (auth.uid() = user_id);

-- Cart
CREATE POLICY "Users can manage own cart" ON cart FOR ALL USING (auth.uid() = user_id);

-- Favorites
CREATE POLICY "Users can manage own favorites" ON favorites FOR ALL USING (auth.uid() = user_id);

-- Orders
CREATE POLICY "Customers can see own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Vendors can see their orders" ON orders FOR SELECT USING (
    EXISTS (SELECT 1 FROM vendor_profiles WHERE user_id = auth.uid() AND id = vendor_id)
);
CREATE POLICY "Customers can create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Order Items
CREATE POLICY "Users can see own order items" ON order_items FOR SELECT USING (
    EXISTS (SELECT 1 FROM orders WHERE id = order_id AND (user_id = auth.uid() OR 
    EXISTS (SELECT 1 FROM vendor_profiles WHERE user_id = auth.uid() AND id = orders.vendor_id)))
);

-- Reviews
CREATE POLICY "Everyone can see reviews" ON reviews FOR SELECT USING (TRUE);
CREATE POLICY "Customers can leave reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Vendors can reply to reviews" ON reviews FOR UPDATE USING (
    EXISTS (SELECT 1 FROM products p JOIN vendor_profiles v ON p.vendor_id = v.id WHERE p.id = product_id AND v.user_id = auth.uid())
);
