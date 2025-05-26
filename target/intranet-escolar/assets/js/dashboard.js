import { Chart } from "@/components/ui/chart"
/**
 * JavaScript específico para el dashboard
 */

document.addEventListener("DOMContentLoaded", () => {
  initializeDashboard()
})

/**
 * Inicializa el dashboard
 */
function initializeDashboard() {
  initializeCharts()
  initializeRefreshButton()
  initializeQuickActions()
  loadRecentActivity()
}

/**
 * Inicializa los gráficos
 */
function initializeCharts() {
  if (typeof Chart === "undefined") {
    console.warn("Chart.js no está disponible")
    return
  }

  initializeMatriculaChart()
  initializeGeneroChart()
}

/**
 * Inicializa el gráfico de matrícula por nivel
 */
function initializeMatriculaChart() {
  const ctx = document.getElementById("matriculaPorNivelChart")
  if (!ctx) return

  // Los datos vienen del JSP
  const inicial = Number.parseInt(ctx.dataset.inicial) || 0
  const primaria = Number.parseInt(ctx.dataset.primaria) || 0
  const secundaria = Number.parseInt(ctx.dataset.secundaria) || 0

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: ["Inicial", "Primaria", "Secundaria"],
      datasets: [
        {
          label: "Estudiantes",
          data: [inicial, primaria, secundaria],
          backgroundColor: ["#110d59", "#28a745", "#f70617"],
          borderColor: ["#110d59", "#28a745", "#f70617"],
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            stepSize: 1,
          },
        },
      },
    },
  })
}

/**
 * Inicializa el gráfico de distribución por género
 */
function initializeGeneroChart() {
  const ctx = document.getElementById("distribucionGeneroChart")
  if (!ctx) return

  // Los datos vienen del JSP
  const masculino = Number.parseInt(ctx.dataset.masculino) || 0
  const femenino = Number.parseInt(ctx.dataset.femenino) || 0

  new Chart(ctx, {
    type: "pie",
    data: {
      labels: ["Masculino", "Femenino"],
      datasets: [
        {
          data: [masculino, femenino],
          backgroundColor: ["#110d59", "#f70617"],
          borderColor: ["#110d59", "#f70617"],
          borderWidth: 2,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  })
}

/**
 * Inicializa el botón de actualizar
 */
function initializeRefreshButton() {
  const refreshBtn = document.getElementById("refreshData")
  if (!refreshBtn) return

  refreshBtn.addEventListener("click", () => {
    refreshDashboardData()
  })
}

/**
 * Actualiza los datos del dashboard
 */
function refreshDashboardData() {
  const refreshBtn = document.getElementById("refreshData")

  // Cambiar estado del botón
  const originalText = refreshBtn.innerHTML
  refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Actualizando...'
  refreshBtn.disabled = true

  // Realizar petición
  // Assuming IntranetApp is defined globally or imported
  if (typeof IntranetApp === "undefined" || !IntranetApp.contextPath) {
    console.error("IntranetApp or IntranetApp.contextPath is not defined.")
    showNotification("Error de configuración", "danger")
    refreshBtn.innerHTML = originalText
    refreshBtn.disabled = false
    return
  }

  fetch(`${IntranetApp.contextPath}/controller/dashboard?action=refresh`)
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        // Actualizar estadísticas
        updateStatistics(data.statistics)

        // Recargar gráficos
        updateCharts(data.charts)

        // Mostrar notificación
        showNotification("Datos actualizados correctamente", "success")
      } else {
        showNotification("Error al actualizar los datos", "danger")
      }
    })
    .catch((error) => {
      console.error("Error:", error)
      showNotification("Error de conexión", "danger")
    })
    .finally(() => {
      // Restaurar botón
      refreshBtn.innerHTML = originalText
      refreshBtn.disabled = false
    })
}

/**
 * Actualiza las estadísticas
 */
function updateStatistics(stats) {
  if (!stats) return

  Object.keys(stats).forEach((key) => {
    const element = document.getElementById(key)
    if (element) {
      animateNumber(element, Number.parseInt(element.textContent) || 0, stats[key])
    }
  })
}

/**
 * Anima un número
 */
function animateNumber(element, start, end, duration = 1000) {
  const startTime = performance.now()
  const difference = end - start

  function updateNumber(currentTime) {
    const elapsed = currentTime - startTime
    const progress = Math.min(elapsed / duration, 1)

    const current = Math.floor(start + difference * progress)
    element.textContent = current.toLocaleString()

    if (progress < 1) {
      requestAnimationFrame(updateNumber)
    }
  }

  requestAnimationFrame(updateNumber)
}

/**
 * Actualiza los gráficos
 */
function updateCharts(chartData) {
  if (!chartData) return

  // Actualizar gráfico de matrícula
  if (chartData.matricula) {
    const matriculaChart = Chart.getChart("matriculaPorNivelChart")
    if (matriculaChart) {
      matriculaChart.data.datasets[0].data = chartData.matricula
      matriculaChart.update()
    }
  }

  // Actualizar gráfico de género
  if (chartData.genero) {
    const generoChart = Chart.getChart("distribucionGeneroChart")
    if (generoChart) {
      generoChart.data.datasets[0].data = chartData.genero
      generoChart.update()
    }
  }
}

/**
 * Inicializa las acciones rápidas
 */
function initializeQuickActions() {
  const quickActions = document.querySelectorAll(".quick-action")

  quickActions.forEach((action) => {
    action.addEventListener("click", function (e) {
      // Agregar efecto visual
      this.style.transform = "scale(0.95)"
      setTimeout(() => {
        this.style.transform = ""
      }, 150)
    })
  })
}

/**
 * Carga la actividad reciente
 */
function loadRecentActivity() {
  const activityContainer = document.querySelector(".activity-list")
  if (!activityContainer) return

  fetch(`${IntranetApp.contextPath}/controller/dashboard?action=recentActivity`)
    .then((response) => response.json())
    .then((data) => {
      if (data.success && data.activities) {
        displayRecentActivity(data.activities)
      } else {
        activityContainer.innerHTML = '<p class="text-muted text-center py-3">No hay actividad reciente</p>'
      }
    })
    .catch((error) => {
      console.error("Error cargando actividad:", error)
      activityContainer.innerHTML = '<p class="text-muted text-center py-3">Error cargando actividad</p>'
    })
}

/**
 * Muestra la actividad reciente
 */
function displayRecentActivity(activities) {
  const activityContainer = document.querySelector(".activity-list")
  if (!activityContainer) return

  if (activities.length === 0) {
    activityContainer.innerHTML = '<p class="text-muted text-center py-3">No hay actividad reciente</p>'
    return
  }

  let html = ""
  activities.forEach((activity) => {
    html += `
            <div class="activity-item">
                <div class="activity-icon ${activity.iconClass}">
                    <i class="${activity.icon}"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">${activity.title}</div>
                    <div class="activity-description">${activity.description}</div>
                    <div class="activity-time">${activity.time}</div>
                </div>
            </div>
        `
  })

  activityContainer.innerHTML = html
}

/**
 * Función auxiliar para mostrar notificaciones
 */
function showNotification(message, type) {
  if (typeof IntranetApp !== "undefined" && IntranetApp.utils) {
    IntranetApp.utils.showNotification(message, type)
  } else {
    // Fallback simple
    alert(message)
  }
}
