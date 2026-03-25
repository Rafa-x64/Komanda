const API_BASE = 'http://localhost:3000/api/v1'

export async function fetchWithAuth(endpoint: string, options: RequestInit = {}) {
  const token = localStorage.getItem('auth_token')
  const headers = {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
    ...options.headers,
  }

  const res = await fetch(`${API_BASE}${endpoint}`, { ...options, headers })
  const contentType = res.headers.get('content-type')
  if (!contentType || !contentType.includes('application/json')) {
      throw new Error('El backend no respondió con JSON')
  }

  const json = await res.json()
  if (!res.ok) {
    if (res.status === 401) {
       // Token expired or invalid
       localStorage.removeItem('auth_token')
       localStorage.removeItem('auth_user')
       localStorage.removeItem('auth_restaurant')
       window.location.href = '/singin' // force redirect to clear reactive states if any
    }
    throw new Error(json.message || 'Error en la petición')
  }
  return json
}
