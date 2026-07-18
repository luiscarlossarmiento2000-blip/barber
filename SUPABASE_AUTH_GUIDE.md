# 🔐 GUÍA COMPLETA: SUPABASE AUTH

## ¿Qué es Supabase Auth?

Supabase Auth es un servicio de autenticación **GRATUITO** incluido en Supabase. Maneja:
- Registro/Login con email y contraseña
- Magic Links (login sin contraseña)
- OAuth (Google, GitHub, Apple, etc.)
- Recuperación de contraseña
- Sesiones JWT automáticas
- Row Level Security (RLS) integrado

## 💰 ¿Es gratis?

| Plan | Usuarios activos/mes | Costo |
|------|---------------------|-------|
| **Free** | 50,000 MAU | $0 |
| **Pro** | 100,000 MAU | $25/mes |
| Extra MAU | +$0.00325 por usuario | - |

**Para una barbería local, el plan Free es más que suficiente.**

---

## 📋 PASO A PASO: Configurar Supabase Auth

### 1. Activar Auth en tu proyecto Supabase

1. Ve a tu proyecto en [supabase.com](https://supabase.com)
2. Ve a **Authentication** en el menú lateral
3. En **Providers**, asegúrate que **Email** esté habilitado
4. Configura:
   - **Confirm email**: OFF (para desarrollo) o ON (producción)
   - **Secure email change**: ON
   - **Password min length**: 6

### 2. Configurar Email Templates (opcional)

En **Authentication → Email Templates** puedes personalizar:

**Confirm Signup:**
```html
<h2>Confirma tu email</h2>
<p>Haz clic en el siguiente link:</p>
<p><a href="{{ .ConfirmationURL }}">Confirmar cuenta</a></p>
```

**Reset Password:**
```html
<h2>Restablecer contraseña</h2>
<p>Haz clic para crear una nueva contraseña:</p>
<p><a href="{{ .ConfirmationURL }}">Restablecer</a></p>
```

**Magic Link:**
```html
<h2>Link de acceso</h2>
<p>Haz clic para iniciar sesión:</p>
<p><a href="{{ .ConfirmationURL }}">Acceder</a></p>
```

### 3. Configurar URL de redirección

En **Authentication → URL Configuration**:
- **Site URL**: `http://localhost:5173` (dev) o tu dominio de Vercel
- **Redirect URLs**: Agrega `http://localhost:5173/admin/login`

### 4. Crear primer usuario (Admin)

**Opción A: Desde el Dashboard**
1. Ve a **Authentication → Users**
2. Clic en **Add user**
3. Email: `admin@barberia.com`
4. Password: `tu-password-segura`
5. Clic en **Create user**

**Opción B: Desde SQL (para vincular con tabla employees)**
```sql
-- Primero crear el usuario en auth.users (esto lo hace Supabase Auth)
-- Luego insertar en employees:
INSERT INTO employees (id, full_name, email, phone, role, is_active)
VALUES (
  'uuid-del-usuario-auth',  -- Copia el UUID desde Authentication → Users
  'Administrador',
  'admin@barberia.com',
  '0000000000',
  'admin',
  true
);
```

### 5. Row Level Security con auth.uid()

Las políticas RLS ahora usan `auth.uid()` que es el ID del usuario autenticado:

```sql
-- Ejemplo: Solo el admin puede modificar servicios
CREATE POLICY "services_modify_admin" ON services FOR ALL 
USING (EXISTS (
  SELECT 1 FROM employees 
  WHERE id = auth.uid() AND role = 'admin'
));
```

---

## 🔑 MÉTODOS DE AUTENTICACIÓN DISPONIBLES

### Email + Password (el que usamos)
```javascript
// Registro
await supabase.auth.signUp({ email, password })

// Login
await supabase.auth.signInWithPassword({ email, password })

// Logout
await supabase.auth.signOut()

// Recuperar contraseña
await supabase.auth.resetPasswordForEmail(email, {
  redirectTo: 'https://tu-app.com/reset-password'
})

// Actualizar contraseña
await supabase.auth.updateUser({ password: newPassword })
```

### Magic Link (sin contraseña)
```javascript
await supabase.auth.signInWithOtp({ 
  email,
  options: { emailRedirectTo: 'https://tu-app.com/login' }
})
```

### OAuth (Google, GitHub, etc.)
```javascript
await supabase.auth.signInWithOAuth({
  provider: 'google',
  options: { redirectTo: 'https://tu-app.com/login' }
})
```

---

## 🔄 FLUJO DE RECUPERACIÓN DE CONTRASEÑA

1. Usuario hace clic en "¿Olvidaste tu contraseña?"
2. Ingresa su email
3. Supabase envía email con link de recuperación
4. Usuario hace clic en el link del email
5. Redirige a tu app con un token temporal
6. Tu app detecta el token y muestra formulario para nueva contraseña
7. Usuario ingresa nueva contraseña
8. `supabase.auth.updateUser({ password: nueva })`

---

## 🛡️ SEGURIDAD: Variables de entorno

### ¿Por qué no subir .env a GitHub?

- **Las API keys son secretos** - Cualquiera con tu anon key puede leer/escribir en tu DB
- **Supabase tiene límites** - Alguien podría agotar tu cuota
- **RLS puede fallar** - Si expones el service role key, bypass RLS

### Configuración correcta

**1. Archivo `.env` (local, NUNCA en Git)**
```
VITE_SUPABASE_URL=https://abc123.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

**2. Vercel (producción)**
1. Ve a tu proyecto en Vercel
2. **Settings → Environment Variables**
3. Agrega:
   - `VITE_SUPABASE_URL` = tu URL
   - `VITE_SUPABASE_ANON_KEY` = tu anon key
4. Re-deploy

**3. Netlify (producción)**
1. Ve a tu sitio en Netlify
2. **Site settings → Build & deploy → Environment**
3. Agrega las mismas variables

### ⚠️ IMPORTANTE: Vite prefix

Las variables que usas en el frontend con Vite DEBEN empezar con `VITE_`:
```javascript
// ✅ Correcto
const url = import.meta.env.VITE_SUPABASE_URL

// ❌ Incorrecto - No funciona en frontend
const url = import.meta.env.SUPABASE_URL
```

---

## 📁 ESTRUCTURA DE ARCHIVOS DE ENTORNO

```
barberia-app/
├── .env              ← LOCAL, NUNCA en Git (tiene tus secrets)
├── .env.example      ← Template con variables vacías (SÍ en Git)
├── .env.production   ← Variables de producción (opcional, NUNCA en Git)
└── .gitignore        ← Incluye .env, .env.local, .env.*.local
```

---

## 🚀 CHECKLIST DE CONFIGURACIÓN

- [ ] Crear proyecto en Supabase
- [ ] Ejecutar schema.sql en SQL Editor
- [ ] Activar Email provider en Authentication
- [ ] Configurar URL de redirección
- [ ] Personalizar templates de email (opcional)
- [ ] Crear usuario admin desde Dashboard
- [ ] Copiar UUID del usuario admin a tabla employees
- [ ] Crear archivo `.env` local con credenciales
- [ ] Verificar que `.env` está en `.gitignore`
- [ ] Configurar variables en Vercel/Netlify
- [ ] Probar login/logout
- [ ] Probar recuperación de contraseña
