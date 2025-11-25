<template>
  <section class="border-t border-slate-800 pt-6">
    <!-- CENTERED HEADER -->
    <header class="mb-5 flex flex-col items-center text-center">
      <div class="space-y-1">
        <h2 class="text-lg font-semibold">Featured Word Game</h2>
        <p class="mx-auto max-w-xl text-sm text-slate-300">
          Here’s a peek at a word-based puzzle I’m currently building.
          A daily spark for word lovers who like to outsmart Margana
        </p>
      </div>
    </header>

    <!-- GRID BELOW CAN STAY AS-IS -->
    <div
        class="grid justify-items-center gap-6 md:gap-7 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,1.4fr)] lg:items-center"
    >
      <ScoreCardEmbed />

      <div class="space-y-3 text-left">
        <h3 class="text-sm font-semibold text-emerald-500 sm:text-base">
          Coming soon: Margana — your new daily word challenge
        </h3>
        <p class="mx-auto max-w-xl text-sm text-slate-100 sm:text-[0.95rem]">
          A gripping, fiendish puzzle that rewards sharp eyes and smart moves. Unlock a
          secret twist as you play, spot patterns in any direction, and outscore the
          house bot to climb the boards. It’s quick to learn, tough to master — and
          dangerously replayable.
        </p>
        <ul class="mx-auto max-w-xl list-inside space-y-1 text-xs text-slate-200 sm:text-sm">
          <li>⏱️ Bite-size daily challenge with satisfying reveals</li>
          <li>🪞 Mirror-words and clever constructions can turbo-charge your score</li>
          <li>🧩 Letters you use can unlock something bigger — if you plan ahead</li>
          <li>🏆 Beat Margana, chase streaks, and compete across multiple leaderboards</li>
        </ul>
        <div class="flex flex-col gap-2 pt-1 sm:flex-row sm:items-center">
          <button
            ref="triggerBtn"
            type="button"
            @click="openModal"
            class="inline-flex w-full items-center justify-center rounded-lg bg-gradient-to-tr from-purple-500 to-orange-500 px-4 py-2 text-center text-xs font-semibold text-white shadow-[0_10px_24px_rgba(192,38,211,0.22)] transition hover:from-purple-400 hover:to-orange-400 focus:outline-none focus:ring-2 focus:ring-purple-400/60 sm:w-auto"
          >
            Register for early access
          </button>
          <p class="text-xs text-slate-400">
            Limited spots for early adoption testing
          </p>
        </div>
      </div>
    </div>
    
    <!-- Modal: Early Access Registration -->
    <transition name="fade">
      <div
        v-if="showModal"
        class="fixed inset-0 z-50 flex items-center justify-center"
        aria-labelledby="early-access-title"
        role="dialog"
        aria-modal="true"
      >
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-black/70 backdrop-blur-sm" @click="closeModal" />

        <!-- Dialog -->
        <div
          class="relative z-10 w-[92vw] rounded-2xl border border-white/10 shadow-2xl"
          :class="submitted ? 'max-w-sm' : 'max-w-lg'"
          style="background-color:#111827; background-image:linear-gradient(135deg,#111827 0%, #581c87 40%, #581c87 80%, #1e3a8a 100%);"
        >
          <!-- When NOT submitted: show full form -->
          <template v-if="!submitted">
            <!-- Header -->
            <div class="flex items-center justify-between px-5 pt-4">
              <h3 id="early-access-title" class="text-base font-semibold text-indigo-50">
                Join the Margana Early Adopters
              </h3>
              <button @click="closeModal" class="rounded-md p-1 text-indigo-200/80 hover:bg-white/5 focus:outline-none focus:ring-2 focus:ring-indigo-400/60" aria-label="Close">
                ✕
              </button>
            </div>

            <!-- Accent separator -->
            <div class="mx-5 mt-3 h-1 rounded-full bg-gradient-to-tr from-purple-500 to-orange-500" />

            <!-- Body / Form -->
            <form @submit.prevent="submitForm" class="px-5 pb-5 pt-4 text-indigo-50">
              <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
                <div class="sm:col-span-1">
                  <label for="firstName" class="mb-1 block text-xs font-semibold text-indigo-200/85">Name</label>
                  <input
                    ref="firstInput"
                    v-model.trim="form.firstName"
                    id="firstName"
                    type="text"
                    required
                    class="w-full rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm placeholder-indigo-200/40 shadow-inner outline-none focus:border-purple-400/60 focus:ring-2 focus:ring-purple-500/30"
                    placeholder="Your name"
                  />
                </div>
                <div class="sm:col-span-1">
                  <label for="surname" class="mb-1 block text-xs font-semibold text-indigo-200/85">Surname</label>
                  <input
                    v-model.trim="form.surname"
                    id="surname"
                    type="text"
                    required
                    class="w-full rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm placeholder-indigo-200/40 shadow-inner outline-none focus:border-purple-400/60 focus:ring-2 focus:ring-purple-500/30"
                    placeholder="Your surname"
                  />
                </div>
                <div class="sm:col-span-2">
                  <label for="email" class="mb-1 block text-xs font-semibold text-indigo-200/85">Email</label>
                  <input
                    v-model.trim="form.email"
                    id="email"
                    type="email"
                    required
                    class="w-full rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm placeholder-indigo-200/40 shadow-inner outline-none focus:border-purple-400/60 focus:ring-2 focus:ring-purple-500/30"
                    placeholder="you@example.com"
                  />
                </div>
                <div class="sm:col-span-1">
                  <label for="age" class="mb-1 block text-xs font-semibold text-indigo-200/85">Age range</label>
                  <select
                    v-model="form.ageRange"
                    id="age"
                    required
                    class="w-full rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm shadow-inner outline-none focus:border-purple-400/60 focus:ring-2 focus:ring-purple-500/30"
                  >
                    <option value="" disabled>Select range</option>
                    <option>Under 18</option>
                    <option>18–24</option>
                    <option>25–34</option>
                    <option>35–44</option>
                    <option>45–54</option>
                    <option>55–64</option>
                    <option>65+</option>
                  </select>
                </div>
                <div class="sm:col-span-1">
                  <label for="frequency" class="mb-1 block text-xs font-semibold text-indigo-200/85">How often do you play word games?</label>
                  <select
                    v-model="form.frequency"
                    id="frequency"
                    required
                    class="w-full rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm shadow-inner outline-none focus:border-purple-400/60 focus:ring-2 focus:ring-purple-500/30"
                  >
                    <option value="" disabled>Select one</option>
                    <option>Daily</option>
                    <option>Weekly</option>
                    <option>Monthly</option>
                  </select>
                </div>
                <div class="sm:col-span-2">
                  <label for="referrer" class="mb-1 block text-xs font-semibold text-indigo-200/85">Where did you hear about us?</label>
                  <select
                    v-model="form.referrer"
                    id="referrer"
                    required
                    class="w-full rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm shadow-inner outline-none focus:border-purple-400/60 focus:ring-2 focus:ring-purple-500/30"
                  >
                    <option value="" disabled>Select a source</option>
                    <option>Friend or family</option>
                    <option>Social media</option>
                    <option>Search engine</option>
                    <option>Email or newsletter</option>
                    <option>Other</option>
                  </select>
                </div>
              </div>

              <!-- Actions -->
              <div class="mt-5 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-end">
                <button type="button" @click="closeModal" class="rounded-lg border border-white/15 px-4 py-2 text-xs font-semibold text-indigo-200 hover:bg-white/5 focus:outline-none focus:ring-2 focus:ring-indigo-400/60">
                  Cancel
                </button>
                <button
                  type="submit"
                  :disabled="!isValid || isSubmitting"
                  :aria-disabled="!isValid || isSubmitting"
                  class="rounded-lg bg-gradient-to-tr from-purple-500 to-orange-500 px-4 py-2 text-xs font-semibold text-white shadow-[0_10px_24px_rgba(236,72,153,0.22)] transition hover:from-purple-400 hover:to-orange-400 disabled:cursor-not-allowed disabled:opacity-50 focus:outline-none focus:ring-2 focus:ring-purple-400/60"
                >
                  {{ isSubmitting ? 'Submitting…' : 'Submit' }}
                </button>
              </div>
            </form>
          </template>

          <!-- After submission: compact thank-you box -->
          <template v-else>
            <div class="px-6 py-8 text-center">
              <div class="mx-auto mb-3 inline-flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-tr from-purple-500 to-orange-500 text-white shadow-lg">
                ✓
              </div>
              <div class="text-sm font-semibold text-indigo-50">Thank you!</div>
              <p class="mt-1 text-xs text-indigo-200/85">We will be in touch soon.</p>
            </div>
          </template>
        </div>
      </div>
    </transition>
  </section>
</template>

<script setup>
import ScoreCardEmbed from './ScoreCardEmbed.vue'
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'

const showModal = ref(false)
const submitted = ref(false)
const triggerBtn = ref(null)
const firstInput = ref(null)
let dismissTimer = null
const API_URL = 'https://1uyuyru13f.execute-api.eu-west-2.amazonaws.com/prod/early_adoption_form' // your API Gateway endpoint

// Track submission in progress to prevent double submits and disable the button immediately
const isSubmitting = ref(false)

const form = ref({
  firstName: '',
  surname: '',
  email: '',
  ageRange: '',
  frequency: '',
  referrer: '',
})

const isValid = computed(() => {
  return (
    form.value.firstName.trim() !== '' &&
    form.value.surname.trim() !== '' &&
    /.+@.+\..+/.test(form.value.email) &&
    String(form.value.ageRange).trim() !== '' &&
    String(form.value.frequency).trim() !== '' &&
    String(form.value.referrer).trim() !== ''
  )
})

function openModal() {
  submitted.value = false
  showModal.value = true
  // focus first input after modal renders
  nextTick(() => {
    setTimeout(() => firstInput.value?.focus(), 0)
  })
}

function closeModal() {
  showModal.value = false
  submitted.value = false
  if (dismissTimer) {
    clearTimeout(dismissTimer)
    dismissTimer = null
  }
  nextTick(() => triggerBtn.value?.focus())
}

function onKeydown(e) {
  if (e.key === 'Escape' && showModal.value) {
    e.preventDefault()
    closeModal()
  }
}

async function submitForm() {
  if (!isValid.value || isSubmitting.value) return

  isSubmitting.value = true

  // form is a ref → the actual object is in form.value
  const payload = { ...form.value }

  try {
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }

    const data = await response.json()
    console.log('Lambda response:', data)

    // your existing behaviour
    submitted.value = true

    if (dismissTimer) {
      clearTimeout(dismissTimer)
    }
    dismissTimer = setTimeout(() => {
      closeModal()
    }, 3000)
  } catch (error) {
    console.error('Error submitting form to Lambda:', error)
    // optional: show an error message in the UI here
  } finally {
    // Re-enable the button in case of error; harmless after success as the form view is replaced
    isSubmitting.value = false
  }
}

onMounted(() => {
  window.addEventListener('keydown', onKeydown)
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
})
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.18s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
