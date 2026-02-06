import { useEffect, useState } from 'react'

type ApiResponse = {
  service: string
  status: string
  hostname: string
  timestamp: string
}

export default function App() {
  const [api, setApi] = useState<ApiResponse | null>(null)

  useEffect(() => {
    fetch('http://api.dqx0')
      .then((r) => r.json())
      .then(setApi)
      .catch(() => setApi(null))
  }, [])

  return (
    <main>
      <h1>dqx0 app</h1>
      <p>Vite + React frontend</p>
      <pre>{JSON.stringify(api, null, 2)}</pre>
    </main>
  )
}
