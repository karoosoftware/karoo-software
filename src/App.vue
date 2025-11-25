<!-- HomeViewLowPoly.vue -->
<template>
  <main class="relative flex min-h-screen justify-center overflow-hidden
        bg-[radial-gradient(circle_at_center,#020617_0,#000_70%)] px-4 py-10 text-slate-50 md:py-14">
    <!-- colourful low-poly triangles -->
    <div class="tri--one pointer-events-none absolute -left-10 -top-10 h-[420px] w-[420px] bg-gradient-to-br
         from-orange-500 via-pink-500 to-fuchsia-500 drop-shadow-[0_18px_40px_rgba(0,0,0,0.7)]">
    </div>
    <div
        class="tri--two pointer-events-none absolute -left-20 top-[40%] h-[420px] w-[420px] bg-gradient-to-br
        from-emerald-500 to-cyan-500 drop-shadow-[0_18px_40px_rgba(0,0,0,0.7)]">
    </div>
    <div
        class="tri--three pointer-events-none absolute -right-20 top-[10%] h-[420px] w-[420px] bg-gradient-to-br
        from-blue-500 to-violet-500 drop-shadow-[0_18px_40px_rgba(0,0,0,0.7)]">
    </div>
    <div
        class="tri--four pointer-events-none absolute bottom-[-120px] right-10 h-[420px] w-[420px] bg-gradient-to-br
        from-rose-500 to-amber-300 drop-shadow-[0_18px_40px_rgba(0,0,0,0.7)]">
    </div>

    <!-- top-left logo on background -->
    <img
      :src="karooLogo"
      alt="Karoo Software logo"
      class="pointer-events-none absolute left-4 top-2 z-[1] h-8 opacity-80 sm:h-10 md:h-12"
    />

    <!-- page card -->
    <PageCard>

      <!-- HERO -->
      <HeroSection />

      <!-- WORD GAME PREVIEW -->
      <WorkGamePreview />

      <!-- FOOTER -->
      <FooterSection />

    </PageCard>
  </main>
</template>

<script setup>
import PageCard from './components/PageCard.vue'
import HeroSection from './components/HeroSection.vue'
import WorkGamePreview from './components/WorkGamePreview.vue'
import FooterSection from './components/FooterSection.vue'
import karooLogo from './assets/karoo_software_logo-full.svg'
</script>

<style scoped>
/* only for the triangle shapes */
.tri--one {
  clip-path: polygon(0 0, 100% 10%, 10% 80%);
}
.tri--two {
  clip-path: polygon(0 40%, 80% 0, 100% 100%);
}
.tri--three {
  clip-path: polygon(10% 0, 100% 20%, 40% 100%);
}
.tri--four {
  clip-path: polygon(0 0, 80% 40%, 40% 100%);
}
</style>
