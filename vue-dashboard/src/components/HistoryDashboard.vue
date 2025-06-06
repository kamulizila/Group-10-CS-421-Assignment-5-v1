<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-secondary text-white">
        <h4 class="mb-0">History Dashboard</h4>
      </div>
      <div class="card-body">
        <div v-if="error" class="alert alert-danger">{{ error }}</div>
        <div v-else-if="loading" class="text-center">
          <div class="spinner-border text-secondary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Loading history...</p>
        </div>
        <table v-else class="table table-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Target URL</th>
              <th>Status Code</th>
              <th>Latency (ms)</th>
              <th>Checked At</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="entry in history" :key="entry.id">
              <td>{{ entry.id }}</td>
              <td>{{ entry.target_url || 'N/A' }}</td>
              <td>
                <span :class="getStatusClass(entry.status_code)">
                  {{ entry.status_code }}
                </span>
              </td>
              <td>{{ entry.latency_ms?.toFixed(2) || 'N/A' }}</td>
              <td>{{ formatDate(entry.checked_at) }}</td>
            </tr>
            <tr v-if="history.length === 0">
              <td colspan="5" class="text-muted text-center">No history found.</td>
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
      history: [],
      error: null,
      loading: true,
    };
  },
  async mounted() {
    try {
      const response = await fetch("http://localhost:8000/api/history/");
      if (!response.ok) throw new Error(`API responded with ${response.status}`);
      const data = await response.json();
      this.history = Array.isArray(data) ? data : [];
    } catch (err) {
      this.error = "Failed to fetch history: " + err.message;
      console.error(err);
    } finally {
      this.loading = false;
    }
  },
  methods: {
    formatDate(dateStr) {
      if (!dateStr) return 'N/A';
      const date = new Date(dateStr);
      return isNaN(date.getTime()) ? 'Invalid date' : date.toLocaleString();
    },
    getStatusClass(statusCode) {
      if (statusCode >= 200 && statusCode < 300) return 'text-success';
      if (statusCode >= 300 && statusCode < 400) return 'text-warning';
      if (statusCode >= 400) return 'text-danger';
      return '';
    }
  }
};
</script>

<style scoped>
.text-success { color: #28a745; }
.text-warning { color: #ffc107; }
.text-danger { color: #dc3545; }
</style>