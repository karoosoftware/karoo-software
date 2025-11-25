import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
// Using a plain object to avoid importing 'vite' in config,
// which can fail if dev dependencies aren't installed yet.
export default {
  plugins: [vue()],
}
