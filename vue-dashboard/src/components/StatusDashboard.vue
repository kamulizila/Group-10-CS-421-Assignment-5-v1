<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-info text-white">
        <h4 class="mb-0">Status Dashboard</h4>
      </div>
      <div class="card-body">
        <div v-if="error" class="alert alert-danger">{{ error }}</div>

        <div v-else-if="loading" class="text-center">
          <div class="spinner-border text-info" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Loading statuses...</p>
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
            <tr v-for="item in statuses" :key="item.id">
              <td>{{ item.id }}</td>
              <td>
                <a :href="item.target_url" target="_blank" rel="noopener noreferrer">
                  {{ item.target_url || 'N/A' }}
                </a>
              </td>
              <td>
                <span :class="getStatusCodeClass(item.status_code)">
                  {{ item.status_code }}
                </span>
              </td>
              <td>{{ item.latency_ms.toFixed(2) }}</td>
              <td>{{ formatDate(item.checked_at) }}</td>
            </tr>
            <tr v-if="statuses.length === 0">
              <td colspan="5" class="text-muted text-center">No status records found.</td>
            </tr>
          </tbody>
        </table>

        <!-- UptimeChart component inserted here -->
        <div class="mt-4">
          <h5>Uptime Chart for Target {{ selectedTargetId }}</h5>
          <UptimeChart :targetId="selectedTargetId" @targetDeleted="handleTargetDeleted" />
        </div>

      </div>
    </div>
  </div>
</template>

<script>
import UptimeChart from '@/components/UptimeChart.vue'  // Adjust path if needed

export default {
  components: {
    UptimeChart,
  },
  data() {
    return {
      statuses: [],
      error: null,
      loading: true,
      selectedTargetId: null,
    };
  },
  mounted() {
    this.fetchStatusData();
  },
  methods: {
    async fetchStatusData() {
      try {
        const response = await fetch("http://localhost:8000/api/status/latest/");
        if (!response.ok) {
          throw new Error(`API responded with status ${response.status}`);
        }
        const data = await response.json();
        this.statuses = Array.isArray(data) ? data : [];
        // Set default selectedTargetId as first status id, or null if none
        this.selectedTargetId = this.statuses.length > 0 ? this.statuses[0].id : null;
      } catch (err) {
        this.error = "Failed to fetch statuses: " + err.message;
        console.error("Error fetching status data:", err);
      } finally {
        this.loading = false;
      }
    },
    formatDate(dateStr) {
      const date = new Date(dateStr);
      return isNaN(date.getTime()) ? "Invalid date" : date.toLocaleString();
    },
    getStatusCodeClass(statusCode) {
      if (statusCode >= 200 && statusCode < 300) return 'text-success';
      if (statusCode >= 300 && statusCode < 400) return 'text-warning';
      if (statusCode >= 400) return 'text-danger';
      return '';
    },
  },
};
</script>

<style scoped>
.text-success { color: #28a745; font-weight: bold; }
.text-warning { color: #ffc107; font-weight: bold; }
.text-danger { color: #dc3545; font-weight: bold; }
</style>
