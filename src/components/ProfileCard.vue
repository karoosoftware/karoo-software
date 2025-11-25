<template>
  <div class="flex flex-col items-center gap-4 rounded-2xl bg-slate-900/90 px-4 py-3 text-center">
    <img
      :src="paulImg"
      alt="Paul Bradbury"
      class="w-40 sm:w-96 md:w-96 rounded-xl ring-1 ring-slate-600 shadow-[0_10px_20px_rgba(0,0,0,0.5)]"
    />
    <div>
      <p class="text-sm text-white">
        Software & infrastructure engineer &amp; indie game developer
      </p>
      <p class="mt-1 text-base italic text-emerald-500">
        “Running free in the forest of innovation”
      </p>
    </div>
  </div>
</template>

<script setup>
import paulImg from '../assets/paul_bradbury.jpg'
</script>
