# 🎨 Cómo agregar el logo real de NicoBarber

## Opción 1: Logo como imagen (recomendado)

1. Guarda tu logo como `logo.png` en `public/logo.png`
2. En `HomeView.vue`, reemplaza el div del logo:

```vue
<!-- Reemplaza esto: -->
<div class="w-28 h-28 rounded-2xl bg-gradient-to-br from-[#e94560] to-[#ff6b6b] flex items-center justify-center shadow-2xl shadow-[#e94560]/30 mb-4 mx-auto lg:mx-0">
  <span class="text-5xl">✂️</span>
</div>

<!-- Por esto: -->
<img 
  src="/logo.png" 
  alt="NicoBarber Logo" 
  class="w-28 h-28 object-contain mb-4 mx-auto lg:mx-0 drop-shadow-2xl"
/>
```

## Opción 2: Logo como SVG (mejor calidad)

1. Guarda tu logo como `logo.svg` en `public/logo.svg`
2. Úsalo así:

```vue
<img src="/logo.svg" alt="NicoBarber Logo" class="w-28 h-28 mb-4 mx-auto lg:mx-0"/>
```

## Opción 3: Logo en el Navbar también

En `PublicLayout.vue`, reemplaza el icono ✂️ por tu logo:

```vue
<!-- En PublicLayout.vue, línea del logo -->
<router-link to="/" class="flex items-center gap-3">
  <img src="/logo.png" alt="NicoBarber" class="w-9 h-9 object-contain"/>
  <span class="font-[Playfair_Display] text-xl font-bold">NicoBarber</span>
</router-link>
```

## Opción 4: Logo en el Admin Panel

En `Sidebar.vue`, reemplaza:

```vue
<div class="w-10 h-10 bg-[#e94560] rounded-xl flex items-center justify-center text-xl">
  ✂️
</div>
```

Por:

```vue
<img src="/logo.png" alt="NicoBarber" class="w-10 h-10 object-contain"/>
```

---

## 📁 Estructura recomendada para assets

```
public/
├── logo.png          ← Logo principal (recomendado 512x512)
├── logo-white.png    ← Versión blanca para fondos oscuros
├── favicon.ico       ← Icono del navegador
└── images/
    ├── hero.jpg      ← Foto del local/barbero
    ├── barber-1.jpg  ← Fotos de servicios
    └── products/     ← Fotos de productos
```

## 🎨 Colores de marca sugeridos para NicoBarber

Si quieres personalizar los colores, edita `src/assets/styles/variables.css`:

```css
:root {
  --primary-color: #1a1a2e;     /* Fondo oscuro */
  --secondary-color: #c9a227;    /* Dorado (elegante) */
  --accent-color: #d4af37;       /* Dorado brillante */
  /* ... */
}
```

O si prefieres los colores actuales (rosa/coral):
```css
--secondary-color: #e94560;  /* Coral */
--accent-color: #42b883;     /* Verde menta */
```
