import { useState, useEffect } from 'react'

function App() {
  const [apiStatus, setApiStatus] = useState<string>('Checking...')

  useEffect(() => {
    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000'

    fetch(`${apiUrl}/health`)
      .then((res) => res.json())
      .then((data) => {
        setApiStatus(`Connected - ${data.status}`)
      })
      .catch(() => {
        setApiStatus('Disconnected')
      })
  }, [])

  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-md max-w-md w-full">
        <h1 className="text-3xl font-bold text-gray-800 mb-4">
          Construction Manager
        </h1>
        <p className="text-gray-600 mb-4">
          ERP System for Construction Management
        </p>
        <div className="border-t pt-4">
          <p className="text-sm text-gray-500">
            API Status: <span className="font-semibold">{apiStatus}</span>
          </p>
        </div>
      </div>
    </div>
  )
}

export default App
