/* global Chart */
/* JavaScript para dashboard*/
import { Chart } from "@/components/ui/chart"
document.addEventListener("DOMContentLoaded", () => {
  initializeDashboard();
});

function initializeDashboard() {
  if (typeof Chart === "undefined") {
    console.warn("Chart.js no está disponible");
    return;
  };

  initMatriculaChart();
  initRefreshButton();
  initQuickActions();
}

// GRÁFICOS
function initMatriculaChart() {
  const ctx = document.getElementById("matriculaPorNivelChart");
  if (!ctx) return;

  const { inicial = 0, primaria = 0, secundaria = 0 } = ctx.dataset;

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: ["Inicial", "Primaria", "Secundaria"],
      datasets: [{
        label: "Estudiantes",
        data: [inicial, primaria, secundaria].map(Number),
        backgroundColor: ["#110d59", "#28a745", "#f70617"],
        borderColor: ["#110d59", "#28a745", "#f70617"],
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
  });
}

// BOTÓN REFRESCAR
function initRefreshButton() {
  const btn = document.getElementById("refreshData");
  if (!btn) return;

  btn.addEventListener("click", () => {
    const original = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Actualizando...';
    btn.disabled = true;

    if (!IntranetApp?.contextPath) {
      showNotification("Error de configuración", "danger");
      resetBtn();
      return;
    }

    fetch(`${IntranetApp.contextPath}/controller/dashboard?action=refresh`)
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          updateStatistics(data.statistics);
          updateCharts(data.charts);
          showNotification("Datos actualizados correctamente", "success");
        } else {
          showNotification("Error al actualizar los datos", "danger");
        }
      })
      .catch(err => {
        console.error(err);
        showNotification("Error de conexión", "danger");
      })
      .finally(() => resetBtn());

    function resetBtn() {
      btn.innerHTML = original;
      btn.disabled = false;
    }
  });
}

// ACTUALIZAR ESTADÍSTICAS Y GRÁFICOS
function updateStatistics(stats = {}) {
  Object.entries(stats).forEach(([id, value]) => {
    const el = document.getElementById(id);
    if (el) animateNumber(el, Number(el.textContent) || 0, value);
  });
}

function animateNumber(el, start, end, duration = 1000) {
  const startTime = performance.now();
  const diff = end - start;

  const step = (time) => {
    const progress = Math.min((time - startTime) / duration, 1);
    el.textContent = Math.floor(start + diff * progress).toLocaleString();
    if (progress < 1) requestAnimationFrame(step);
  };

  requestAnimationFrame(step);
}

function updateCharts(charts = {}) {
  const updateChart = (id, data) => {
    const chart = Chart.getChart(id);
    if (chart) {
      chart.data.datasets[0].data = data;
      chart.update();
    }
  };

  if (charts.matricula) updateChart("matriculaPorNivelChart", charts.matricula);
}

// ACCIONES RÁPIDAS
function initQuickActions() {
  document.querySelectorAll(".quick-action").forEach((el) => {
    el.addEventListener("click", function () {
      this.style.transform = "scale(0.95)";
      setTimeout(() => (this.style.transform = ""), 150);
    });
  });
}

// NOTIFICACIONES
function showNotification(message, type = "info") {
  if (IntranetApp?.utils?.showNotification) {
    IntranetApp.utils.showNotification(message, type);
  } else {
    alert(message);
  }
}
