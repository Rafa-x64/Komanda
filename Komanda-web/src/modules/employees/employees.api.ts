import { fetchWithAuth } from '../../core/api/auth.api'

export async function fetchEmployees() {
  const res = await fetchWithAuth('/employees')
  return res.data
}

export async function fetchRoles() {
  const res = await fetchWithAuth('/employees/roles')
  return res.data
}

export async function createEmployee(data: any) {
  const res = await fetchWithAuth('/employees', {
    method: 'POST',
    body: JSON.stringify(data)
  })
  return res.data
}

export async function updateEmployee(id: number, data: any) {
  const res = await fetchWithAuth(`/employees/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data)
  })
  return res.data
}

export async function deleteEmployee(id: number) {
  const res = await fetchWithAuth(`/employees/${id}`, {
    method: 'DELETE'
  })
  return res.data
}
