import { createRouter, createWebHistory } from 'vue-router'

// Import your dashboard components
import TargetList from './components/TargetList.vue'
import StatusDashboard from './components/StatusDashboard.vue'
import AlertsDashboard from './components/AlertsDashboard.vue'
import HistoryDashboard from './components/HistoryDashboard.vue'
import SSLCheckDashboard from './components/SSLCheckDashboard.vue'
import DomainCheckDashboard from './components/DomainCheckDashboard.vue'
import UptimeChart from './components/UptimeChart.vue'

const routes = [
  { path: '/', redirect: '/targets' }, // default redirect
  { path: '/targets', component: TargetList },
  { path: '/status', component: StatusDashboard },
  { path: '/alerts', component: AlertsDashboard },
  { path: '/history', component: HistoryDashboard },
  { path: '/ssl-checks', component: SSLCheckDashboard },       // fixed here
  { path: '/domain-checks', component: DomainCheckDashboard }, // fixed here
  { path: '/uptime', component: UptimeChart },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
