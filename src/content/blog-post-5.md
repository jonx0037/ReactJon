---
title: "Building a Design System with React and TypeScript: A Complete Guide"
date: "2025-03-01"
excerpt: "Learn how to create, document, and maintain a robust design system for your React applications using TypeScript, Storybook, and modern tooling."
tags: ["React", "TypeScript", "Design Systems", "Storybook", "Component Libraries"]
author: "Jon Rocha"
---

# Building a Design System with React and TypeScript: A Complete Guide

A well-implemented design system is the cornerstone of scalable, consistent application development. As a React consultant, I've helped multiple organizations build and maintain design systems that streamline development, improve collaboration between designers and developers, and create better user experiences.

In this comprehensive guide, I'll walk you through the process of creating a production-ready design system with React and TypeScript, based on real-world implementations I've delivered for clients.

## Why Invest in a Design System?

Before diving into the technical details, let's understand the business value of a design system:

- **Consistency**: Create a unified user experience across all products and platforms
- **Efficiency**: Reduce development time by 30-50% through component reuse
- **Quality**: Ensure accessibility, performance, and cross-browser compatibility by default
- **Collaboration**: Improve communication between designers and developers
- **Scalability**: Support multiple teams and products with a single source of truth

For one enterprise client, implementing a design system reduced their time-to-market for new features by 40% and cut design inconsistencies by 90%. Let's explore how to achieve similar results for your organization.

## Setting Up Your Design System Repository

I recommend creating a dedicated monorepo for your design system using tools like Turborepo or Nx. Here's a simplified structure:

```
design-system/
├── packages/
│   ├── core/               # Core design tokens
│   ├── components/         # React components
│   ├── hooks/              # Custom React hooks
│   ├── utilities/          # Helper functions
│   └── documentation/      # Storybook docs
├── apps/
│   ├── storybook/          # Storybook instance
│   └── playground/         # Test application
├── scripts/                # Build and release scripts
├── package.json
└── turbo.json
```

Let's set up the project:

```bash
# Create a new turborepo
npx create-turbo@latest

# Navigate to the repo
cd design-system

# Add necessary packages
cd packages
mkdir core components hooks utilities documentation
cd ..

# Install dependencies
npm install --save-dev typescript @types/react react react-dom
npm install --save-dev storybook @storybook/react
npm install --save-dev @storybook/addon-a11y @storybook/addon-docs
npm install --save-dev jest @testing-library/react @testing-library/jest-dom
npm install --save-dev rollup typescript tslib
```

## Establishing Design Tokens

Design tokens form the foundation of your design system. They are the smallest, most fundamental design decisions, represented as data.

Let's create a set of core tokens:

```typescript
// packages/core/src/tokens/colors.ts
export const colors = {
  // Primary palette
  primary: {
    50: '#e6f1ff',
    100: '#cce3ff',
    200: '#99c7ff',
    300: '#66aaff',
    400: '#338eff',
    500: '#0072ff', // Primary color
    600: '#005bcc',
    700: '#004399',
    800: '#002c66',
    900: '#001433',
  },
  
  // Gray scale
  gray: {
    50: '#f9fafb',
    100: '#f3f4f6',
    200: '#e5e7eb',
    300: '#d1d5db',
    400: '#9ca3af',
    500: '#6b7280',
    600: '#4b5563',
    700: '#374151',
    800: '#1f2937',
    900: '#111827',
  },
  
  // Semantic colors
  success: {
    50: '#ecfdf5',
    // ... additional success shades
    500: '#10b981', // Main success color
    // ... additional success shades
  },
  
  warning: {
    // ... warning colors
  },
  
  danger: {
    // ... danger colors
  },
  
  // Functional colors
  background: {
    primary: '#ffffff',
    secondary: '#f9fafb',
    tertiary: '#f3f4f6',
  },
  
  text: {
    primary: '#111827',
    secondary: '#4b5563',
    disabled: '#9ca3af',
    inverse: '#ffffff',
  },
};

// packages/core/src/tokens/spacing.ts
export const spacing = {
  0: '0',
  1: '0.25rem', // 4px
  2: '0.5rem',  // 8px
  3: '0.75rem', // 12px
  4: '1rem',    // 16px
  5: '1.25rem', // 20px
  6: '1.5rem',  // 24px
  8: '2rem',    // 32px
  10: '2.5rem', // 40px
  12: '3rem',   // 48px
  16: '4rem',   // 64px
  20: '5rem',   // 80px
  24: '6rem',   // 96px
  32: '8rem',   // 128px
  40: '10rem',  // 160px
  48: '12rem',  // 192px
  56: '14rem',  // 224px
  64: '16rem',  // 256px
};

// packages/core/src/tokens/typography.ts
export const typography = {
  fontFamily: {
    sans: 'Inter, system-ui, -apple-system, sans-serif',
    mono: 'Menlo, Monaco, Consolas, monospace',
  },
  fontSize: {
    xs: '0.75rem',   // 12px
    sm: '0.875rem',  // 14px
    base: '1rem',    // 16px
    lg: '1.125rem',  // 18px
    xl: '1.25rem',   // 20px
    '2xl': '1.5rem', // 24px
    '3xl': '1.875rem', // 30px
    '4xl': '2.25rem',  // 36px
    '5xl': '3rem',     // 48px
  },
  fontWeight: {
    normal: '400',
    medium: '500',
    semibold: '600',
    bold: '700',
  },
  lineHeight: {
    none: '1',
    tight: '1.25',
    snug: '1.375',
    normal: '1.5',
    relaxed: '1.625',
    loose: '2',
  },
  letterSpacing: {
    tighter: '-0.05em',
    tight: '-0.025em',
    normal: '0',
    wide: '0.025em',
    wider: '0.05em',
    widest: '0.1em',
  },
};

// packages/core/src/tokens/shadows.ts
export const shadows = {
  xs: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
  sm: '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)',
  md: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
  lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
  xl: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
  '2xl': '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
  inner: 'inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)',
  none: 'none',
};

// packages/core/src/tokens/index.ts
export * from './colors';
export * from './spacing';
export * from './typography';
export * from './shadows';
// Export other token files

// Create a theme object that brings everything together
export const baseTheme = {
  colors,
  spacing,
  typography,
  shadows,
  // ...other token categories
  
  // Component-specific tokens
  components: {
    button: {
      padding: {
        sm: `${spacing[1]} ${spacing[2]}`,
        md: `${spacing[2]} ${spacing[4]}`,
        lg: `${spacing[3]} ${spacing[6]}`,
      },
      borderRadius: '0.25rem',
    },
    // ... other component tokens
  },
};

// Type definitions for the theme
export type Theme = typeof baseTheme;
```

## Creating a Component Architecture

With design tokens established, let's define our component architecture:

### Component Structure

For each component, follow this consistent file structure:

```
Button/
├── Button.tsx             # Component implementation
├── Button.styles.ts       # Styled components or CSS
├── Button.types.ts        # TypeScript interfaces and types
├── Button.test.tsx        # Unit tests
├── Button.stories.tsx     # Storybook stories
├── Button.mdx             # Documentation
└── index.ts               # Re-export component
```

### Button Component Example

Let's create a Button component that leverages our design tokens:

```typescript
// packages/components/src/Button/Button.types.ts
import { ReactNode, ButtonHTMLAttributes } from 'react';

export type ButtonVariant = 'primary' | 'secondary' | 'tertiary' | 'danger';
export type ButtonSize = 'sm' | 'md' | 'lg';

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  /** The button content */
  children: ReactNode;
  
  /** The visual variant of the button */
  variant?: ButtonVariant;
  
  /** The size of the button */
  size?: ButtonSize;
  
  /** Whether the button is in loading state */
  isLoading?: boolean;
  
  /** Whether the button takes the full width of its container */
  fullWidth?: boolean;
  
  /** Left icon */
  leftIcon?: ReactNode;
  
  /** Right icon */
  rightIcon?: ReactNode;
}
```

Now, let's implement the component:

```typescript
// packages/components/src/Button/Button.tsx
import React, { forwardRef } from 'react';
import { ButtonProps } from './Button.types';
import { 
  StyledButton, 
  ButtonContent, 
  ButtonSpinner, 
  LeftIconWrapper, 
  RightIconWrapper 
} from './Button.styles';

export const Button = forwardRef<HTMLButtonElement, ButtonProps>((props, ref) => {
  const { 
    children, 
    variant = 'primary', 
    size = 'md', 
    isLoading = false, 
    fullWidth = false,
    leftIcon,
    rightIcon,
    disabled,
    className,
    ...rest
  } = props;
  
  return (
    <StyledButton
      ref={ref}
      variant={variant}
      size={size}
      isLoading={isLoading}
      fullWidth={fullWidth}
      disabled={disabled || isLoading}
      className={className}
      {...rest}
    >
      {isLoading && <ButtonSpinner size={size} />}
      
      <ButtonContent isLoading={isLoading}>
        {leftIcon && <LeftIconWrapper size={size}>{leftIcon}</LeftIconWrapper>}
        {children}
        {rightIcon && <RightIconWrapper size={size}>{rightIcon}</RightIconWrapper>}
      </ButtonContent>
    </StyledButton>
  );
});

Button.displayName = 'Button';
```

Let's add the styles using styled-components:

```typescript
// packages/components/src/Button/Button.styles.ts
import styled, { css } from 'styled-components';
import { ButtonProps, ButtonSize } from './Button.types';

// Helper to get button padding based on size
const getPadding = (size: ButtonSize, theme) => {
  return theme.components.button.padding[size];
};

// Helper for different button variants
const getVariantStyles = (variant, theme) => {
  switch (variant) {
    case 'primary':
      return css`
        background-color: ${theme.colors.primary[500]};
        color: ${theme.colors.text.inverse};
        border: 1px solid ${theme.colors.primary[500]};
        
        &:hover:not(:disabled) {
          background-color: ${theme.colors.primary[600]};
          border-color: ${theme.colors.primary[600]};
        }
        
        &:active:not(:disabled) {
          background-color: ${theme.colors.primary[700]};
          border-color: ${theme.colors.primary[700]};
        }
        
        &:focus-visible {
          box-shadow: 0 0 0 3px ${theme.colors.primary[200]};
          outline: none;
        }
      `;
    case 'secondary':
      return css`
        background-color: ${theme.colors.gray[100]};
        color: ${theme.colors.gray[900]};
        border: 1px solid ${theme.colors.gray[300]};
        
        &:hover:not(:disabled) {
          background-color: ${theme.colors.gray[200]};
        }
        
        &:active:not(:disabled) {
          background-color: ${theme.colors.gray[300]};
        }
        
        &:focus-visible {
          box-shadow: 0 0 0 3px ${theme.colors.gray[200]};
          outline: none;
        }
      `;
    case 'tertiary':
      return css`
        background-color: transparent;
        color: ${theme.colors.primary[500]};
        border: 1px solid transparent;
        
        &:hover:not(:disabled) {
          background-color: ${theme.colors.primary[50]};
        }
        
        &:active:not(:disabled) {
          background-color: ${theme.colors.primary[100]};
        }
        
        &:focus-visible {
          box-shadow: 0 0 0 3px ${theme.colors.primary[100]};
          outline: none;
        }
      `;
    case 'danger':
      return css`
        background-color: ${theme.colors.danger[500]};
        color: ${theme.colors.text.inverse};
        border: 1px solid ${theme.colors.danger[500]};
        
        &:hover:not(:disabled) {
          background-color: ${theme.colors.danger[600]};
          border-color: ${theme.colors.danger[600]};
        }
        
        &:active:not(:disabled) {
          background-color: ${theme.colors.danger[700]};
          border-color: ${theme.colors.danger[700]};
        }
        
        &:focus-visible {
          box-shadow: 0 0 0 3px ${theme.colors.danger[200]};
          outline: none;
        }
      `;
    default:
      return '';
  }
};

// Button container
export const StyledButton = styled.button<ButtonProps>`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: ${props => getPadding(props.size || 'md', props.theme)};
  border-radius: ${props => props.theme.components.button.borderRadius};
  font-family: ${props => props.theme.typography.fontFamily.sans};
  font-weight: ${props => props.theme.typography.fontWeight.medium};
  font-size: ${props => {
    switch (props.size) {
      case 'sm': return props.theme.typography.fontSize.sm;
      case 'lg': return props.theme.typography.fontSize.lg;
      default: return props.theme.typography.fontSize.base;
    }
  }};
  line-height: 1;
  transition: all 150ms ease;
  width: ${props => props.fullWidth ? '100%' : 'auto'};
  cursor: pointer;
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
  
  ${props => getVariantStyles(props.variant, props.theme)}
`;

// Button content
export const ButtonContent = styled.span<{ isLoading: boolean }>`
  display: flex;
  align-items: center;
  visibility: ${props => props.isLoading ? 'hidden' : 'visible'};
`;

// Icon wrappers
export const LeftIconWrapper = styled.span<{ size: ButtonSize }>`
  margin-right: ${props => {
    switch (props.size) {
      case 'sm': return props.theme.spacing[1];
      case 'lg': return props.theme.spacing[3];
      default: return props.theme.spacing[2];
    }
  }};
  display: inline-flex;
`;

export const RightIconWrapper = styled.span<{ size: ButtonSize }>`
  margin-left: ${props => {
    switch (props.size) {
      case 'sm': return props.theme.spacing[1];
      case 'lg': return props.theme.spacing[3];
      default: return props.theme.spacing[2];
    }
  }};
  display: inline-flex;
`;

// Loading spinner
export const ButtonSpinner = styled.span<{ size: ButtonSize }>`
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: ${props => {
    switch (props.size) {
      case 'sm': return '14px';
      case 'lg': return '22px';
      default: return '18px';
    }
  }};
  height: ${props => {
    switch (props.size) {
      case 'sm': return '14px';
      case 'lg': return '22px';
      default: return '18px';
    }
  }};
  
  &:before {
    content: '';
    display: block;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 2px solid currentColor;
    border-top-color: transparent;
    animation: spin 0.7s linear infinite;
  }
  
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
`;
```

### Testing the Button Component

Now, let's write tests for our Button component:

```typescript
// packages/components/src/Button/Button.test.tsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { ThemeProvider } from 'styled-components';
import { baseTheme } from '@design-system/core';
import { Button } from './Button';

const renderWithTheme = (ui, options = {}) => {
  return render(
    <ThemeProvider theme={baseTheme}>{ui}</ThemeProvider>,
    options
  );
};

describe('Button', () => {
  it('renders children correctly', () => {
    renderWithTheme(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /Click me/i })).toBeInTheDocument();
  });
  
  it('handles click events', () => {
    const handleClick = jest.fn();
    renderWithTheme(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByRole('button', { name: /Click me/i }));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
  
  it('renders different variants', () => {
    const { rerender } = renderWithTheme(<Button variant="primary">Primary</Button>);
    const button = screen.getByRole('button', { name: /Primary/i });
    
    // Check primary button styles (you might need a more specific way to test styles)
    expect(button).toHaveStyle(`background-color: ${baseTheme.colors.primary[500]}`);
    
    rerender(
      <ThemeProvider theme={baseTheme}>
        <Button variant="secondary">Secondary</Button>
      </ThemeProvider>
    );
    
    // Check secondary button styles
    expect(screen.getByRole('button', { name: /Secondary/i })).toBeInTheDocument();
  });
  
  it('disables the button when isLoading is true', () => {
    renderWithTheme(<Button isLoading>Loading</Button>);
    expect(screen.getByRole('button', { name: /Loading/i })).toBeDisabled();
  });
  
  it('renders with full width when fullWidth is true', () => {
    renderWithTheme(<Button fullWidth>Full Width</Button>);
    expect(screen.getByRole('button', { name: /Full Width/i })).toHaveStyle('width: 100%');
  });
  
  it('renders with icons', () => {
    renderWithTheme(
      <Button 
        leftIcon={<span data-testid="left-icon">L</span>}
        rightIcon={<span data-testid="right-icon">R</span>}
      >
        With Icons
      </Button>
    );
    
    expect(screen.getByTestId('left-icon')).toBeInTheDocument();
    expect(screen.getByTestId('right-icon')).toBeInTheDocument();
  });
});
```

### Documenting with Storybook

Let's create stories for our Button component:

```typescript
// packages/components/src/Button/Button.stories.tsx
import React from 'react';
import { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  parameters: {
    docs: {
      description: {
        component: 'A flexible button component with multiple variants and sizes.',
      },
    },
  },
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'tertiary', 'danger'],
      description: 'The visual style of the button',
      table: {
        defaultValue: { summary: 'primary' },
      },
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
      description: 'The size of the button',
      table: {
        defaultValue: { summary: 'md' },
      },
    },
    isLoading: {
      control: 'boolean',
      description: 'Shows a loading spinner',
    },
    disabled: {
      control: 'boolean',
      description: 'Disables the button',
    },
    fullWidth: {
      control: 'boolean',
      description: 'Makes the button take the full width of its container',
    },
    onClick: { action: 'clicked' },
  },
};

export default meta;

type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    children: 'Primary Button',
    variant: 'primary',
  },
};

export const Secondary: Story = {
  args: {
    children: 'Secondary Button',
    variant: 'secondary',
  },
};

export const Tertiary: Story = {
  args: {
    children: 'Tertiary Button',
    variant: 'tertiary',
  },
};

export const Danger: Story = {
  args: {
    children: 'Danger Button',
    variant: 'danger',
  },
};

export const Small: Story = {
  args: {
    children: 'Small Button',
    size: 'sm',
  },
};

export const Medium: Story = {
  args: {
    children: 'Medium Button',
    size: 'md',
  },
};

export const Large: Story = {
  args: {
    children: 'Large Button',
    size: 'lg',
  },
};

export const Loading: Story = {
  args: {
    children: 'Loading Button',
    isLoading: true,
  },
};

export const Disabled: Story = {
  args: {
    children: 'Disabled Button',
    disabled: true,
  },
};

export const FullWidth: Story = {
  args: {
    children: 'Full Width Button',
    fullWidth: true,
  },
};

export const WithIcons: Story = {
  args: {
    children: 'Button with Icons',
    leftIcon: <span>←</span>,
    rightIcon: <span>→</span>,
  },
};
```

Now add detailed documentation with MDX:

```jsx
// packages/components/src/Button/Button.mdx
import { Canvas, Meta, Story, ArgsTable } from '@storybook/addon-docs';
import { Button } from './Button';
import * as ButtonStories from './Button.stories';

<Meta title="Components/Button/Documentation" component={Button} />

# Button

The Button component is used to trigger actions or events, such as submitting a form, opening a dialog, canceling an action, or performing a delete operation.

## Features

- Multiple visual variants: primary, secondary, tertiary, and danger
- Three sizes: small, medium, and large
- Loading state with spinner
- Support for left and right icons
- Full width option
- Accessible by default

## Usage

```jsx
import { Button } from '@design-system/components';

function Example() {
  return (
    <Button 
      variant="primary" 
      size="md" 
      onClick={() => console.log('Button clicked!')}
    >
      Click Me
    </Button>
  );
}
```

## Examples

### Variants

<Canvas>
  <Story story={ButtonStories.Primary} />
  <Story story={ButtonStories.Secondary} />
  <Story story={ButtonStories.Tertiary} />
  <Story story={ButtonStories.Danger} />
</Canvas>

### Sizes

<Canvas>
  <Story story={ButtonStories.Small} />
  <Story story={ButtonStories.Medium} />
  <Story story={ButtonStories.Large} />
</Canvas>

### States

<Canvas>
  <Story story={ButtonStories.Loading} />
  <Story story={ButtonStories.Disabled} />
</Canvas>

### With Icons

<Canvas>
  <Story story={ButtonStories.WithIcons} />
</Canvas>

## Design Guidelines

- Use the primary variant for the main action in a section
- Use the secondary variant for alternative actions
- Use the tertiary variant for low-emphasis actions
- Use the danger variant for destructive actions
- Aim for clear, concise button text that describes the action

## Accessibility

- Buttons are keyboard accessible and can be activated using both the Space and Enter keys
- Loading state disables the button and shows a spinner
- Focus state is visible for keyboard users
- Color contrast meets WCAG AA standards for all variants

## API Reference

<ArgsTable of={Button} />
```

## Building Additional Components

Following the same pattern, you can build out all the components in your design system. Here are some essential components to consider:

1. **Layout Components**
   - Grid
   - Box
   - Flex
   - Stack
   - Container

2. **Form Components**
   - Input
   - TextArea
   - Checkbox
   - Radio
   - Select
   - Switch
   - Slider

3. **Feedback Components**
   - Alert
   - Toast
   - Modal
   - Drawer
   - Tooltip
   - Popover

4. **Navigation Components**
   - Tabs
   - Breadcrumb
   - Menu
   - Pagination
   - Stepper

5. **Data Display Components**
   - Table
   - Card
   - List
   - Badge
   - Avatar
   - Tag

## Setting Up the Build Process

To make your design system consumable by other projects, you need a proper build process:

```javascript
// packages/components/rollup.config.js
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import typescript from '@rollup/plugin-typescript';
import { terser } from 'rollup-plugin-terser';
import dts from 'rollup-plugin-dts';
import packageJson from './package.json';

export default [
  {
    input: 'src/index.ts',
    output: [
      {
        file: packageJson.main,
        format: 'cjs',
        sourcemap: true,
      },
      {
        file: packageJson.module,
        format: 'esm',
        sourcemap: true,
      },
    ],
    plugins: [
      resolve(),
      commonjs(),
      typescript({ tsconfig: './tsconfig.json' }),
      terser(),
    ],
    external: ['react', 'react-dom', 'styled-components'],
  },
  {
    input: 'dist/esm/types/index.d.ts',
    output: [{ file: 'dist/index.d.ts', format: 'esm' }],
    plugins: [dts()],
  },
];
```

Update your `package.json`:

```json
{
  "name": "@design-system/components",
  "version": "0.1.0",
  "main": "dist/cjs/index.js",
  "module": "dist/esm/index.js",
  "types": "dist/index.d.ts",
  "files": [
    "dist"
  ],
  "scripts": {
    "build": "rollup -c",
    "lint": "eslint src/**/*.{ts,tsx}",
    "test": "jest --coverage",
    "storybook": "start-storybook -p 6006",
    "build-storybook": "build-storybook"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "styled-components": "^5.3.0"
  },
  "dependencies": {
    "@design-system/core": "^0.1.0"
  },
  "devDependencies": {
    // ... development dependencies
  }
}
```

## Version Control and CI/CD

Implement a robust versioning and continuous integration strategy:

### Semantic Versioning

Use semantic versioning (MAJOR.MINOR.PATCH) to communicate changes:
- MAJOR: Breaking changes
- MINOR: New features, non-breaking
- PATCH: Bug fixes, non-breaking

### Release Process

1. Set up Changesets for version management:

```bash
npm install --save-dev @changesets/cli
npx changeset init
```

2. Create a workflow file:

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    branches:
      - main

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16.x'
          registry-url: 'https://registry.npmjs.org'

      - name: Install Dependencies
        run: npm ci

      - name: Build Packages
        run: npm run build --workspaces

      - name: Create Release Pull Request or Publish to npm
        id: changesets
        uses: changesets/action@v1
        with:
          publish: npm run release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## Consuming the Design System

Now, let's see how to use your design system in a React application:

```jsx
// Example React application using your design system
import React from 'react';
import { ThemeProvider } from 'styled-components';
import { baseTheme } from '@design-system/core';
import { Button, Box, Text, Input } from '@design-system/components';

function App() {
  const [name, setName] = React.useState('');
  
  return (
    <ThemeProvider theme={baseTheme}>
      <Box padding={4}>
        <Text variant="h1" marginBottom={4}>
          Welcome to My App
        </Text>
        
        <Box marginBottom={4}>
          <Input
            label="Your Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Enter your name"
          />
        </Box>
        
        <Button 
          onClick={() => alert(`Hello, ${name}!`)}
          disabled={!name}
        >
          Say Hello
        </Button>
      </Box>
    </ThemeProvider>
  );
}

export default App;
```

## Documentation Website

A comprehensive documentation site is crucial for adoption. Storybook provides an excellent foundation, but you may want to extend it with additional features:

### Configuring Storybook

```javascript
// .storybook/main.js
module.exports = {
  stories: [
    '../packages/components/**/*.stories.@(js|jsx|ts|tsx|mdx)',
    '../packages/documentation/**/*.stories.@(js|jsx|ts|tsx|mdx)',
  ],
  addons: [
    '@storybook/addon-links',
    '@storybook/addon-essentials',
    '@storybook/addon-a11y',
    '@storybook/addon-interactions',
  ],
  framework: {
    name: '@storybook/react-webpack5',
    options: {},
  },
  docs: {
    autodocs: true,
  },
};
```

### Theme Toggle

Add a theme toggle to showcase components in light and dark modes:

```javascript
// .storybook/preview.js
import React from 'react';
import { ThemeProvider } from 'styled-components';
import { baseTheme, darkTheme } from '../packages/core/src';
import { useDarkMode } from 'storybook-dark-mode';
import { DocsContainer } from '@storybook/addon-docs';

export const parameters = {
  actions: { argTypesRegex: '^on[A-Z].*' },
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/,
    },
  },
  darkMode: {
    dark: { ...darkTheme },
    light: { ...baseTheme },
  },
  docs: {
    container: ({ children, context }) => {
      const isDark = useDarkMode();
      return (
        <DocsContainer context={context}>
          <ThemeProvider theme={isDark ? darkTheme : baseTheme}>
            {children}
          </ThemeProvider>
        </DocsContainer>
      );
    },
  },
};

export const decorators = [
  (Story) => {
    const isDark = useDarkMode();
    
    return (
      <ThemeProvider theme={isDark ? darkTheme : baseTheme}>
        <div style={{ padding: '2rem' }}>
          <Story />
        </div>
      </ThemeProvider>
    );
  },
];
```

### Custom Documentation Pages

Create custom documentation pages for design principles, getting started guides, and more:

```jsx
// packages/documentation/src/Introduction.stories.mdx
import { Meta } from '@storybook/addon-docs';

<Meta title="Documentation/Introduction" />

# Design System Documentation

Welcome to our design system documentation. This design system provides a comprehensive set of components and guidelines to build consistent, accessible applications.

## Getting Started

To install the design system in your project:

```bash
npm install @design-system/core @design-system/components
```

Then, wrap your application with the ThemeProvider:

```jsx
import { ThemeProvider } from 'styled-components';
import { baseTheme } from '@design-system/core';
import { Button } from '@design-system/components';

function App() {
  return (
    <ThemeProvider theme={baseTheme}>
      <Button>Hello, World!</Button>
    </ThemeProvider>
  );
}
```

## Core Principles

Our design system is built with these principles in mind:

1. **Consistency**: Cohesive experience across all products
2. **Accessibility**: Usable by everyone, regardless of ability
3. **Flexibility**: Adaptable to different product needs
4. **Efficiency**: Faster development through reusable components
5. **Quality**: Thoroughly tested components and patterns
```

## Advanced Topics

Let's explore some advanced topics for scaling your design system:

### Component Composition

Design effective component composition patterns:

```jsx
// Composable Card component example
import React, { createContext, useContext, ReactNode } from 'react';
import styled from 'styled-components';

// Context for managing internal state and communication
const CardContext = createContext({});

// Main Card container
const StyledCard = styled.div`
  border-radius: ${props => props.theme.components.card.borderRadius};
  box-shadow: ${props => props.theme.shadows.sm};
  background-color: ${props => props.theme.colors.background.primary};
  overflow: hidden;
`;

// Card components
const CardHeader = styled.div`
  padding: ${props => props.theme.spacing[4]};
  border-bottom: 1px solid ${props => props.theme.colors.gray[200]};
`;

const CardContent = styled.div`
  padding: ${props => props.theme.spacing[4]};
`;

const CardFooter = styled.div`
  padding: ${props => props.theme.spacing[4]};
  border-top: 1px solid ${props => props.theme.colors.gray[200]};
`;

const CardImage = styled.img`
  width: 100%;
  height: auto;
  display: block;
`;

// Compound component
export function Card({ children, ...props }) {
  return (
    <CardContext.Provider value={{}}>
      <StyledCard {...props}>{children}</StyledCard>
    </CardContext.Provider>
  );
}

// Named exports for subcomponents
Card.Header = CardHeader;
Card.Content = CardContent;
Card.Footer = CardFooter;
Card.Image = CardImage;

// Usage example
function CardExample() {
  return (
    <Card>
      <Card.Image src="image.jpg" alt="Card example" />
      <Card.Header>
        <h3>Card Title</h3>
      </Card.Header>
      <Card.Content>
        <p>This is the card content.</p>
      </Card.Content>
      <Card.Footer>
        <Button>Action</Button>
      </Card.Footer>
    </Card>
  );
}
```

### Theming System

Implement a robust theming system with TypeScript:

```typescript
// packages/core/src/createTheme.ts
import { baseTheme, Theme } from './tokens';

// Allow partial theme overrides
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

// Function to deeply merge theme objects
function deepMerge<T extends object>(target: T, source: DeepPartial<T>): T {
  const output = { ...target };
  
  if (isObject(target) && isObject(source)) {
    Object.keys(source).forEach(key => {
      if (isObject(source[key])) {
        if (!(key in target)) {
          Object.assign(output, { [key]: source[key] });
        } else {
          output[key] = deepMerge(target[key], source[key]);
        }
      } else {
        Object.assign(output, { [key]: source[key] });
      }
    });
  }
  
  return output;
}

// Helper function to check if value is an object
function isObject(item: any): item is object {
  return item && typeof item === 'object' && !Array.isArray(item);
}

// Create a new theme by extending the base theme
export function createTheme(overrides: DeepPartial<Theme> = {}): Theme {
  return deepMerge(baseTheme, overrides);
}

// Create a dark theme
export const darkTheme = createTheme({
  colors: {
    primary: {
      // Adjusted primary colors for dark theme
      500: '#3d8bfd', // Lightened primary color
    },
    background: {
      primary: '#121212',
      secondary: '#1e1e1e',
      tertiary: '#2c2c2c',
    },
    text: {
      primary: '#ffffff',
      secondary: '#a0a0a0',
      disabled: '#6c6c6c',
      inverse: '#121212',
    },
  },
  // Override other tokens as needed
});
```

### Configuration System

Implement a configuration system to allow customization:

```typescript
// packages/components/src/createComponents.ts
import { Theme } from '@design-system/core';

export type ComponentsConfig = {
  Button?: {
    defaultVariant?: 'primary' | 'secondary' | 'tertiary' | 'danger';
    defaultSize?: 'sm' | 'md' | 'lg';
  };
  Input?: {
    defaultVariant?: 'outline' | 'filled' | 'flushed';
  };
  // Configuration for other components
};

export type ComponentsTheme = Theme & {
  components: ComponentsConfig;
};

const defaultConfig: ComponentsConfig = {
  Button: {
    defaultVariant: 'primary',
    defaultSize: 'md',
  },
  Input: {
    defaultVariant: 'outline',
  },
  // Default configuration for other components
};

export function createComponents(config: Partial<ComponentsConfig> = {}): ComponentsConfig {
  return {
    ...defaultConfig,
    ...config,
    // Deep merge for nested configurations
    Button: {
      ...defaultConfig.Button,
      ...config.Button,
    },
    Input: {
      ...defaultConfig.Input,
      ...config.Input,
    },
    // Merge other component configurations
  };
}
```

### Global Style Reset

Provide a consistent baseline with a global style reset:

```typescript
// packages/core/src/GlobalStyles.ts
import { createGlobalStyle } from 'styled-components';
import { Theme } from './tokens';

export const GlobalStyles = createGlobalStyle<{ theme: Theme }>`
  *, *::before, *::after {
    box-sizing: border-box;
  }
  
  html {
    font-size: 16px;
    line-height: 1.5;
    -webkit-text-size-adjust: 100%;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  
  body {
    margin: 0;
    padding: 0;
    font-family: ${props => props.theme.typography.fontFamily.sans};
    color: ${props => props.theme.colors.text.primary};
    background-color: ${props => props.theme.colors.background.primary};
  }
  
  h1, h2, h3, h4, h5, h6 {
    margin-top: 0;
    margin-bottom: ${props => props.theme.spacing[4]};
    font-weight: ${props => props.theme.typography.fontWeight.bold};
    line-height: ${props => props.theme.typography.lineHeight.tight};
  }
  
  p {
    margin-top: 0;
    margin-bottom: ${props => props.theme.spacing[4]};
  }
  
  a {
    color: ${props => props.theme.colors.primary[500]};
    text-decoration: none;
    
    &:hover {
      text-decoration: underline;
    }
  }
  
  img {
    max-width: 100%;
    height: auto;
  }
  
  button,
  input,
  optgroup,
  select,
  textarea {
    font-family: inherit;
    font-size: 100%;
    line-height: 1.15;
    margin: 0;
  }
  
  // Additional reset styles...
`;
```

## Governance and Contribution Guidelines

Establish clear governance and contribution processes:

### Team Structure

1. **Core Team**: Responsible for overall direction, design tokens, and architecture
2. **Component Team**: Builds and maintains individual components
3. **Documentation Team**: Creates and maintains documentation
4. **QA Team**: Tests components for quality, performance, and accessibility

### Contribution Process

1. **Issue Creation**: File an issue describing the component or feature
2. **Design Review**: Get approval from the design team
3. **Development**: Implement the component with tests and documentation
4. **Code Review**: Peer review to ensure quality
5. **QA Testing**: Test for functionality, accessibility, and performance
6. **Documentation**: Ensure proper documentation
7. **Release**: Include in the next release

### Component Proposal Template

```markdown
# Component Proposal: [Component Name]

## Description
Brief description of the component and its purpose.

## User Need
Explain why users need this component and what problems it solves.

## Design
- Link to design mockups
- Visual design considerations
- Behavior specifications

## API Proposal
```jsx
<Component
  prop1="value1"
  prop2="value2"
>
  Children
</Component>
```

## Props
| Prop        | Type                  | Default     | Description           |
|-------------|:----------------------|:------------|:----------------------|
| `prop1`     | `string`              | `''`        | Description of prop1  |
| `prop2`     | `number`              | `0`         | Description of prop2  |
| `children`  | `ReactNode`           | -           | Component children    |

## Accessibility Considerations
- Keyboard navigation
- Screen reader support
- ARIA attributes

## Dependencies
- List any dependencies or related components

## Additional Considerations
- Edge cases
- Performance considerations
- Browser support
```

## Case Study: Enterprise Design System

Let me share a case study from a real enterprise design system implementation I worked on:

### The Challenge

A large financial services company had multiple product teams developing applications independently, resulting in:

- Inconsistent user experiences across products
- Duplicate development efforts
- Varying levels of accessibility compliance
- Slow development cycles
- Difficulty maintaining brand consistency

### The Solution

We implemented a comprehensive design system with these key elements:

1. **Design Tokens**: Created a single source of truth for colors, typography, spacing, and other design decisions
2. **Component Library**: Built 40+ accessible components with React and TypeScript
3. **Documentation**: Created extensive documentation with usage guidelines and examples
4. **Theme Support**: Implemented theming to support multiple brands and white-labeling
5. **Governance Process**: Established a cross-functional team to maintain and evolve the system

### The Results

After 6 months of implementation:

- **40% reduction** in development time for new features
- **90% consistency** across digital products
- **100% WCAG 2.1 AA compliance** for all components
- **35% reduction** in design debt
- **Improved collaboration** between design and development teams

## Common Pitfalls and How to Avoid Them

Based on my experience implementing design systems, here are common pitfalls and how to avoid them:

### 1. Over-engineering Components

**Problem**: Creating overly complex components that try to handle too many use cases.

**Solution**: Follow the single responsibility principle. Create simple, focused components that can be composed together.

### 2. Lacking Design Input

**Problem**: Building a component library without sufficient design input.

**Solution**: Ensure close collaboration between designers and developers from the start.

### 3. Poor Documentation

**Problem**: Components with inadequate documentation that developers struggle to use.

**Solution**: Document not just the API, but also usage patterns, accessibility considerations, and design guidelines.

### 4. Ignoring Accessibility

**Problem**: Focusing on visual appearance while neglecting accessibility.

**Solution**: Build accessibility in from the start, with automated and manual testing.

### 5. Insufficient Testing

**Problem**: Components that break in unexpected ways or don't work across browsers.

**Solution**: Implement comprehensive testing including unit tests, visual regression tests, and accessibility tests.

### 6. Resistance to Adoption

**Problem**: Teams reluctant to use the design system.

**Solution**: Focus on developer experience, provide migration paths, and showcase the benefits with metrics.

## Conclusion

Building a design system is a significant investment, but the returns are substantial: faster development, better user experiences, and more consistent products. The key is to approach it methodically, with clear goals and a focus on usability—both for end users and for the developers who will use your system.

As your design system matures, continually gather feedback from users and iterate accordingly. A design system is never "done"; it evolves alongside your products and organization.

If you're considering implementing a design system or need help optimizing an existing one, [contact me](/contact) for a consultation. I can help you create a tailored solution that meets your organization's specific needs.

## Additional Resources

- [Atomic Design by Brad Frost](https://atomicdesign.bradfrost.com/)
- [Design Systems Handbook by InVision](https://www.designbetter.co/design-systems-handbook)
- [Storybook](https://storybook.js.org/)
- [Styled Components](https://styled-components.com/)
- [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

            