import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const session = ref(null)
  const loading = ref(false)
  const error = ref(null)

  const isAuthenticated = computed(() => !!session.value)
  const isAdmin = computed(() => user.value?.role === 'admin')
  const userRole = computed(() => user.value?.role || null)

  // 1. LOGIN (Sign In)
  const signIn = async (email, password) => {
    loading.value = true
    error.value = null

    try {
      const { data, error: authErr } = await supabase.auth.signInWithPassword({
        email,
        password
      })

      if (authErr) throw authErr

      session.value = data.session

      // Intentar cargar perfil del empleado (puede fallar por RLS)
      try {
        const { data: profile } = await supabase
          .from('employees')
          .select('*')
          .eq('id', data.user.id)
          .single()

        if (profile) {
          user.value = profile
        } else {
          // Si no hay perfil, crear uno básico desde auth metadata
          user.value = {
            id: data.user.id,
            full_name: data.user.user_metadata?.full_name || email.split('@')[0],
            email: email,
            role: data.user.user_metadata?.role || 'barber'
          }
        }
      } catch (profileErr) {
        // Si RLS bloquea, usar datos básicos de auth
        console.warn('No se pudo cargar perfil, usando datos básicos:', profileErr)
        user.value = {
          id: data.user.id,
          full_name: data.user.user_metadata?.full_name || email.split('@')[0],
          email: email,
          role: data.user.user_metadata?.role || 'barber'
        }
      }

      return { success: true, role: user.value?.role }
    } catch (err) {
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  // 2. RECUPERAR CONTRASEÑA
  const resetPassword = async (email) => {
    loading.value = true
    error.value = null

    try {
      const { error: authErr } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/admin/reset-password`
      })

      if (authErr) throw authErr

      return { success: true, message: 'Email de recuperación enviado' }
    } catch (err) {
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  // 3. ACTUALIZAR CONTRASEÑA
  const updatePassword = async (newPassword) => {
    loading.value = true
    error.value = null

    try {
      const { error: authErr } = await supabase.auth.updateUser({
        password: newPassword
      })

      if (authErr) throw authErr

      return { success: true, message: 'Contraseña actualizada' }
    } catch (err) {
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  // 4. VERIFICAR SESIÓN AL CARGAR
  const checkSession = async () => {
    const { data: { session: currentSession } } = await supabase.auth.getSession()

    if (currentSession) {
      session.value = currentSession

      try {
        const { data: profile } = await supabase
          .from('employees')
          .select('*')
          .eq('id', currentSession.user.id)
          .single()

        if (profile) {
          user.value = profile
        } else {
          user.value = {
            id: currentSession.user.id,
            full_name: currentSession.user.user_metadata?.full_name || 'Usuario',
            email: currentSession.user.email,
            role: currentSession.user.user_metadata?.role || 'barber'
          }
        }
      } catch {
        user.value = {
          id: currentSession.user.id,
          full_name: currentSession.user.user_metadata?.full_name || 'Usuario',
          email: currentSession.user.email,
          role: currentSession.user.user_metadata?.role || 'barber'
        }
      }
    }
  }

  // 5. LOGOUT
  const signOut = async () => {
    await supabase.auth.signOut()
    session.value = null
    user.value = null
  }

  return {
    user,
    session,
    loading,
    error,
    isAuthenticated,
    isAdmin,
    userRole,
    signIn,
    resetPassword,
    updatePassword,
    checkSession,
    signOut
  }
})
