<script setup>
// Lightweight, drop-in score card component using Tailwind utilities.
// Accepts simple props and renders the same visual as the HTML embed example,
// but as a Vue SFC you can import anywhere in the app.

import { computed } from 'vue'
import marganaLogo from '../assets/margana-logo.png'

const props = defineProps({
  // Formatted label, e.g. "24.11.2025" (you control the formatting)
  dateLabel: { type: String, default: '' },

  // Final score number
  totalScore: { type: [Number, String], default: 199 },

  // Anagram info – show row only if target > 0
  anagramUser: { type: Number, default: 10 },
  anagramTarget: { type: Number, default: 10 },

  // Totals for categories
  diagTotal: { type: Number, default: 23 },
  palTotal: { type: Number, default: 43 },
  semTotal: { type: Number, default: 31 },

  // Madness row shown only if available
  madnessAvailable: { type: Boolean, default: true },
  madnessFound: { type: Boolean, default: true },

  // Optional logo override (URL or imported asset). Defaults to local asset.
  logoSrc: { type: String, default: marganaLogo },
})

const showAnagram = computed(() => Number(props.anagramTarget) > 0)
const clampedAnagramUser = computed(() =>
  Math.max(0, Math.min(Number(props.anagramUser) || 0, Number(props.anagramTarget) || 0)),
)
</script>

<template>
  <!-- Outer card: mirrors ScoreShare visuals, no dependencies beyond Tailwind -->
  <div
    class="w-[200px] max-w-[92vw] rounded-xl border border-white/10 shadow-xl p-4 pt-4 text-indigo-50"
    style="background-color:#111827; background-image:linear-gradient(135deg,#111827 0%, #581c87 40%, #581c87 80%, #1e3a8a 100%);"
    role="group"
    aria-label="Margana score card">
    <span class="inline-block w-2 h-2 rounded-full bg-gradient-to-tr from-purple-500 to-orange-500 shadow"></span>
    <!-- Branding -->
    <div class="text-center -mt-5 font-extrabold text-white leading-none" aria-label="Margana">
      <div class="inline-flex items-center justify-center gap-1 text-[28px] leading-none">
        <img
          :src="logoSrc"
          class="logo-img h-[3.0em] align-middle -mr-9 select-none"
          alt=""
          aria-hidden="true"
          draggable="false"
        />
        <span class="text-xl">argana</span>
      </div>
      <div class="inline-block -mt-6 text-right text-[11px] text-white font-semibold" aria-hidden="true">
        <div>One play</div>
        <div>Multiple podiums</div>
      </div>
    </div>

    <!-- Header -->
    <div class="text-center mb-1">
      <div v-if="dateLabel" class="uppercase tracking-wider font-semibold text-[12px] text-indigo-200/85">
        {{ dateLabel }}
      </div>
      <div class="text-[24px] font-bold text-white/95">Final score</div>
      <div class="text-[56px] bg-gradient-to-tr from-purple-500 to-orange-500 font-black bg-clip-text text-transparent select-none">
        {{ totalScore }}
      </div>
    </div>

    <!-- Stats -->
    <div class="flex justify-center my-2">
      <div class="w-[280px] flex flex-col gap-2 min-w-0">
        <!-- Anagram -->
        <div v-if="showAnagram"
          class="w-full px-3 py-2 rounded-xl bg-gradient-to-tr from-purple-600 to-orange-600 text-white text-[13px] font-semibold shadow-md flex items-center justify-between"
        >
          <span>?????????</span>
          <span class="tabular-nums">{{ clampedAnagramUser }}/{{ anagramTarget }}</span>
        </div>

        <!-- Diagonals -->
        <div
          class="w-full px-3 py-2 rounded-xl bg-gradient-to-tr from-purple-500 to-fuchsia-600 text-white text-[13px] font-semibold shadow-md flex items-center justify-between">
          <span>?????????</span>
          <span class="tabular-nums">{{ diagTotal }}</span>
        </div>

        <!-- Palindrome -->
        <div
          class="w-full px-3 py-2 rounded-xl bg-gradient-to-tr from-fuchsia-600 via-pink-600 to-violet-700text-white text-[13px] font-semibold flex items-center justify-between shadow-lg">
          <span>?????????</span>
          <span class="tabular-nums">{{ palTotal }}</span>
        </div>

        <!-- Semordnilap -->
        <div
          class="w-full px-3 py-2 rounded-xl bg-gradient-to-tr from-amber-500 via-orange-500 to-rose-500 text-white text-[13px] font-semibold flex items-center justify-between shadow-lg"
        >
          <span>?????????</span>
          <span class="tabular-nums">{{ semTotal }}</span>
        </div>

        <!-- Madness -->
        <div
          v-if="madnessAvailable"
          class="w-full px-3 py-2 rounded-xl bg-gradient-to-tr from-fuchsia-600 via-violet-600 to-indigo-600 text-white text-[13px] font-semibold shadow-md flex items-center justify-between"
        >
          <span>?????????</span>
          <span>{{ madnessFound ? 'Found' : 'Not found' }}</span>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="mt-3 text-center text-[12px] text-indigo-200/80 font-semibold select-none">
      Margana
    </div>
  </div>
</template>

<style scoped>
.logo-img {
  image-rendering: -webkit-crisp-edges;
  image-rendering: crisp-edges;
  image-rendering: high-quality;
}
</style>
