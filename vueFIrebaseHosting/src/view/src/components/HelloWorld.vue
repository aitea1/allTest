<script setup>
defineProps({
  msg: {
    type: String,
    required: true,
  },
})
</script>

<template>
  <div class="greetings">
    <h1 class="green">{{ msg }}</h1>
    <h3>
      🚀 新しいデプロイテストが成功しました！ 🎉
    </h3>
    <p class="deploy-info">
      このプロジェクトは
      <a href="https://vite.dev/" target="_blank" rel="noopener">Vite</a> +
      <a href="https://vuejs.org/" target="_blank" rel="noopener">Vue 3</a>
      で作成され、Firebase Hostingでホストされています。
    </p>
    <div class="timestamp">
      最終更新: {{ new Date().toLocaleString('ja-JP') }}
    </div>
    <div class="version-info">
      ✨ バージョン 2.0 - デプロイ確認用 ✨
    </div>
  </div>
</template>

<style scoped>
h1 {
  font-weight: 500;
  font-size: 2.6rem;
  position: relative;
  top: -10px;
}

h3 {
  font-size: 1.2rem;
}

.greetings h1,
.greetings h3 {
  text-align: center;
}

.deploy-info {
  font-size: 1rem;
  margin: 1rem 0;
  color: #666;
  text-align: center;
}

.timestamp {
  font-size: 0.9rem;
  color: #888;
  text-align: center;
  margin: 0.5rem 0;
}

.version-info {
  font-size: 1.1rem;
  color: #42b883;
  text-align: center;
  margin: 1rem 0;
  font-weight: bold;
  padding: 10px;
  border: 2px solid #42b883;
  border-radius: 8px;
  background-color: rgba(66, 184, 131, 0.1);
}

@media (min-width: 1024px) {
  .greetings h1,
  .greetings h3 {
    text-align: left;
  }
  
  .deploy-info,
  .timestamp,
  .version-info {
    text-align: left;
  }
}
</style>
