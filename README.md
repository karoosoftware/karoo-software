# Karoosoftware Landing

A minimal Vue 3 + Vite + TailwindCSS landing page that displays: "hello Karoosofware".

## Prerequisites
- Node.js 18 or newer (see `package.json` engines)

## Quick Start

1. Install dependencies (recommended):
   - npm install

2. Start the dev server:
   - npm run dev

The app will be available at http://localhost:5173/

## Troubleshooting

- sh: vite: command not found
  - Cause: Local `vite` binary isn’t available. This happens if dependencies weren’t installed or `vite` isn’t globally installed.
  - Fixes:
    - Run `npm install` to install local dev dependencies.
    - Or simply run `npm run dev` (this project’s scripts use `npx vite`, which works even if you forgot to install first).
  - Ensure your Node version is >= 18.

## Scripts
- npm run dev — start Vite dev server
- npm run build — build for production
- npm run preview — preview the production build locally

## Tech Stack
- Vue 3
- Vite
- TailwindCSS
- PostCSS + Autoprefixer
