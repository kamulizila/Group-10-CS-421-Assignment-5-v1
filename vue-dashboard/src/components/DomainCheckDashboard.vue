<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0">Domain Checks Dashboard</h4>
      </div>
      <div class="card-body">
        <div v-if="error" class="alert alert-danger">{{ error }}</div>
        <div v-else-if="loading" class="text-center">
          <div class="spinner-border text-success" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Loading domain checks...</p>
        </div>
        <table v-else class="table table-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Target URL</th>
              <th>Expires At</th>
              <th>Days to Expiry</th>
              <th>Checked At</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="domain in domainChecks" :key="domain.id">
              <td>{{ domain.id }}</td>
              <td>{{ domain.target_url.url }}</td>
              <td>{{ formatDate(domain.expires_at) }}</td>
              <td>{{ domain.days_to_expiry }}</td>
              <td>{{ formatDate(domain.checked_at) }}</td>
            </tr>
            <tr v-if="domainChecks.length === 0">
              <td colspan="5" class="text-muted text-center">No domain checks found.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      domainChecks: [],
      error: null,
      loading: true,
    };
  },
  mounted() {
    fetch("http://localhost:8000/api/domain-checks/")
      .then((res) => {
        if (!res.ok) throw new Error(`API responded with ${res.status}`);
        return res.json();
      })
      .then((data) => {
        this.domainChecks = data;
      })
      .catch((err) => {
        this.error = "Failed to fetch domain checks: " + err.message;
      })
      .finally(() => {
        this.loading = false;
      });
  },
  methods: {
    formatDate(dateStr) {
      return new Date(dateStr).toLocaleString();
    },
  },
};
</script>
