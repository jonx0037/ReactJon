'use client'

import React, { useState } from 'react'
import Button from '../ui/Button'
import { Clipboard, CheckCircle } from 'lucide-react'

export default function Hero() {
  const [copied, setCopied] = useState(false)
  const [code] = useState(`const ReactJon = () => {
  const [skills, setSkills] = useState([
    'React', 'Next.js', 'TypeScript',
    'Tailwind', 'Data Science'
  ]);
  
  return (
    <Developer
      name="Jon"
      specialty="React & Data Science"
      available={true}
      passion="Building exceptional applications"
    />
  );
};`)

  const handleCopy = () => {
    navigator.clipboard.writeText(code)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <div className="pt-24 pb-12 md:pt-32 md:pb-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <div className="text-primary-400 font-mono mb-2">const developer = 'React & Data Science Specialist';</div>
            <h1 className="text-4xl md:text-5xl font-bold mb-4">Building exceptional React experiences</h1>
            <p className="text-xl text-gray-300 mb-8">
              I help businesses create fast, scalable, and beautiful web applications with modern React technologies and data science integration.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <Button href="/contact" size="lg" variant="primary">
                Get Started
              </Button>
              <Button href="/projects" size="lg" variant="secondary">
                View My Work
              </Button>
            </div>
          </div>
          <div className="relative">
            <div className="bg-secondary-800 rounded-lg shadow-xl p-4 font-mono text-sm text-gray-300 relative">
              <div className="absolute top-4 right-4 flex space-x-2">
                <button 
                  onClick={handleCopy} 
                  className="text-gray-400 hover:text-white"
                  aria-label="Copy code"
                >
                  {copied ? <CheckCircle size={20} className="text-green-400" /> : <Clipboard size={20} />}
                </button>
              </div>
              <pre className="overflow-x-auto">
                {code}
              </pre>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}