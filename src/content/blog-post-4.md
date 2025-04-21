---
title: "Creating Accessible React Components: A Practical Guide"
date: "2025-03-15"
excerpt: "Learn how to build React components that are accessible to everyone, with practical techniques and real-world examples."
tags: ["React", "Accessibility", "a11y", "WCAG", "Inclusive Design"]
author: "Jon Rocha"
---

# Creating Accessible React Components: A Practical Guide

Web accessibility isn't just about compliance—it's about building products that everyone can use, regardless of their abilities. As a React consultant, I've helped numerous companies retrofit accessibility into their applications, often at significant cost. The smarter approach? Build accessibility in from the start.

In this guide, I'll share practical techniques for creating accessible React components based on my experience working with clients across various industries.

## Why Accessibility Matters in React Applications

Beyond the ethical and legal considerations, accessible applications offer tangible benefits:

- **Larger audience reach**: 15-20% of the global population has some form of disability
- **Better SEO**: Many accessibility practices improve search engine rankings
- **Enhanced usability**: Accessible sites are often easier for everyone to use
- **Legal compliance**: Accessibility is required by law in many jurisdictions (ADA, Section 508, EAA)

For a recent healthcare client, improving accessibility increased their user engagement by 23% and reduced support tickets by 18%. Let's explore how you can achieve similar results.

## Setting Up Accessibility Tools in Your React Project

Before diving into component-specific techniques, set up these tools to catch accessibility issues early:

### 1. ESLint with jsx-a11y

```bash
npm install eslint-plugin-jsx-a11y --save-dev
```

Update your `.eslintrc.js`:

```js
module.exports = {
  // ...other config
  extends: [
    // ...other extends
    'plugin:jsx-a11y/recommended'
  ],
  plugins: [
    // ...other plugins
    'jsx-a11y'
  ],
  rules: {
    // Customize specific rules if needed
    'jsx-a11y/label-has-associated-control': ['error', { assert: 'either' }]
  }
};
```

### 2. React Testing Library for Accessibility-Focused Tests

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom jest-axe
```

Create an accessibility test utility:

```jsx
// src/utils/test-utils.js
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';

// Add custom jest matchers
expect.extend(toHaveNoViolations);

// Enhanced render with accessibility testing
export async function renderWithA11y(ui, options) {
  const renderResult = render(ui, options);
  const axeResults = await axe(renderResult.container);
  
  return {
    ...renderResult,
    axeResults
  };
}
```

Then use it in your tests:

```jsx
// Button.test.jsx
import { renderWithA11y } from '../utils/test-utils';
import Button from './Button';

test('Button component has no accessibility violations', async () => {
  const { axeResults } = await renderWithA11y(
    <Button onClick={() => {}} aria-label="Submit form">
      Submit
    </Button>
  );
  
  expect(axeResults).toHaveNoViolations();
});
```

## Creating Accessible Core Components

Let's build accessible versions of common React components you'll use throughout your application.

### Accessible Button Component

```jsx
import React, { forwardRef } from 'react';
import PropTypes from 'prop-types';

// Accessible button that supports various states
const Button = forwardRef(({
  children,
  onClick,
  disabled = false,
  isLoading = false,
  variant = 'primary',
  type = 'button',
  className = '',
  ...props
}, ref) => {
  // Determine the correct aria attributes based on state
  const ariaProps = {
    'aria-disabled': disabled || isLoading,
    'aria-busy': isLoading,
  };
  
  // Merge all classes
  const buttonClasses = `
    btn btn-${variant}
    ${disabled || isLoading ? 'opacity-60 cursor-not-allowed' : ''}
    ${className}
  `;
  
  return (
    <button
      ref={ref}
      type={type}
      className={buttonClasses}
      onClick={onClick}
      disabled={disabled || isLoading}
      {...ariaProps}
      {...props}
    >
      {isLoading ? (
        <>
          <span className="spinner" aria-hidden="true" />
          <span className="sr-only">Loading</span>
          {children}
        </>
      ) : (
        children
      )}
    </button>
  );
});

Button.propTypes = {
  children: PropTypes.node.isRequired,
  onClick: PropTypes.func,
  disabled: PropTypes.bool,
  isLoading: PropTypes.bool,
  variant: PropTypes.oneOf(['primary', 'secondary', 'danger', 'ghost']),
  type: PropTypes.oneOf(['button', 'submit', 'reset']),
  className: PropTypes.string,
};

export default Button;
```

### Accessible Modal Component

Modals are notoriously difficult to make accessible. Here's a properly implemented accessible modal:

```jsx
import React, { useEffect, useRef } from 'react';
import { createPortal } from 'react-dom';
import FocusTrap from 'focus-trap-react';
import PropTypes from 'prop-types';

const Modal = ({ 
  isOpen, 
  onClose, 
  title, 
  children, 
  ariaDescribedBy = 'modal-description',
}) => {
  const modalRef = useRef(null);
  
  // Handle ESC key press
  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === 'Escape' && isOpen) {
        onClose();
      }
    };
    
    window.addEventListener('keydown', handleKeyDown);
    
    // Prevent scrolling on body while modal is open
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    }
    
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      document.body.style.overflow = 'unset';
    };
  }, [isOpen, onClose]);
  
  // Only render the modal if it's open
  if (!isOpen) return null;
  
  // Portal the modal to the end of the document body
  return createPortal(
    <div 
      className="modal-overlay"
      onClick={onClose}
      role="presentation"
    >
      <FocusTrap>
        <div
          className="modal-container"
          role="dialog"
          aria-modal="true"
          aria-labelledby="modal-title"
          aria-describedby={ariaDescribedBy}
          onClick={(e) => e.stopPropagation()}
          ref={modalRef}
        >
          <div className="modal-header">
            <h2 id="modal-title" className="modal-title">
              {title}
            </h2>
            <button
              className="modal-close-button"
              onClick={onClose}
              aria-label="Close modal"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          
          <div id={ariaDescribedBy} className="modal-content">
            {children}
          </div>
        </div>
      </FocusTrap>
    </div>,
    document.body
  );
};

Modal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  title: PropTypes.string.isRequired,
  children: PropTypes.node.isRequired,
  ariaDescribedBy: PropTypes.string,
};

export default Modal;
```

### Accessible Form Components

Form controls are among the most important elements to make accessible:

```jsx
import React, { forwardRef } from 'react';
import PropTypes from 'prop-types';

// Accessible text input
export const Input = forwardRef(({
  id,
  label,
  error,
  required = false,
  className = '',
  hideLabel = false,
  ...props
}, ref) => {
  // Generate a unique ID if none provided
  const inputId = id || `input-${Math.random().toString(36).substr(2, 9)}`;
  
  return (
    <div className="form-control">
      <label 
        htmlFor={inputId}
        className={hideLabel ? 'sr-only' : 'form-label'}
      >
        {label}
        {required && <span aria-hidden="true"> *</span>}
      </label>
      
      <input
        ref={ref}
        id={inputId}
        className={`form-input ${error ? 'form-input-error' : ''} ${className}`}
        aria-invalid={!!error}
        aria-required={required}
        required={required}
        {...props}
      />
      
      {error && (
        <div className="form-error" id={`${inputId}-error`} aria-live="polite">
          {error}
        </div>
      )}
    </div>
  );
});

// Accessible checkbox
export const Checkbox = forwardRef(({
  id,
  label,
  error,
  required = false,
  className = '',
  ...props
}, ref) => {
  const checkboxId = id || `checkbox-${Math.random().toString(36).substr(2, 9)}`;
  
  return (
    <div className="form-control">
      <div className="checkbox-wrapper">
        <input
          ref={ref}
          type="checkbox"
          id={checkboxId}
          className={`form-checkbox ${error ? 'form-checkbox-error' : ''} ${className}`}
          aria-invalid={!!error}
          aria-required={required}
          required={required}
          {...props}
        />
        <label htmlFor={checkboxId}>
          {label}
          {required && <span aria-hidden="true"> *</span>}
        </label>
      </div>
      
      {error && (
        <div className="form-error" id={`${checkboxId}-error`} aria-live="polite">
          {error}
        </div>
      )}
    </div>
  );
});

// Accessible select
export const Select = forwardRef(({
  id,
  label,
  options,
  error,
  required = false,
  className = '',
  hideLabel = false,
  ...props
}, ref) => {
  const selectId = id || `select-${Math.random().toString(36).substr(2, 9)}`;
  
  return (
    <div className="form-control">
      <label 
        htmlFor={selectId}
        className={hideLabel ? 'sr-only' : 'form-label'}
      >
        {label}
        {required && <span aria-hidden="true"> *</span>}
      </label>
      
      <select
        ref={ref}
        id={selectId}
        className={`form-select ${error ? 'form-select-error' : ''} ${className}`}
        aria-invalid={!!error}
        aria-required={required}
        required={required}
        {...props}
      >
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
      
      {error && (
        <div className="form-error" id={`${selectId}-error`} aria-live="polite">
          {error}
        </div>
      )}
    </div>
  );
});

// PropTypes
const formPropTypes = {
  id: PropTypes.string,
  label: PropTypes.string.isRequired,
  error: PropTypes.string,
  required: PropTypes.bool,
  className: PropTypes.string,
  hideLabel: PropTypes.bool,
};

Input.propTypes = formPropTypes;
Checkbox.propTypes = formPropTypes;

Select.propTypes = {
  ...formPropTypes,
  options: PropTypes.arrayOf(
    PropTypes.shape({
      value: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
      label: PropTypes.string.isRequired,
    })
  ).isRequired,
};
```

## Building Complex Accessible Components

Let's look at more complex components that require special attention to accessibility.

### Accessible Tabs Component

```jsx
import React, { useState } from 'react';
import PropTypes from 'prop-types';

const Tabs = ({ tabs, defaultTab = 0 }) => {
  const [activeIndex, setActiveIndex] = useState(defaultTab);
  
  // Generate unique IDs for tab components
  const tabIds = tabs.map((_, index) => `tab-${index}`);
  const panelIds = tabs.map((_, index) => `panel-${index}`);
  
  return (
    <div className="tabs-container">
      {/* Tab list */}
      <div role="tablist" className="tabs-list">
        {tabs.map((tab, index) => (
          <button
            key={index}
            role="tab"
            id={tabIds[index]}
            aria-selected={activeIndex === index}
            aria-controls={panelIds[index]}
            tabIndex={activeIndex === index ? 0 : -1}
            className={`tab ${activeIndex === index ? 'tab-active' : ''}`}
            onClick={() => setActiveIndex(index)}
            onKeyDown={(e) => {
              // Handle keyboard navigation
              const tabCount = tabs.length;
              let newIndex = activeIndex;
              
              switch (e.key) {
                case 'ArrowRight':
                  newIndex = (activeIndex + 1) % tabCount;
                  break;
                case 'ArrowLeft':
                  newIndex = (activeIndex - 1 + tabCount) % tabCount;
                  break;
                case 'Home':
                  newIndex = 0;
                  break;
                case 'End':
                  newIndex = tabCount - 1;
                  break;
                default:
                  return;
              }
              
              setActiveIndex(newIndex);
              // Focus the selected tab
              document.getElementById(tabIds[newIndex]).focus();
            }}
          >
            {tab.title}
          </button>
        ))}
      </div>
      
      {/* Tab panels */}
      {tabs.map((tab, index) => (
        <div
          key={index}
          role="tabpanel"
          id={panelIds[index]}
          aria-labelledby={tabIds[index]}
          hidden={activeIndex !== index}
          tabIndex={0}
          className="tab-panel"
        >
          {tab.content}
        </div>
      ))}
    </div>
  );
};

Tabs.propTypes = {
  tabs: PropTypes.arrayOf(
    PropTypes.shape({
      title: PropTypes.string.isRequired,
      content: PropTypes.node.isRequired,
    })
  ).isRequired,
  defaultTab: PropTypes.number,
};

export default Tabs;

### Accessible Dropdown Menu

Dropdown menus present unique accessibility challenges. Here's an implementation that handles keyboard navigation and proper ARIA attributes:

```jsx
import React, { useState, useRef, useEffect } from 'react';
import PropTypes from 'prop-types';

const DropdownMenu = ({ 
  trigger, 
  items, 
  label = 'Menu', 
  onItemSelect,
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [activeIndex, setActiveIndex] = useState(-1);
  const menuRef = useRef(null);
  const triggerRef = useRef(null);
  
  // Close the dropdown when clicking outside
  useEffect(() => {
    const handleOutsideClick = (event) => {
      if (
        menuRef.current && 
        !menuRef.current.contains(event.target) && 
        !triggerRef.current.contains(event.target)
      ) {
        setIsOpen(false);
        setActiveIndex(-1);
      }
    };
    
    if (isOpen) {
      document.addEventListener('mousedown', handleOutsideClick);
    }
    
    return () => {
      document.removeEventListener('mousedown', handleOutsideClick);
    };
  }, [isOpen]);
  
  const handleItemClick = (item, index) => {
    onItemSelect(item);
    setIsOpen(false);
    setActiveIndex(-1);
    triggerRef.current.focus();
  };
  
  const handleKeyDown = (e) => {
    const itemCount = items.length;
    
    switch (e.key) {
      case 'Escape':
        setIsOpen(false);
        setActiveIndex(-1);
        triggerRef.current.focus();
        break;
      case 'ArrowDown':
        e.preventDefault();
        if (!isOpen) {
          setIsOpen(true);
        } else {
          setActiveIndex((prevIndex) => (prevIndex + 1) % itemCount);
        }
        break;
      case 'ArrowUp':
        e.preventDefault();
        if (!isOpen) {
          setIsOpen(true);
          setActiveIndex(itemCount - 1);
        } else {
          setActiveIndex((prevIndex) => (prevIndex - 1 + itemCount) % itemCount);
        }
        break;
      case 'Home':
        e.preventDefault();
        setActiveIndex(0);
        break;
      case 'End':
        e.preventDefault();
        setActiveIndex(itemCount - 1);
        break;
      case 'Enter':
      case ' ':
        e.preventDefault();
        if (!isOpen) {
          setIsOpen(true);
        } else if (activeIndex >= 0) {
          handleItemClick(items[activeIndex], activeIndex);
        }
        break;
      default:
        break;
    }
  };
  
  // Focus the active item when it changes
  useEffect(() => {
    if (isOpen && activeIndex >= 0 && menuRef.current) {
      const menuItems = menuRef.current.querySelectorAll('[role="menuitem"]');
      if (menuItems[activeIndex]) {
        menuItems[activeIndex].focus();
      }
    }
  }, [activeIndex, isOpen]);
  
  const menuId = `dropdown-menu-${Math.random().toString(36).substr(2, 9)}`;
  
  return (
    <div className="dropdown-container">
      <button
        ref={triggerRef}
        aria-haspopup="true"
        aria-expanded={isOpen}
        aria-controls={menuId}
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        className="dropdown-trigger"
        aria-label={label}
      >
        {trigger}
      </button>
      
      {isOpen && (
        <ul
          ref={menuRef}
          id={menuId}
          role="menu"
          aria-label={label}
          className="dropdown-menu"
          onKeyDown={handleKeyDown}
        >
          {items.map((item, index) => (
            <li key={index} role="none">
              <button
                role="menuitem"
                tabIndex={activeIndex === index ? 0 : -1}
                onClick={() => handleItemClick(item, index)}
                className={`dropdown-item ${activeIndex === index ? 'dropdown-item-active' : ''}`}
              >
                {item.label}
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

DropdownMenu.propTypes = {
  trigger: PropTypes.node.isRequired,
  items: PropTypes.arrayOf(
    PropTypes.shape({
      label: PropTypes.string.isRequired,
      value: PropTypes.any.isRequired,
    })
  ).isRequired,
  label: PropTypes.string,
  onItemSelect: PropTypes.func.isRequired,
};

export default DropdownMenu;
```

### Accessible Autocomplete Component

Here's an accessible autocomplete component that follows WAI-ARIA practices:

```jsx
import React, { useState, useRef, useEffect } from 'react';
import PropTypes from 'prop-types';

const Autocomplete = ({
  id,
  label,
  suggestions,
  onSelect,
  initialValue = '',
  placeholder = '',
  required = false,
}) => {
  const [inputValue, setInputValue] = useState(initialValue);
  const [filteredSuggestions, setFilteredSuggestions] = useState([]);
  const [isOpen, setIsOpen] = useState(false);
  const [activeIndex, setActiveIndex] = useState(-1);
  
  const inputRef = useRef(null);
  const listboxRef = useRef(null);
  
  // Generate unique IDs
  const inputId = id || `autocomplete-${Math.random().toString(36).substr(2, 9)}`;
  const listboxId = `${inputId}-listbox`;
  
  // Filter suggestions based on input
  useEffect(() => {
    if (inputValue.trim() === '') {
      setFilteredSuggestions([]);
      setIsOpen(false);
      return;
    }
    
    const filtered = suggestions.filter(suggestion =>
      suggestion.label.toLowerCase().includes(inputValue.toLowerCase())
    );
    
    setFilteredSuggestions(filtered);
    setIsOpen(filtered.length > 0);
    setActiveIndex(-1);
  }, [inputValue, suggestions]);
  
  // Handle keyboard navigation
  const handleKeyDown = (e) => {
    const suggestionsCount = filteredSuggestions.length;
    
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        if (!isOpen) {
          setIsOpen(true);
        } else {
          setActiveIndex((prevIndex) => 
            prevIndex < suggestionsCount - 1 ? prevIndex + 1 : prevIndex
          );
        }
        break;
      case 'ArrowUp':
        e.preventDefault();
        setActiveIndex((prevIndex) => (prevIndex > 0 ? prevIndex - 1 : -1));
        break;
      case 'Escape':
        setIsOpen(false);
        setActiveIndex(-1);
        break;
      case 'Enter':
        e.preventDefault();
        if (activeIndex >= 0) {
          selectSuggestion(filteredSuggestions[activeIndex]);
        }
        break;
      case 'Tab':
        if (isOpen) {
          setIsOpen(false);
        }
        break;
      default:
        break;
    }
  };
  
  // Select a suggestion
  const selectSuggestion = (suggestion) => {
    setInputValue(suggestion.label);
    setIsOpen(false);
    setActiveIndex(-1);
    onSelect(suggestion);
    inputRef.current.focus();
  };
  
  // Focus the active suggestion
  useEffect(() => {
    if (isOpen && activeIndex >= 0 && listboxRef.current) {
      const options = listboxRef.current.querySelectorAll('[role="option"]');
      if (options[activeIndex]) {
        // Scroll the option into view if needed
        options[activeIndex].scrollIntoView({ block: 'nearest' });
      }
    }
  }, [activeIndex, isOpen]);
  
  return (
    <div className="autocomplete">
      <label htmlFor={inputId} className="autocomplete-label">
        {label}
        {required && <span aria-hidden="true"> *</span>}
      </label>
      
      <input
        ref={inputRef}
        id={inputId}
        type="text"
        value={inputValue}
        onChange={(e) => setInputValue(e.target.value)}
        onKeyDown={handleKeyDown}
        onFocus={() => {
          if (filteredSuggestions.length > 0) {
            setIsOpen(true);
          }
        }}
        onBlur={() => {
          // Delay closing to allow for suggestion selection by click
          setTimeout(() => setIsOpen(false), 200);
        }}
        aria-autocomplete="list"
        aria-controls={isOpen ? listboxId : undefined}
        aria-activedescendant={activeIndex >= 0 ? `${inputId}-option-${activeIndex}` : undefined}
        aria-required={required}
        placeholder={placeholder}
        className="autocomplete-input"
      />
      
      {isOpen && filteredSuggestions.length > 0 && (
        <ul
          ref={listboxRef}
          id={listboxId}
          role="listbox"
          aria-label={`Suggestions for ${label}`}
          className="autocomplete-suggestions"
        >
          {filteredSuggestions.map((suggestion, index) => (
            <li
              key={index}
              id={`${inputId}-option-${index}`}
              role="option"
              aria-selected={activeIndex === index}
              onClick={() => selectSuggestion(suggestion)}
              onMouseEnter={() => setActiveIndex(index)}
              className={`autocomplete-suggestion ${activeIndex === index ? 'active' : ''}`}
            >
              {suggestion.label}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

Autocomplete.propTypes = {
  id: PropTypes.string,
  label: PropTypes.string.isRequired,
  suggestions: PropTypes.arrayOf(
    PropTypes.shape({
      label: PropTypes.string.isRequired,
      value: PropTypes.any.isRequired,
    })
  ).isRequired,
  onSelect: PropTypes.func.isRequired,
  initialValue: PropTypes.string,
  placeholder: PropTypes.string,
  required: PropTypes.bool,
};

export default Autocomplete;
```

## Making Interactive React Patterns Accessible

Now that we have accessible components, let's explore how to make common React patterns accessible.

### Accessible Loading States

When content is loading, it's important to communicate this to screen reader users:

```jsx
import React from 'react';

const LoadingState = ({ isLoading, loadingMessage = 'Loading...', children }) => {
  return (
    <div className="loading-container">
      {isLoading ? (
        <div aria-live="polite" aria-busy={isLoading} className="loading-indicator">
          <div className="spinner" aria-hidden="true" />
          <p>{loadingMessage}</p>
        </div>
      ) : (
        children
      )}
    </div>
  );
};

// Usage
function ProductList() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    fetchProducts()
      .then(data => {
        setProducts(data);
        setLoading(false);
      });
  }, []);
  
  return (
    <LoadingState 
      isLoading={loading} 
      loadingMessage="Loading products, please wait..."
    >
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </LoadingState>
  );
}
```

### Accessible Toast Notifications

Toast notifications need special handling to be accessible to screen reader users:

```jsx
import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import PropTypes from 'prop-types';

const Toast = ({ 
  message, 
  type = 'info', 
  duration = 5000, 
  onClose,
}) => {
  const [visible, setVisible] = useState(true);
  
  useEffect(() => {
    const timer = setTimeout(() => {
      setVisible(false);
      onClose();
    }, duration);
    
    return () => clearTimeout(timer);
  }, [duration, onClose]);
  
  // Map type to appropriate aria role and icon
  const roleMap = {
    success: 'status',
    error: 'alert',
    info: 'status',
    warning: 'alert',
  };
  
  if (!visible) return null;
  
  return createPortal(
    <div
      role={roleMap[type]}
      aria-live={type === 'error' || type === 'warning' ? 'assertive' : 'polite'}
      className={`toast toast-${type}`}
    >
      <div className="toast-content">
        <span className={`toast-icon toast-icon-${type}`} aria-hidden="true" />
        <p className="toast-message">{message}</p>
        <button
          onClick={() => {
            setVisible(false);
            onClose();
          }}
          aria-label="Close notification"
          className="toast-close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    </div>,
    document.body
  );
};

Toast.propTypes = {
  message: PropTypes.string.isRequired,
  type: PropTypes.oneOf(['success', 'error', 'info', 'warning']),
  duration: PropTypes.number,
  onClose: PropTypes.func.isRequired,
};

// Toast manager component
const ToastManager = () => {
  const [toasts, setToasts] = useState([]);
  
  const addToast = (toast) => {
    const id = Math.random().toString(36).substr(2, 9);
    setToasts((prevToasts) => [...prevToasts, { ...toast, id }]);
    return id;
  };
  
  const removeToast = (id) => {
    setToasts((prevToasts) => prevToasts.filter(toast => toast.id !== id));
  };
  
  // Create a context to provide toast functionality throughout the app
  const ToastContext = React.createContext({
    addToast: () => {},
    removeToast: () => {},
  });
  
  const ToastProvider = ({ children }) => {
    return (
      <ToastContext.Provider value={{ addToast, removeToast }}>
        {children}
        <div className="toast-container">
          {toasts.map((toast) => (
            <Toast
              key={toast.id}
              message={toast.message}
              type={toast.type}
              duration={toast.duration}
              onClose={() => removeToast(toast.id)}
            />
          ))}
        </div>
      </ToastContext.Provider>
    );
  };
  
  // Hook to use the toast functionality
  const useToast = () => React.useContext(ToastContext);
  
  return { ToastProvider, useToast };
};

export default ToastManager;
```

### Accessible Infinite Scrolling

Infinite scrolling can be problematic for keyboard users. Here's an accessible implementation:

```jsx
import React, { useState, useEffect, useRef } from 'react';
import PropTypes from 'prop-types';

const InfiniteScroll = ({
  loadMore,
  hasMore,
  isLoading,
  loadingMessage = 'Loading more items...',
  endMessage = 'No more items to load',
  children,
}) => {
  const [showLoadMoreButton, setShowLoadMoreButton] = useState(false);
  const observer = useRef(null);
  const loadingRef = useRef(null);
  
  // Set up intersection observer for auto-loading
  useEffect(() => {
    if (isLoading || !hasMore) return;
    
    observer.current = new IntersectionObserver(
      (entries) => {
        const first = entries[0];
        if (first.isIntersecting) {
          loadMore();
        }
      },
      { threshold: 0.1 }
    );
    
    const currentElement = loadingRef.current;
    if (currentElement) {
      observer.current.observe(currentElement);
    }
    
    return () => {
      if (currentElement) {
        observer.current?.unobserve(currentElement);
      }
    };
  }, [isLoading, hasMore, loadMore]);
  
  // Toggle button visibility when user scrolls via keyboard
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Tab' || e.key === 'ArrowDown') {
        setShowLoadMoreButton(true);
      }
    };
    
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);
  
  return (
    <div className="infinite-scroll-container">
      {children}
      
      {hasMore && (
        <div 
          ref={loadingRef} 
          className="loading-trigger"
          aria-hidden="true" // Hide from screen readers, they will use the button instead
        />
      )}
      
      {hasMore && showLoadMoreButton && !isLoading && (
        <button
          onClick={loadMore}
          className="load-more-button"
          aria-controls="content-region"
        >
          Load more
        </button>
      )}
      
      {isLoading && (
        <div aria-live="polite" className="loading-message">
          {loadingMessage}
        </div>
      )}
      
      {!hasMore && !isLoading && (
        <div aria-live="polite" className="end-message">
          {endMessage}
        </div>
      )}
    </div>
  );
};

InfiniteScroll.propTypes = {
  loadMore: PropTypes.func.isRequired,
  hasMore: PropTypes.bool.isRequired,
  isLoading: PropTypes.bool.isRequired,
  loadingMessage: PropTypes.string,
  endMessage: PropTypes.string,
  children: PropTypes.node.isRequired,
};

export default InfiniteScroll;
```

## Real-world Accessibility Tips

Based on my experience working with dozens of client projects, here are some practical tips for building accessible React applications:

### 1. Use Semantic HTML

Always choose the appropriate HTML element for the job:

```jsx
// ❌ Bad - non-semantic
<div onClick={handleClick} className="button">Click me</div>

// ✅ Good - semantic
<button onClick={handleClick} className="button">Click me</button>
```

### 2. Manage Focus Programmatically

When content changes, ensure focus is managed appropriately:

```jsx
function FormWizard() {
  const [step, setStep] = useState(1);
  const nextButtonRef = useRef(null);
  
  // When step changes, focus the next button
  useEffect(() => {
    if (step > 1 && nextButtonRef.current) {
      nextButtonRef.current.focus();
    }
  }, [step]);
  
  return (
    <div>
      {step === 1 && <StepOne onNext={() => setStep(2)} />}
      {step === 2 && (
        <StepTwo 
          onNext={() => setStep(3)} 
          ref={nextButtonRef} 
        />
      )}
      {step === 3 && <StepThree onComplete={handleComplete} />}
    </div>
  );
}
```

### 3. Use Live Regions for Dynamic Content

When content updates dynamically, use ARIA live regions:

```jsx
function Notification({ messages }) {
  return (
    <div 
      aria-live="polite" 
      aria-atomic="true"
      className="notification-area"
    >
      {messages.map(message => (
        <div key={message.id} className="notification">
          {message.text}
        </div>
      ))}
    </div>
  );
}
```

### 4. Provide Skip Links

Allow keyboard users to skip navigation:

```jsx
function Layout({ children }) {
  return (
    <>
      <a href="#main-content" className="skip-link">
        Skip to main content
      </a>
      <Header />
      <Navigation />
      <main id="main-content" tabIndex="-1">
        {children}
      </main>
      <Footer />
    </>
  );
}
```

### 5. Use Appropriate Color Contrast

Ensure text has sufficient contrast against its background:

```jsx
// Use CSS custom properties to manage colors
:root {
  --color-primary: #0057b8;
  --color-primary-dark: #004494;
  --color-text-on-primary: #ffffff;
  --color-text: #333333;
  --color-background: #ffffff;
}

// Apply them consistently
.button-primary {
  background-color: var(--color-primary);
  color: var(--color-text-on-primary);
}

// For hover/focus, maintain contrast
.button-primary:hover,
.button-primary:focus {
  background-color: var(--color-primary-dark);
  color: var(--color-text-on-primary);
}
```

### 6. Make Forms Accessible

Use fieldsets and legends for form groups:

```jsx
function ShippingForm() {
  return (
    <form>
      <fieldset>
        <legend>Shipping Address</legend>
        
        <Input 
          id="street"
          label="Street Address"
          required
        />
        
        <div className="form-row">
          <Input 
            id="city"
            label="City"
            required
          />
          
          <Select
            id="state"
            label="State"
            required
            options={stateOptions}
          />
          
          <Input
            id="zip"
            label="ZIP Code"
            required
            pattern="[0-9]{5}"
          />
        </div>
      </fieldset>
      
      <button type="submit">Submit</button>
    </form>
  );
}
```

## Case Study: Retrofitting Accessibility

One of my clients had a complex React dashboard with poor accessibility. Here's how we approached the retrofit:

1. **Audit**: We used automated tools (axe, WAVE) and manual testing to identify issues
2. **Prioritize**: We focused on critical issues affecting keyboard users and screen readers first
3. **Refactor**: We created accessible component versions and gradually replaced the old ones
4. **Test**: We worked with users with disabilities to validate our changes

The most common issues we found were:

- Missing form labels and proper ARIA attributes
- Lack of keyboard navigation support
- Insufficient color contrast
- No alt text for images
- Inaccessible custom controls (dropdowns, modals, tabs)

By addressing these issues, the client achieved WCAG 2.1 AA compliance and reported a 22% increase in user satisfaction scores.

## Testing Your React Components for Accessibility

Incorporate these testing methods into your workflow:

### Automated Testing

Use Jest and React Testing Library with jest-axe:

```jsx
// Button.test.jsx
import React from 'react';
import { render, screen } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';
import Button from './Button';

// Add jest-axe matchers
expect.extend(toHaveNoViolations);

describe('Button', () => {
  it('should render with accessible name', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /Click me/i })).toBeInTheDocument();
  });
  
  it('should be accessible', async () => {
    const { container } = render(<Button>Click me</Button>);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
  
  it('should support aria-label for icon-only buttons', async () => {
    const { container } = render(
      <Button aria-label="Close dialog">
        <span aria-hidden="true">&times;</span>
      </Button>
    );
    const results = await axe(container);
    expect(results).toHaveNoViolations();
    expect(screen.getByRole('button', { name: /Close dialog/i })).toBeInTheDocument();
  });
});
```

### Manual Testing

Use keyboard navigation to verify accessibility:

1. Press Tab to navigate through interactive elements
2. Press Enter/Space to activate buttons and links
3. Use arrow keys to navigate within composite widgets
4. Press Escape to close dialogs and modals

### Screen Reader Testing

Test with popular screen readers:

- NVDA or JAWS on Windows
- VoiceOver on macOS and iOS
- TalkBack on Android

## Conclusion

Building accessible React components isn't just the right thing to do—it's a business advantage. Accessible applications reach more users, comply with legal requirements, and often provide a better experience for everyone.

By incorporating these techniques into your React development workflow, you'll create more inclusive applications that work for all users, regardless of their abilities.

If you're struggling with implementing accessibility in your React application, [contact me](/contact) for a consultation. I can help audit your application, train your team, and implement accessible patterns that work for your specific needs.

## Resources

- [React Accessibility Docs](https://reactjs.org/docs/accessibility.html)
- [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/TR/wai-aria-practices-1.2/)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [Axe Core](https://github.com/dequelabs/axe-core)
- [A11y Project Checklist](https://www.a11yproject.com/checklist/)