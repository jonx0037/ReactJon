# ReactJon Website Project Setup

# Create a new Next.js project with TypeScript
npx create-next-app@latest reactjon-website --typescript --tailwind --eslint --app --src-dir

# Navigate to the project directory
cd reactjon-website

# Install additional dependencies
npm install framer-motion react-query @tailwindcss/typography @heroicons/react lucide-react axios next-mdx-remote gray-matter reading-time next-themes

# Development dependencies
npm install -D @types/node @types/react @types/react-dom eslint eslint-config-next prettier eslint-config-prettier eslint-plugin-prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser

# Create core directories
mkdir -p src/components/layout
mkdir -p src/components/ui
mkdir -p src/components/sections
mkdir -p src/hooks
mkdir -p src/lib
mkdir -p src/content/blog
mkdir -p src/content/projects
mkdir -p src/types
mkdir -p public/images

# Create a basic .env.local file
cat > .env.local << EOF
# Environment variables
NEXT_PUBLIC_SITE_URL=https://reactjon.dev
NEXT_PUBLIC_SITE_TITLE=ReactJon - React Development Consultant
NEXT_PUBLIC_SITE_DESCRIPTION=Jon Rocha is a React specialist helping businesses build exceptional web applications with modern React technologies.
EOF

# Create a better TypeScript configuration
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/content/*": ["./src/content/*"],
      "@/types/*": ["./src/types/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# Create a customized tailwind.config.js
cat > tailwind.config.js << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eef2ff',
          100: '#e0e7ff',
          200: '#c7d2fe',
          300: '#a5b4fc',
          400: '#818cf8',
          500: '#6366f1',
          600: '#4f46e5',
          700: '#4338ca',
          800: '#3730a3',
          900: '#312e81',
          950: '#1e1b4b',
        },
        secondary: {
          50: '#f8fafc',
          100: '#f1f5f9',
          200: '#e2e8f0',
          300: '#cbd5e1',
          400: '#94a3b8',
          500: '#64748b',
          600: '#475569',
          700: '#334155',
          800: '#1e293b',
          900: '#0f172a',
          950: '#020617',
        },
      },
      fontFamily: {
        sans: ['var(--font-inter)'],
        mono: ['var(--font-jetbrains-mono)'],
      },
      typography: {
        DEFAULT: {
          css: {
            'code::before': {
              content: '""',
            },
            'code::after': {
              content: '""',
            },
          },
        },
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
}
EOF

# Create a theme provider for dark/light mode
cat > src/components/ThemeProvider.tsx << EOF
'use client'

import { ThemeProvider as NextThemeProvider } from 'next-themes'
import { type ThemeProviderProps } from 'next-themes/dist/types'

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return <NextThemeProvider {...props}>{children}</NextThemeProvider>
}
EOF

# Create a simple layout component
cat > src/components/layout/Layout.tsx << EOF
import React from 'react'
import Header from './Header'
import Footer from './Footer'

interface LayoutProps {
  children: React.ReactNode
}

export default function Layout({ children }: LayoutProps) {
  return (
    <div className="flex min-h-screen flex-col">
      <Header />
      <main className="flex-grow">{children}</main>
      <Footer />
    </div>
  )
}
EOF

# Create a header component
cat > src/components/layout/Header.tsx << EOF
'use client'

import React, { useState } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Menu, X } from 'lucide-react'

const navItems = [
  { name: 'Home', href: '/' },
  { name: 'Services', href: '/services' },
  { name: 'Portfolio', href: '/portfolio' },
  { name: 'Blog', href: '/blog' },
  { name: 'About', href: '/about' },
]

export default function Header() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  const pathname = usePathname()

  return (
    <header className="bg-secondary-900 bg-opacity-50 backdrop-blur-sm fixed w-full z-10">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Link href="/" className="text-xl font-bold">
                <span className="text-primary-400">React</span>
                <span className="text-white">Jon</span>
              </Link>
            </div>
            <div className="hidden md:block">
              <div className="ml-10 flex items-baseline space-x-4">
                {navItems.map((item) => (
                  <Link
                    key={item.name}
                    href={item.href}
                    className={\`px-3 py-2 rounded-md text-sm font-medium \${
                      pathname === item.href
                        ? 'text-white bg-secondary-700'
                        : 'text-gray-300 hover:bg-secondary-700 hover:text-white'
                    }\`}
                  >
                    {item.name}
                  </Link>
                ))}
              </div>
            </div>
          </div>
          <div className="hidden md:block">
            <Link
              href="/contact"
              className="bg-primary-500 hover:bg-primary-600 text-white font-bold py-2 px-4 rounded"
            >
              Hire Me
            </Link>
          </div>
          <div className="md:hidden flex items-center">
            <button
              className="text-gray-300 hover:text-white"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            >
              {mobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile menu */}
      {mobileMenuOpen && (
        <div className="md:hidden bg-secondary-800">
          <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
            {navItems.map((item) => (
              <Link
                key={item.name}
                href={item.href}
                className={\`block px-3 py-2 rounded-md text-base font-medium \${
                  pathname === item.href
                    ? 'text-white bg-secondary-700'
                    : 'text-gray-300 hover:bg-secondary-700 hover:text-white'
                }\`}
                onClick={() => setMobileMenuOpen(false)}
              >
                {item.name}
              </Link>
            ))}
            <Link
              href="/contact"
              className="block px-3 py-2 rounded-md text-base font-medium bg-primary-500 hover:bg-primary-600 text-white text-center mt-4"
              onClick={() => setMobileMenuOpen(false)}
            >
              Hire Me
            </Link>
          </div>
        </div>
      )}
    </header>
  )
}
EOF

# Create a footer component
cat > src/components/layout/Footer.tsx << EOF
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
EOF

# Create button component
cat > src/components/ui/Button.tsx << EOF
import React from 'react'
import Link from 'next/link'

type ButtonProps = {
  children: React.ReactNode
  href?: string
  variant?: 'primary' | 'secondary' | 'outline'
  size?: 'sm' | 'md' | 'lg'
  className?: string
  onClick?: () => void
}

export default function Button({
  children,
  href,
  variant = 'primary',
  size = 'md',
  className = '',
  onClick,
}: ButtonProps) {
  const baseStyles = 'font-bold rounded inline-flex items-center justify-center'
  
  const variantStyles = {
    primary: 'bg-primary-500 hover:bg-primary-600 text-white',
    secondary: 'bg-secondary-700 hover:bg-secondary-600 text-white',
    outline: 'bg-transparent hover:bg-secondary-800 text-white border border-secondary-600',
  }
  
  const sizeStyles = {
    sm: 'py-1 px-3 text-sm',
    md: 'py-2 px-4 text-base',
    lg: 'py-3 px-6 text-lg',
  }
  
  const styles = \`\${baseStyles} \${variantStyles[variant]} \${sizeStyles[size]} \${className}\`
  
  if (href) {
    return (
      <Link href={href} className={styles}>
        {children}
      </Link>
    )
  }
  
  return (
    <button className={styles} onClick={onClick}>
      {children}
    </button>
  )
}
EOF

# Create a section component
cat > src/components/sections/Hero.tsx << EOF
'use client'

import React, { useState } from 'react'
import Button from '../ui/Button'
import { Clipboard, CheckCircle } from 'lucide-react'

export default function Hero() {
  const [copied, setCopied] = useState(false)
  const [code] = useState(\`const ReactJon = () => {
  const [skills, setSkills] = useState([
    'React', 'Next.js', 'TypeScript',
    'Tailwind', 'Node.js'
  ]);
  
  return (
    <Developer
      name="Jon"
      specialty="React"
      available={true}
      passion="Building exceptional UIs"
    />
  );
};\`)

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
            <div className="text-primary-400 font-mono mb-2">const developer = 'React Specialist';</div>
            <h1 className="text-4xl md:text-5xl font-bold mb-4">Building exceptional React experiences</h1>
            <p className="text-xl text-gray-300 mb-8">
              I help businesses create fast, scalable, and beautiful web applications with modern React technologies.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <Button href="/contact" size="lg" variant="primary">
                Get Started
              </Button>
              <Button href="/portfolio" size="lg" variant="secondary">
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
EOF

# Create the app layout
cat > src/app/layout.tsx << EOF
import type { Metadata } from 'next'
import { Inter, JetBrains_Mono } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/ThemeProvider'
import Layout from '@/components/layout/Layout'

const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap'
})

const jetBrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  variable: '--font-jetbrains-mono',
  display: 'swap'
})

export const metadata: Metadata = {
  title: process.env.NEXT_PUBLIC_SITE_TITLE || 'ReactJon',
  description: process.env.NEXT_PUBLIC_SITE_DESCRIPTION || 'React development consultant and specialist',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={\`\${inter.variable} \${jetBrainsMono.variable} font-sans antialiased\`}>
        <ThemeProvider attribute="class" defaultTheme="dark" enableSystem>
          <Layout>
            {children}
          </Layout>
        </ThemeProvider>
      </body>
    </html>
  )
}
EOF

# Create the home page
cat > src/app/page.tsx << EOF
import React from 'react'
import Hero from '@/components/sections/Hero'

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-secondary-900 to-secondary-800 text-white">
      <Hero />
      {/* Add other sections here */}
    </div>
  )
}
EOF

# Create a .gitignore file
cat > .gitignore << EOF
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js
.yarn/install-state.gz

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts
EOF

# Create a README
cat > README.md << EOF
# ReactJon Website

This is the personal website for Jon Rocha, a React development consultant. Built with Next.js, TypeScript, and Tailwind CSS.

## Getting Started

First, run the development server:

\`\`\`bash
npm run dev
# or
yarn dev
# or
pnpm dev
\`\`\`

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Features

- Modern React development with Next.js
- Type safety with TypeScript
- Beautiful styling with Tailwind CSS
- Responsive design for all devices
- Blog with MDX support
- Portfolio showcasing React projects
- Services and contact information

## Deployment

This site is deployed on Namecheap Stellar hosting.
EOF

# Create a blog post utility
cat > src/lib/blog.ts << EOF
import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import readingTime from 'reading-time'

const contentDirectory = path.join(process.cwd(), 'src/content/blog')

export type BlogPost = {
  slug: string
  title: string
  date: string
  excerpt: string
  readingTime: string
  content: string
  [key: string]: any
}

export const getBlogPosts = (): BlogPost[] => {
  const files = fs.readdirSync(contentDirectory)
  
  const posts = files
    .filter((file) => file.endsWith('.mdx'))
    .map((file) => {
      const filePath = path.join(contentDirectory, file)
      const fileContents = fs.readFileSync(filePath, 'utf8')
      const { data, content } = matter(fileContents)
      const slug = file.replace(/\.mdx$/, '')
      const readingTimeResult = readingTime(content)
      
      return {
        slug,
        title: data.title,
        date: data.date,
        excerpt: data.excerpt || '',
        readingTime: readingTimeResult.text,
        content,
        ...data,
      }
    })
    .sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())
  
  return posts
}

export const getBlogPost = (slug: string): BlogPost | null => {
  try {
    const filePath = path.join(contentDirectory, \`\${slug}.mdx\`)
    const fileContents = fs.readFileSync(filePath, 'utf8')
    const { data, content } = matter(fileContents)
    const readingTimeResult = readingTime(content)
    
    return {
      slug,
      title: data.title,
      date: data.date,
      excerpt: data.excerpt || '',
      readingTime: readingTimeResult.text,
      content,
      ...data,
    }
  } catch (error) {
    return null
  }
}
EOF

# Create a sample blog post
mkdir -p src/content/blog
cat > src/content/blog/building-type-safe-react-apps.mdx << EOF
---
title: "Building Type-Safe React Applications with TypeScript"
date: "2025-04-15"
excerpt: "Learn how to leverage TypeScript to create more maintainable and error-resistant React applications."
tags: ["React", "TypeScript", "Web Development"]
---

# Building Type-Safe React Applications with TypeScript

TypeScript has become an essential tool in modern React development, providing type safety, improved developer experience, and better code quality. In this article, we'll explore how to effectively use TypeScript with React to build robust applications.

## Why TypeScript with React?

Using TypeScript with React offers several benefits:

- **Catch errors early**: TypeScript helps catch type-related errors during development rather than at runtime
- **Better IDE support**: Get improved autocompletion, hover information, and refactoring tools
- **Self-documenting code**: Types serve as documentation, making it easier to understand component APIs
- **Safer refactoring**: Change your code with confidence, knowing the type checker has your back

## Setting Up a TypeScript React Project

The easiest way to start a new TypeScript React project is by using Create React App with the TypeScript template:

\`\`\`bash
npx create-react-app my-app --template typescript
\`\`\`

For Next.js projects, you can use:

\`\`\`bash
npx create-next-app@latest my-app --typescript
\`\`\`

## Typing React Components

Let's look at how to type different kinds of React components:

### Function Components

\`\`\`tsx
type ButtonProps = {
  text: string;
  onClick: () => void;
  disabled?: boolean;
};

const Button = ({ text, onClick, disabled = false }: ButtonProps) => {
  return (
    <button onClick={onClick} disabled={disabled}>
      {text}
    </button>
  );
};
\`\`\`

### Children Props

\`\`\`tsx
import { ReactNode } from 'react';

type CardProps = {
  title: string;
  children: ReactNode;
};

const Card = ({ title, children }: CardProps) => {
  return (
    <div className="card">
      <h2>{title}</h2>
      <div>{children}</div>
    </div>
  );
};
\`\`\`

## Typing Hooks

### useState

\`\`\`tsx
const [count, setCount] = useState<number>(0);
\`\`\`

### useReducer

\`\`\`tsx
type State = {
  count: number;
  isLoading: boolean;
};

type Action =
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'setLoading'; payload: boolean };

const reducer = (state: State, action: Action): State => {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + 1 };
    case 'decrement':
      return { ...state, count: state.count - 1 };
    case 'setLoading':
      return { ...state, isLoading: action.payload };
    default:
      return state;
  }
};

// In your component:
const [state, dispatch] = useReducer(reducer, { count: 0, isLoading: false });
\`\`\`

## Best Practices

1. **Create reusable type definitions**: Place shared types in separate files to promote reusability
2. **Use discriminated unions for complex state**: Makes your state handling more predictable
3. **Don't overuse `any`**: It defeats the purpose of using TypeScript
4. **Use type inference where possible**: Let TypeScript figure out types when it can
5. **Create prop interfaces that are specific**: Only include what you need

## Conclusion

TypeScript and React are a powerful combination that can significantly improve your development experience and code quality. By embracing static typing, you'll create more maintainable applications with fewer bugs.

In future articles, we'll explore more advanced TypeScript patterns specifically for React applications.
EOF

# Start the development server
echo "Setup complete! Run 'npm run dev' to start the development server."
