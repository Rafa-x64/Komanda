import { fetchWithAuth } from '../../core/api/auth.api'

export async function fetchVBalanceGeneral(dateFrom?: string, dateTo?: string): Promise<any[]> {
  let url = '/accounting/v-balance-general'
  const params = new URLSearchParams()
  if (dateFrom) params.append('dateFrom', dateFrom)
  if (dateTo) params.append('dateTo', dateTo)
  
  if (params.toString()) url += `?${params.toString()}`

  const res = await fetchWithAuth(url)
  return res.data
}

export async function fetchVEstadoResultados(dateFrom?: string, dateTo?: string): Promise<any[]> {
  let url = '/accounting/v-estado-resultados'
  const params = new URLSearchParams()
  if (dateFrom) params.append('dateFrom', dateFrom)
  if (dateTo) params.append('dateTo', dateTo)
  
  if (params.toString()) url += `?${params.toString()}`

  const res = await fetchWithAuth(url)
  return res.data
}

export async function fetchJournalEntries(dateFrom?: string, dateTo?: string): Promise<any[]> {
  let url = '/accounting/journal-entries'
  const params = new URLSearchParams()
  if (dateFrom) params.append('dateFrom', dateFrom)
  if (dateTo) params.append('dateTo', dateTo)
  
  if (params.toString()) url += `?${params.toString()}`

  const res = await fetchWithAuth(url)
  return res.data
}
