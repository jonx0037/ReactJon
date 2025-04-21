import React from 'react'
import Header from './Header'
import Footer from './Footer'

interface LayoutProps {
  children: React.ReactNode
}

export default function Layout({ children }: LayoutProps) {
  return (
    <div className="flex min-h-screen flex-col bg-gradient-to-b from-secondary-900 to-secondary-800 text-white">
      <Header />
      <main className="flex-grow">{children}</main>
      <Footer />
    </div>
  )
}