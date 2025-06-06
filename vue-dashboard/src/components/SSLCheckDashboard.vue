<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-warning text-white">
        <h4 class="mb-0">SSL Checks Dashboard</h4>
      </div>
      <div class="card-body">
        <div v-if="error" class="alert alert-danger">{{ error }}</div>

        <div v-else-if="loading" class="text-center">
          <div class="spinner-border text-warning" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Loading SSL checks...</p>
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
            <tr v-for="ssl in sortedSslChecks" :key="ssl.id" :class="rowClass(ssl.days_to_expiry)">
              <td>{{ ssl.id }}</td>
              <td>{{ ssl.target_url }}</td>
              <td>{{ formatDate(ssl.expires_at) }}</td>
              <td>
                {{ ssl.days_to_expiry }}
                <span v-if="ssl.days_to_expiry <= 7" class="badge bg-danger ms-2">URGENT</span>
                <span v-else-if="ssl.days_to_expiry <= 30" class="badge bg-warning text-dark ms-2">Soon</span>
              </td>
              <td>{{ formatDate(ssl.checked_at) }}</td>
            </tr>
            <tr v-if="sslChecks.length === 0">
              <td colspan="5" class="text-muted text-center">No SSL checks found.</td>
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
      sslChecks: [],
      error: null,
      loading: true,
    };
  },
  computed: {
    sortedSslChecks() {
      return this.sslChecks.slice().sort((a, b) => new Date(a.expires_at) - new Date(b.expires_at));
    },
  },
  mounted() {
    fetch("http://localhost:8000/api/ssl-checks/")
      .then((res) => {
        if (!res.ok) throw new Error(`API responded with ${res.status}`);
        return res.json();
      })
      .then((data) => {
        this.sslChecks = data;
      })
      .catch((err) => {
        this.error = "Failed to fetch SSL checks: " + err.message;
      })
      .finally(() => {
        this.loading = false;
      });
  },
  methods: {
    formatDate(dateStr) {
      return new Date(dateStr).toLocaleString();
    },
    rowClass(daysToExpiry) {
      if (daysToExpiry <= 7) return "table-danger";
      if (daysToExpiry <= 30) return "table-warning";
      return "table-success";
    },
  },
};
</script>
