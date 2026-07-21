-- ============================================================
-- SISTEMA DE GESTIÓN PARA BARBERÍA v2
-- CON SUPABASE AUTH + PRODUCTOS
-- ============================================================

-- 1. TABLA DE SERVICIOS
CREATE TABLE services (
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
CREATE TABLE employees (
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
CREATE TABLE clients (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  notes TEXT,
  visit_count INTEGER DEFAULT 0,
  last_visit TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE UNIQUE INDEX idx_clients_phone ON clients(phone);

-- 4. TABLA DE PRODUCTOS (NUEVO)
CREATE TABLE products (
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
CREATE TABLE appointments (
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
CREATE TABLE transactions (
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
CREATE TABLE business_settings (
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
-- DATOS INICIALES
-- ============================================================

INSERT INTO services (name, description, price, duration_minutes, category, color, icon) VALUES
('Corte Clásico', 'Corte de cabello tradicional con tijera y máquina', 15.00, 30, 'hair', '#42b883', 'scissors'),
('Corte Moderno', 'Corte con diseño y fade', 20.00, 45, 'hair', '#3498db', 'scissors'),
('Afeitado Clásico', 'Afeitado con navaja y toalla caliente', 12.00, 30, 'beard', '#e74c3c', 'razor'),
('Arreglo de Barba', 'Delineado y mantenimiento de barba', 10.00, 20, 'beard', '#9b59b6', 'razor'),
('Manicure Hombre', 'Limpieza y arreglo de uñas', 8.00, 25, 'nails', '#f39c12', 'hand'),
('Manicure Completo', 'Manicure con esmaltado', 15.00, 45, 'nails', '#e91e63', 'hand'),
('Facial', 'Limpieza facial básica', 18.00, 40, 'facial', '#00bcd4', 'face'),
('Corte + Barba', 'Paquete completo corte y barba', 25.00, 60, 'hair', '#ff5722', 'scissors');

-- Productos iniciales
INSERT INTO products (name, description, price, cost, stock, category, brand, is_featured) VALUES
('Pomada Matte', 'Pomada de acabado mate para cabello', 12.99, 6.50, 25, 'haircare', 'American Crew', true),
('Cera para Barba', 'Cera moldeadora para barba', 15.99, 8.00, 18, 'beard', 'Beardbrand', true),
('Shampoo Anticaspa', 'Shampoo especializado anticaspa', 18.50, 9.25, 30, 'haircare', 'Head & Shoulders', false),
('Aceite para Barba', 'Aceite hidratante para barba', 22.00, 11.00, 12, 'beard', 'Honest Amish', true),
('Gel Fijador', 'Gel de máxima fijación', 9.99, 4.50, 40, 'haircare', 'Got2b', false),
('Tijeras Profesionales', 'Tijeras de corte profesional 6.5"', 45.00, 22.50, 8, 'tools', 'Jaguar', false),
('Peine de Carbono', 'Peine antiestático de carbono', 8.99, 4.00, 50, 'tools', 'Kent', false),
('Bálsamo Labial', 'Hidratante labial para hombre', 5.99, 2.50, 60, 'skincare', 'Burt's Bees', false),
('Crema Facial', 'Crema hidratante facial', 24.99, 12.50, 15, 'skincare', 'L'Oreal Men', true),
('Desodorante Natural', 'Desodorante sin aluminio', 11.99, 6.00, 35, 'skincare', 'Native', false);

INSERT INTO business_settings (business_name) VALUES ('Mi Barbería');

-- ============================================================
-- POLÍTICAS DE SEGURIDAD (RLS)
-- ============================================================

ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_settings ENABLE ROW LEVEL SECURITY;

-- Servicios: todos pueden ver, solo admin puede modificar
CREATE POLICY "services_select_all" ON services FOR SELECT USING (true);
CREATE POLICY "services_modify_admin" ON services FOR ALL 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'admin'));

-- Empleados: todos pueden ver activos, solo admin puede modificar
CREATE POLICY "employees_select_active" ON employees FOR SELECT USING (is_active = true);
CREATE POLICY "employees_modify_admin" ON employees FOR ALL 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'admin'));

-- Clientes: todos pueden ver y crear
CREATE POLICY "clients_all" ON clients FOR ALL USING (true);

-- Productos: todos pueden ver, solo admin puede modificar
CREATE POLICY "products_select_all" ON products FOR SELECT USING (true);
CREATE POLICY "products_modify_admin" ON products FOR ALL 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'admin'));

-- Citas: todos pueden ver y crear, empleados pueden actualizar
CREATE POLICY "appointments_select_all" ON appointments FOR SELECT USING (true);
CREATE POLICY "appointments_insert_all" ON appointments FOR INSERT WITH CHECK (true);
CREATE POLICY "appointments_update_employee" ON appointments FOR UPDATE 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid()));
CREATE POLICY "appointments_delete_admin" ON appointments FOR DELETE 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'admin'));

-- Transacciones: todos pueden ver, solo admin puede modificar
CREATE POLICY "transactions_select_all" ON transactions FOR SELECT USING (true);
CREATE POLICY "transactions_modify_admin" ON transactions FOR ALL 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'admin'));

-- Configuración: todos pueden ver, solo admin puede modificar
CREATE POLICY "settings_select_all" ON business_settings FOR SELECT USING (true);
CREATE POLICY "settings_modify_admin" ON business_settings FOR ALL 
  USING (EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'admin'));
