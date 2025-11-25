<template>
  <section
      class="flex flex-col items-center gap-6 md:flex-row md:items-center md:justify-between md:gap-8"
  >
    <div class="flex-1 space-y-4 md:max-w-xl">
      <div class="space-y-3 text-center">
        <h1
            class="pb-5 text-balance text-3xl font-extrabold leading-tight text-purple-500 sm:text-4xl md:text-[2.4rem]">
          Word puzzles on serverless rails
        </h1>
        <p class="mx-auto max-w-xl text-sm text-slate-200 sm:text-base">
          I design word games that stretch your thinking, deployed on a fully serverless stack
          and defined with infrastructure-as-code for clean, reproducible environments.
        </p>
      </div>
    </div>

    <ProfileCard />
  </section>
</template>



<script setup>
import ProfileCard from './ProfileCard.vue'
</script>
