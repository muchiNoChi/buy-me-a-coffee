<template>
  <main>
    <BuyMeACoffeeMain />
  </main>
</template>

<script setup>
import BuyMeACoffeeMain from './components/BuyMeACoffeeMain.vue'
</script>

<style>
#app {
  text-align: center;
  color: var(--ep-text-color-primary);
  position: relative;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.main-container {
  height: calc(100vh - var(--ep-menu-item-height) - 3px);
}
</style>
