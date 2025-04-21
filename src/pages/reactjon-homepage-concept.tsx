import React, { useState, useEffect } from 'react';
import { Code, Clipboard, CheckCircle, ChevronRight, Coffee, Globe, Server, Database, Clock, Users, BarChart, Activity } from 'lucide-react';
import { Link } from 'react-router-dom';

const HomePage = () => {
  const [copied, setCopied] = useState(false);
  const [code] = useState(`const ReactJon = () => {
  const [skills, setSkills] = useState([
    'React', 'Next.js', 'TypeScript',
    'Tailwind', 'Data Visualization',
    'Machine Learning'
  ]);
  
  return (
    <Developer
      name="Jon"
      specialty="React & Data Science"
      available={true}
      passion="Building exceptional applications"
    />
  );
};`);

  const handleCopy = () => {
    navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };
  
  return (
    <div className="min-h-screen bg-gradient-to-b from-slate-900 to-slate-800 text-white">
      {/* Navigation */}
      <nav className="bg-slate-800 bg-opacity-50 backdrop-blur-sm fixed w-full z-10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <span className="text-xl font-bold text-blue-400">React<span className="text-white">Jon</span></span>
              </div>
              <div className="hidden md:block">
                <div className="ml-10 flex items-baseline space-x-4">
                  <a href="/" className="px-3 py-2 rounded-md text-sm font-medium text-white bg-slate-700">Home</a>
                  <a href="/services" className="px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:bg-slate-700 hover:text-white">Services</a>
                  <a href="/projects" className="px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:bg-slate-700 hover:text-white">Projects</a>
                  <a href="/blog" className="px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:bg-slate-700 hover:text-white">Blog</a>
                  <a href="/about" className="px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:bg-slate-700 hover:text-white">About</a>
                </div>
              </div>
            </div>
            <div>
              <a href="/contact" className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded">
                Hire Me
              </a>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <div className="pt-24 pb-12 md:pt-32 md:pb-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <div className="text-blue-400 font-mono mb-2">const developer = 'React & Data Science Specialist';</div>
              <h1 className="text-4xl md:text-5xl font-bold mb-4">Building exceptional React experiences</h1>
              <p className="text-xl text-gray-300 mb-8">
                I help businesses create fast, scalable, and beautiful web applications with modern React technologies and data science integration.
              </p>
              <div className="flex flex-col sm:flex-row gap-4">
                <a href="/contact" className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-md text-center">
                  Get Started
                </a>
                <a href="/projects" className="bg-slate-700 hover:bg-slate-600 text-white font-bold py-3 px-6 rounded-md text-center">
                  View My Work
                </a>
              </div>
            </div>
            <div className="relative">
              <div className="bg-slate-800 rounded-lg shadow-xl p-4 font-mono text-sm text-gray-300 relative">
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

      {/* Services Section */}
      <div className="py-16 bg-slate-800 bg-opacity-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">My Services</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Specialized development services to help you build better applications with React and data science.
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <ServiceCard 
              icon={<Code />}
              title="React Application Development"
              description="Custom React applications built with modern best practices, from simple websites to complex web applications."
              link="/services/react-development"
            />
            <ServiceCard 
              icon={<BarChart />}
              title="Data Visualization Solutions"
              description="Interactive dashboards and data visualization tools that transform complex data into actionable insights."
              link="/services/data-visualization"
            />
            <ServiceCard 
              icon={<Activity />}
              title="Machine Learning Integration"
              description="Seamless integration of machine learning models into web applications for predictive analytics."
              link="/services/machine-learning"
            />
            <ServiceCard 
              icon={<Server />}
              title="Web Application Optimization"
              description="Performance and accessibility optimization for existing web applications to improve user experience."
              link="/services/optimization"
            />
            <ServiceCard 
              icon={<Database />}
              title="Component Library Development"
              description="Custom React component libraries and design systems that ensure consistency and accelerate development."
              link="/services/component-libraries"
            />
            <ServiceCard 
              icon={<Users />}
              title="Technical Consultation"
              description="Expert guidance on architecture, technology selection, and implementation strategies."
              link="/services/consultation"
            />
          </div>
          
          <div className="text-center mt-12">
            <a href="/services" className="inline-flex items-center text-blue-400 hover:text-blue-300">
              View all services <ChevronRight size={16} className="ml-1" />
            </a>
          </div>
        </div>
      </div>

      {/* Featured Work */}
      <div className="py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">Featured Projects</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              A selection of my recent work with React and related technologies.
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <ProjectCard 
              title="E-Commerce Dashboard"
              tags={["Next.js", "TypeScript", "Tailwind", "Prisma"]}
              imageUrl="/api/placeholder/400/200"
              link="/projects/ecommerce-dashboard"
            />
            <ProjectCard 
              title="Analytics Platform"
              tags={["React", "D3.js", "Firebase", "Material UI"]}
              imageUrl="/api/placeholder/400/200"
              link="/projects/analytics-platform"
            />
            <ProjectCard 
              title="SaaS Application"
              tags={["React", "GraphQL", "Node.js", "Stripe"]}
              imageUrl="/api/placeholder/400/200"
              link="/projects/saas-application"
            />
          </div>
          
          <div className="text-center mt-12">
            <a href="/projects" className="inline-flex items-center text-blue-400 hover:text-blue-300">
              View full portfolio <ChevronRight size={16} className="ml-1" />
            </a>
          </div>
        </div>
      </div>

      {/* Blog/Resources Section */}
      <div className="py-16 bg-slate-800 bg-opacity-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">Latest Articles</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Insights and tutorials on React development and modern web technologies.
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <BlogCard 
              title="Building Type-Safe React Applications with TypeScript"
              date="April 15, 2025"
              excerpt="A comprehensive guide to creating reusable, type-safe components with React and TypeScript."
              imageUrl="/api/placeholder/400/200"
              link="/blog/building-type-safe-react-applications"
            />
            <BlogCard 
              title="State Management in 2025: Beyond Redux"
              date="April 8, 2025"
              excerpt="Exploring modern alternatives to Redux for state management in React applications."
              imageUrl="/api/placeholder/400/200"
              link="/blog/state-management-beyond-redux"
            />
            <BlogCard 
              title="Optimizing Next.js for Core Web Vitals"
              date="March 30, 2025"
              excerpt="Practical tips to improve your Next.js application's performance metrics."
              imageUrl="/api/placeholder/400/200"
              link="/blog/optimizing-nextjs-core-web-vitals"
            />
          </div>
          
          <div className="text-center mt-12">
            <a href="/blog" className="inline-flex items-center text-blue-400 hover:text-blue-300">
              Read all articles <ChevronRight size={16} className="ml-1" />
            </a>
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="py-16">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-gradient-to-r from-blue-600 to-blue-800 rounded-xl shadow-2xl overflow-hidden">
            <div className="px-6 py-12 md:p-12 text-center">
              <h2 className="text-3xl font-bold mb-4">Ready to build something amazing?</h2>
              <p className="text-xl mb-8 max-w-2xl mx-auto">
                Let's collaborate on your next React project and create exceptional user experiences together.
              </p>
              <a 
                href="/contact" 
                className="inline-block bg-white text-blue-600 hover:bg-gray-100 font-bold py-3 px-8 rounded-md text-center"
              >
                Get in Touch
              </a>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-slate-900 py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="md:flex md:items-center md:justify-between">
            <div className="flex justify-center md:justify-start">
              <span className="text-xl font-bold text-blue-400">React<span className="text-white">Jon</span></span>
            </div>
            <div className="mt-8 md:mt-0">
              <p className="text-center md:text-left text-gray-400">
                &copy; {new Date().getFullYear()} ReactJon. All rights reserved.
              </p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

// Components
const ServiceCard = ({ icon, title, description, link }) => (
  <a href={link} className="block">
    <div className="bg-slate-700 hover:bg-slate-600 rounded-lg p-6 transition-all h-full">
      <div className="text-blue-400 mb-4">
        {icon}
      </div>
      <h3 className="text-xl font-bold mb-2">{title}</h3>
      <p className="text-gray-300">{description}</p>
    </div>
  </a>
);

const ProjectCard = ({ title, tags, imageUrl, link }) => (
  <a href={link} className="block">
    <div className="bg-slate-700 rounded-lg overflow-hidden transition-all hover:transform hover:scale-105">
      <img src={imageUrl} alt={title} className="w-full h-48 object-cover" />
      <div className="p-6">
        <h3 className="text-xl font-bold mb-2">{title}</h3>
        <div className="flex flex-wrap gap-2 mt-2">
          {tags.map((tag, index) => (
            <span key={index} className="text-xs bg-slate-800 text-blue-300 px-2 py-1 rounded">
              {tag}
            </span>
          ))}
        </div>
      </div>
    </div>
  </a>
);

const BlogCard = ({ title, date, excerpt, imageUrl, link }) => (
  <a href={link} className="block">
    <div className="bg-slate-700 rounded-lg overflow-hidden transition-all hover:transform hover:scale-105 h-full">
      <img src={imageUrl} alt={title} className="w-full h-48 object-cover" />
      <div className="p-6">
        <div className="text-sm text-gray-400 mb-2">{date}</div>
        <h3 className="text-xl font-bold mb-2">{title}</h3>
        <p className="text-gray-300 mb-4">{excerpt}</p>
        <span className="text-blue-400 hover:text-blue-300 inline-flex items-center">
          Read more <ChevronRight size={16} className="ml-1" />
        </span>
      </div>
    </div>
  </a>
);

export default HomePage;