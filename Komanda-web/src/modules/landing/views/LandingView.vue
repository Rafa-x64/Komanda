<script setup lang="ts">
import AppHeader from '../components/AppHeader.vue';
import HeroSection from '../components/HeroSection.vue';
import FeaturesSection from '../components/FeaturesSection.vue';
import AboutSection from '../components/AboutSection.vue';
import ContactSection from '../components/ContactSection.vue';
import AppFooter from '../components/AppFooter.vue';
</script>

<template>
    <div class="landing-page">
        <AppHeader />

        <main>
            <HeroSection />
            <FeaturesSection />
            <AboutSection />
            <ContactSection />
        </main>

        <AppFooter />
    </div>
</template>

<style scoped>
.landing-page {
    /* Ensure footer stays at bottom even with short content */
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

main {
    flex: 1;
}
</style>