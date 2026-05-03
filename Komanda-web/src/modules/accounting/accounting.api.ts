import { fetchWithAuth } from '../../core/api/auth.api'

export interface Account {
  id: string
  name: string
  balance: number
  children?: Account[]
}

export interface BalanceSheetData {
  assets: Account[]
  liabilities: Account[]
  equity: Account[]
  totals: {
    assets: number
    liabilities: number
    equity: number
  }
}

export async function fetchBalanceSheet(dateFrom?: string, dateTo?: string): Promise<BalanceSheetData> {
  let url = '/accounting/balance-sheet'
  const params = new URLSearchParams()
  if (dateFrom) params.append('dateFrom', dateFrom)
  if (dateTo) params.append('dateTo', dateTo)
  
  if (params.toString()) url += `?${params.toString()}`

  const res = await fetchWithAuth(url)
  return res.data
}
