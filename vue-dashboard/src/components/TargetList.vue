<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Targets Dashboard</h4>
      </div>
    <!-- <UptimeChart :targetId="someTargetId" /> -->

      <div class="card-body">
        <div v-if="error" class="alert alert-danger">
          {{ error }}
        </div>

        <div v-else-if="loading" class="text-center">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Loading targets...</p>
        </div>

        <div v-else>
          <table class="table table-striped table-hover">
            <thead class="table-primary">
              <tr>
                <th>ID</th>
                <th>URL</th>
                <th>Status</th>
                <th>Description</th>
                <th>Created At</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="t in targets" :key="t.id">
                <td>{{ t.id || 'N/A' }}</td>
                <td class="text-break">
                  <a :href="t.url" target="_blank">{{ t.url }}</a>
                </td>
                <td>
                  <span
                    class="badge"
                    :class="{
                      'bg-success': t.status && t.status.includes('Up'),
                      'bg-warning': t.status && t.status.includes('Redirect'),
                      'bg-danger': t.status && (t.status.includes('Error') || t.status.includes('Unavailable') || t.status.includes('Forbidden') || t.status.includes('Not Found')),
                      'bg-secondary': !t.status || t.status === 'N/A'
                    }"
                    :title="t.status"
                  >
                    {{ simplifyStatus(t.status) }}
                  </span>
                </td>
                <td>{{ t.description || 'N/A' }}</td>
                <td>{{ formatDate(t.created_at) }}</td>
              </tr>
              <tr v-if="targets.length === 0">
                <td colspan="5" class="text-center text-muted">No targets found.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "TargetsDashboard",
  data() {
    return {
      targets: [],
      loading: true,
      error: null,
    };
  },
  mounted() {
    fetch("http://localhost:8000/api/targets/")
      .then((res) => {
        if (!res.ok) throw new Error(`Error: ${res.status}`);
        return res.json();
      })
      .then((data) => {
        this.targets = data.results || data;
      })
      .catch((err) => {
        this.error = err.message;
      })
      .finally(() => {
        this.loading = false;
      });
  },
  methods: {
    formatDate(dateStr) {
      if (!dateStr) return "N/A";
      const options = {
        year: "numeric",
        month: "short",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
      };
      return new Date(dateStr).toLocaleString(undefined, options);
    },
    simplifyStatus(status) {
      if (!status) return "N/A";

      if (status.includes("NameResolutionError")) {
        return "Unavailable (DNS failed)";
      }
      if (status.includes("Failed to establish a new connection")) {
        return "Unavailable (Connection failed)";
      }
      if (status.includes("Max retries exceeded")) {
        return "Unavailable (Retry limit)";
      }
      if (status.length > 100) {
        return status.substring(0, 80) + "...";
      }
      return status;
    }
  },
};
</script>
<style scoped>
.text-break {
  word-break: break-word;
}
</style>
