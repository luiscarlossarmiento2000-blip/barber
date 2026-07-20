-- ============================================================
-- SISTEMA DE GESTIÓN PARA BARBERÍA v3
-- SCHEMA CORREGIDO - Sin RLS recursivo
-- ============================================================

-- 1. TABLA DE SERVICIOS
CREATE TABLE IF NOT EXISTS services (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 30,
  category TEXT NOT NULL DEFAULT 'hair',
  color TEXT DEFAULT '#42b883',
  icon TEXT DEFAULT 'scissors',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. TABLA DE EMPLEADOS (vinculada a auth.users de Supabase)
CREATE TABLE IF NOT EXISTS employees (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  role TEXT NOT NULL DEFAULT 'barber',
  avatar_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. TABLA DE CLIENTES (Sin auth requerida)
CREATE TABLE IF NOT EXISTS clients (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  notes TEXT,
  visit_count INTEGER DEFAULT 0,
  last_visit TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_clients_phone ON clients(phone);

-- 4. TABLA DE PRODUCTOS
CREATE TABLE IF NOT EXISTS products (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  cost DECIMAL(10,2) DEFAULT 0,
  stock INTEGER NOT NULL DEFAULT 0,
  category TEXT NOT NULL DEFAULT 'haircare',
  brand TEXT,
  image_url TEXT,
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. TABLA DE CITAS
CREATE TABLE IF NOT EXISTS appointments (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id uuid REFERENCES clients(id) ON DELETE CASCADE,
  employee_id uuid REFERENCES employees(id) ON DELETE SET NULL,
  service_id uuid REFERENCES services(id) ON DELETE RESTRICT,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. TABLA DE TRANSACCIONES
CREATE TABLE IF NOT EXISTS transactions (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  type TEXT NOT NULL,
  category TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  description TEXT,
  appointment_id uuid REFERENCES appointments(id) ON DELETE SET NULL,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  employee_id uuid REFERENCES employees(id) ON DELETE SET NULL,
  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. TABLA DE CONFIGURACIÓN
CREATE TABLE IF NOT EXISTS business_settings (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  business_name TEXT NOT NULL DEFAULT 'Mi Barbería',
  logo_url TEXT,
  primary_color TEXT DEFAULT '#1a1a2e',
  secondary_color TEXT DEFAULT '#e94560',
  accent_color TEXT DEFAULT '#42b883',
  phone TEXT,
  address TEXT,
  opening_time TIME DEFAULT '09:00',
  closing_time TIME DEFAULT '20:00',
  days_open INTEGER[] DEFAULT '{1,2,3,4,5,6}',
  slot_duration INTEGER DEFAULT 30,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ============================================================
-- ELIMINAR POLÍTICAS ANTIGUAS SI EXISTEN
-- ============================================================
DROP POLICY IF EXISTS "services_select_all" ON services;
DROP POLICY IF EXISTS "services_modify_admin" ON services;
DROP POLICY IF EXISTS "employees_select_active" ON employees;
DROP POLICY IF EXISTS "employees_modify_admin" ON employees;
DROP POLICY IF EXISTS "clients_all" ON clients;
DROP POLICY IF EXISTS "products_select_all" ON products;
DROP POLICY IF EXISTS "products_modify_admin" ON products;
DROP POLICY IF EXISTS "appointments_select_all" ON appointments;
DROP POLICY IF EXISTS "appointments_insert_all" ON appointments;
DROP POLICY IF EXISTS "appointments_update_employee" ON appointments;
DROP POLICY IF EXISTS "appointments_delete_admin" ON appointments;
DROP POLICY IF EXISTS "transactions_select_all" ON transactions;
DROP POLICY IF EXISTS "transactions_modify_admin" ON transactions;
DROP POLICY IF EXISTS "settings_select_all" ON business_settings;
DROP POLICY IF EXISTS "settings_modify_admin" ON business_settings;

-- ============================================================
-- POLÍTICAS RLS CORREGIDAS - Sin recursión
-- ============================================================

-- Deshabilitar RLS temporalmente para insertar datos
ALTER TABLE services DISABLE ROW LEVEL SECURITY;
ALTER TABLE employees DISABLE ROW LEVEL SECURITY;
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
ALTER TABLE appointments DISABLE ROW LEVEL SECURITY;
ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE business_settings DISABLE ROW LEVEL SECURITY;

-- ============================================================
-- DATOS INICIALES
-- ============================================================

-- Servicios por defecto
INSERT INTO services (name, description, price, duration_minutes, category, color, icon) VALUES
('Corte Clásico', 'Corte de cabello tradicional con tijera y máquina', 15.00, 30, 'hair', '#42b883', 'scissors'),
('Corte Moderno', 'Corte con diseño y fade', 20.00, 45, 'hair', '#3498db', 'scissors'),
('Afeitado Clásico', 'Afeitado con navaja y toalla caliente', 12.00, 30, 'beard', '#e74c3c', 'razor'),
('Arreglo de Barba', 'Delineado y mantenimiento de barba', 10.00, 20, 'beard', '#9b59b6', 'razor'),
('Manicure Hombre', 'Limpieza y arreglo de uñas', 8.00, 25, 'nails', '#f39c12', 'hand'),
('Manicure Completo', 'Manicure con esmaltado', 15.00, 45, 'nails', '#e91e63', 'hand'),
('Facial', 'Limpieza facial básica', 18.00, 40, 'facial', '#00bcd4', 'face'),
('Corte + Barba', 'Paquete completo corte y barba', 25.00, 60, 'hair', '#ff5722', 'scissors')
ON CONFLICT DO NOTHING;

-- Productos iniciales
INSERT INTO products (name, description, price, cost, stock, category, brand, is_featured) VALUES
('Pomada Matte', 'Pomada de acabado mate para cabello', 12.99, 6.50, 25, 'haircare', 'American Crew', true),
('Cera para Barba', 'Cera moldeadora para barba', 15.99, 8.00, 18, 'beard', 'Beardbrand', true),
('Shampoo Anticaspa', 'Shampoo especializado anticaspa', 18.50, 9.25, 30, 'haircare', 'Head & Shoulders', false),
('Aceite para Barba', 'Aceite hidratante para barba', 22.00, 11.00, 12, 'beard', 'Honest Amish', true),
('Gel Fijador', 'Gel de máxima fijación', 9.99, 4.50, 40, 'haircare', 'Got2b', false),
('Tijeras Profesionales', 'Tijeras de corte profesional 6.5"', 45.00, 22.50, 8, 'tools', 'Jaguar', false),
('Peine de Carbono', 'Peine antiestático de carbono', 8.99, 4.00, 50, 'tools', 'Kent', false),
('Bálsamo Labial', 'Hidratante labial para hombre', 5.99, 2.50, 60, 'skincare', 'Burt''s Bees', false),
('Crema Facial', 'Crema hidratante facial', 24.99, 12.50, 15, 'skincare', 'L''Oreal Men', true),
('Desodorante Natural', 'Desodorante sin aluminio', 11.99, 6.00, 35, 'skincare', 'Native', false)
ON CONFLICT DO NOTHING;

-- Configuración inicial
INSERT INTO business_settings (business_name) VALUES ('NicoBarber')
ON CONFLICT DO NOTHING;

-- ============================================================
-- HABILITAR RLS CON POLÍTICAS SIMPLES (sin recursión)
-- ============================================================

-- Services: lectura pública, modificación solo con auth
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "services_select_all" ON services FOR SELECT USING (true);
CREATE POLICY "services_insert_auth" ON services FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "services_update_auth" ON services FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "services_delete_auth" ON services FOR DELETE USING (auth.role() = 'authenticated');

-- Employees: lectura pública solo activos
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
CREATE POLICY "employees_select_active" ON employees FOR SELECT USING (is_active = true);
CREATE POLICY "employees_insert_auth" ON employees FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "employees_update_auth" ON employees FOR UPDATE USING (auth.role() = 'authenticated');

-- Clients: todo público
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "clients_all" ON clients FOR ALL USING (true);

-- Products: lectura pública
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "products_select_all" ON products FOR SELECT USING (true);
CREATE POLICY "products_insert_auth" ON products FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "products_update_auth" ON products FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "products_delete_auth" ON products FOR DELETE USING (auth.role() = 'authenticated');

-- Appointments: lectura pública, inserción pública, update/delete con auth
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "appointments_select_all" ON appointments FOR SELECT USING (true);
CREATE POLICY "appointments_insert_all" ON appointments FOR INSERT WITH CHECK (true);
CREATE POLICY "appointments_update_auth" ON appointments FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "appointments_delete_auth" ON appointments FOR DELETE USING (auth.role() = 'authenticated');

-- Transactions: lectura pública, modificación con auth
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "transactions_select_all" ON transactions FOR SELECT USING (true);
CREATE POLICY "transactions_insert_auth" ON transactions FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "transactions_update_auth" ON transactions FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "transactions_delete_auth" ON transactions FOR DELETE USING (auth.role() = 'authenticated');

-- Settings: lectura pública, modificación con auth
ALTER TABLE business_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "settings_select_all" ON business_settings FOR SELECT USING (true);
CREATE POLICY "settings_insert_auth" ON business_settings FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "settings_update_auth" ON business_settings FOR UPDATE USING (auth.role() = 'authenticated');
