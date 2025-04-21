/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    swcMinify: true,
    images: {
      domains: ['reactjon.dev'], // Updated to your actual domain
      formats: ['image/avif', 'image/webp'],
    },
    // For MDX blog posts
    pageExtensions: ['ts', 'tsx', 'js', 'jsx', 'md', 'mdx'],
  }
  
  module.exports = nextConfig