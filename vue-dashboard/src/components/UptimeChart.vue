<template>
  <div>
    <div v-if="loading" class="text-center">
      <div class="spinner-border text-info" role="status">
        <span class="visually-hidden">Loading chart data...</span>
      </div>
      <p>Loading chart data...</p>
    </div>

    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>

    <div v-else-if="chartData">
      <Line :data="chartData" :options="options" />
    </div>

    <div v-else>
      <p>No chart data available.</p>
    </div>
  </div>
</template>

<script>
import { Line } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement
} from 'chart.js'

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement
)

export default {
  name: 'UptimeChart',
  components: {
    Line
  },
  props: {
    targetId: {
      type: [String, Number],
      required: true
    }
  },
  data() {
    return {
      chartData: null,
      loading: false,
      error: null,
      options: {
        responsive: true,
        interaction: {
          mode: 'index',
          intersect: false
        },
        stacked: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          title: {
            display: true,
            text: 'Status Code & Response Time Last 24h'
          }
        },
        scales: {
          y: {
            type: 'linear',
            display: true,
            position: 'left',
            title: {
              display: true,
              text: 'Status Code'
            },
            min: 0,
            max: 600,
            ticks: {
              stepSize: 100
            }
          },
          y1: {
            type: 'linear',
            display: true,
            position: 'right',
            grid: {
              drawOnChartArea: false
            },
            title: {
              display: true,
              text: 'Response Time (ms)'
            },
            min: 0
          },
          x: {
            title: {
              display: true,
              text: 'Time (HH:MM)'
            }
          }
        }
      }
    }
  },
  watch: {
    targetId(newId) {
      if (newId) {
        this.fetchChartData(newId)
      }
    }
  },
  methods: {
    fetchChartData(id) {
      this.loading = true
      this.error = null
      this.chartData = null

      fetch(`http://localhost:8000/api/status_24h/${id}/`)
        .then(res => {
          if (res.status === 404) {
            throw new Error('This target has been deleted or does not exist.')
          }
          if (!res.ok) {
            throw new Error(`HTTP error ${res.status}`)
          }
          return res.json()
        })
        .then(data => {
          if (!data.length) {
            this.chartData = null
            this.error = 'No chart data available.'
            return
          }

          this.chartData = {
            labels: data.map(entry =>
              new Date(entry.timestamp).toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit'
              })
            ),
            datasets: [
              {
                label: 'Status Code (200=OK, 500=Error)',
                data: data.map(entry => entry.status_code),
                borderColor: 'green',
                backgroundColor: 'rgba(0, 128, 0, 0.2)',
                yAxisID: 'y',
                tension: 0.3,
                fill: false
              },
              {
                label: 'Response Time (ms)',
                data: data.map(entry => entry.response_time),
                borderColor: 'blue',
                backgroundColor: 'rgba(0, 0, 255, 0.2)',
                yAxisID: 'y1',
                tension: 0.3,
                fill: false
              }
            ]
          }
        })
        .catch(err => {
          this.chartData = null
          this.error = err.message

          // Optional: emit an event if the target is not found
          if (err.message.includes('deleted or does not exist')) {
            this.$emit('targetDeleted', id)

            // Optional: redirect to targets page
            // this.$router.push('/targets')
          }
        })
        .finally(() => {
          this.loading = false
        })
    }
  },
  mounted() {
    if (this.targetId) {
      this.fetchChartData(this.targetId)
    }
  }
}
</script>

<style scoped>
.spinner-border {
  width: 3rem;
  height: 3rem;
}
</style>
