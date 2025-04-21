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
  tags?: string[]
  [key: string]: any
}

export const getBlogPosts = (): BlogPost[] => {
  // Ensure the directory exists
  if (!fs.existsSync(contentDirectory)) {
    return []
  }
  
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
        tags: data.tags || [],
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
    const filePath = path.join(contentDirectory, `${slug}.mdx`)
    const fileContents = fs.readFileSync(filePath, 'utf8')
    const { data, content } = matter(fileContents)
    const readingTimeResult = readingTime(content)
    
    return {
      slug,
      title: data.title,
      date: data.date,
      excerpt: data.excerpt || '',
      tags: data.tags || [],
      readingTime: readingTimeResult.text,
      content,
      ...data,
    }
  } catch (error) {
    return null
  }
}