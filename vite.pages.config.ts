import {defineConfig} from 'vite';
import react from '@vitejs/plugin-react';
export default defineConfig({root:'work/pages-src',plugins:[react()],publicDir:false,build:{outDir:'../../docs',emptyOutDir:true}});
