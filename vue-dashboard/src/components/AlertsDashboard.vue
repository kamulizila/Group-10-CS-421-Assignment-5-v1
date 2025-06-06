<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-danger text-white">
        <h4 class="mb-0">Alerts Dashboard</h4>
      </div>
      <div class="card-body">
        <div v-if="error" class="alert alert-danger">{{ error }}</div>
        <div v-else-if="loading" class="text-center">
          <div class="spinner-border text-danger" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Loading alerts...</p>
        </div>
        <table v-else class="table table-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Target</th>
              <th>Message</th>
              <th>Created At</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="alert in alerts" :key="alert.id">
              <td>{{ alert.id }}</td>
              <td>{{ alert.target_url }}</td>
              <td>{{ alert.message }}</td>
              <td>{{ formatDate(alert.created_at) }}</td>
            </tr>
            <tr v-if="alerts.length === 0">
              <td colspan="4" class="text-muted text-center">No alerts found.</td>
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
      alerts: [],
      error: null,
      loading: true,
    };
  },
  mounted() {
    fetch("http://localhost:8000/api/alerts/")
      .then((res) => {
        if (!res.ok) throw new Error(`API responded with ${res.status}`);
        return res.json();
      })
      .then((data) => {
        this.alerts = data;
      })
      .catch((err) => {
        this.error = "Failed to fetch alerts: " + err.message;
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
