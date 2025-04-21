import React from 'react'
import Link from 'next/link'

export default function Footer() {
  return (
    <footer className="bg-secondary-900 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="md:flex md:items-center md:justify-between">
          <div className="flex justify-center md:justify-start">
            <Link href="/" className="text-xl font-bold">
              <span className="text-primary-400">React</span>
              <span className="text-white">Jon</span>
            </Link>
          </div>
          <div className="mt-8 md:mt-0">
            <p className="text-center md:text-left text-gray-400">
              &copy; {new Date().getFullYear()} ReactJon. All rights reserved.
            </p>
          </div>
        </div>
      </div>
    </footer>
  )
}