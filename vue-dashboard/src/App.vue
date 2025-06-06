<template>
  <div id="app">
    <!-- Navigation bar should go here, so it shows on every page -->
    <nav>
      <ul class="nav nav-pills justify-content-center mb-4">
        <li class="nav-item">
          <router-link to="/targets" class="nav-link" active-class="active">Targets</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/status" class="nav-link" active-class="active">Status</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/alerts" class="nav-link" active-class="active">Alerts</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/history" class="nav-link" active-class="active">History</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/ssl-checks" class="nav-link" active-class="active">SSL Checks</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/domain-checks" class="nav-link" active-class="active">Domain Checks</router-link>
        </li>
        <!-- <li class="nav-item">
          <router-link to="/uptime" class="nav-link" active-class="active">24h Uptime</router-link>
        </li> -->
      </ul>
    </nav>

    <!-- This will render the component for the current route -->
    <router-view />
  </div>
  
</template>

<script>
export default {
  name: 'App',
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

/* You can add some Bootstrap or custom styles for nav */
.nav-pills .nav-link.active {
  background-color: #007bff;
  color: white;
}
</style>
