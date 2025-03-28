import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'
import LoginPage from '@/features/authentification/pages/Login'
import SignupPage from '@/features/authentification/pages/Signup'
import HomePage from '@/features/public/pages/Home'
import ContactPage from '@/features/public/pages/Contact'
import PricingPage from '@/features/public/pages/Pricing'

export default function App() {
  return (
    <Router>
      <div>
        <h1>compressify</h1>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignupPage />} />
          <Route path="/" element={<HomePage />} />
          <Route path="/contact" element={<ContactPage />} />
          <Route path="/pricing" element={<PricingPage />} />
        </Routes>
      </div>
    </Router>
  )
}
