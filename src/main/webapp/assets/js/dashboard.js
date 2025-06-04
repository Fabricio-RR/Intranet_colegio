document.addEventListener("DOMContentLoaded", function () {
  // === Matrícula por Nivel Educativo ===
  const canvasNivel = document.getElementById("matriculaPorNivelChart");
  let chartNivel;

  if (canvasNivel) {
    const ctx = canvasNivel.getContext("2d");

    const data = {
      labels: ["Inicial", "Primaria", "Secundaria"],
      datasets: [
        {
          label: "Estudiantes",
          data: [
            parseInt(canvasNivel.dataset.inicial || 0),
            parseInt(canvasNivel.dataset.primaria || 0),
            parseInt(canvasNivel.dataset.secundaria || 0)
          ],
          backgroundColor: ["#0d6efd", "#198754", "#ffc107"]
        }
      ]
    };

    const options = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: { stepSize: 1 }
        }
      }
    };

    chartNivel = new Chart(ctx, {
      type: "bar",
      data: data,
      options: options
    });

    window.changeChartType = function (type) {
      if (chartNivel) chartNivel.destroy();
      chartNivel = new Chart(ctx, {
        type: type,
        data: data,
        options: options
      });

      document.querySelectorAll(".chart-controls button").forEach((btn) =>
        btn.classList.remove("active")
      );
      const activeBtn = document.getElementById(type + "Btn");
      if (activeBtn) activeBtn.classList.add("active");
    };
  }

  // === Métricas del Sistema ===
  const ctxMetricas = document.getElementById("metricsChart")?.getContext("2d");
  if (ctxMetricas) {
    const d = ctxMetricas.canvas.dataset;
    const datos = [
      parseInt(d.usuarios || 0),
      parseInt(d.publicaciones || 0),
      parseInt(d.asistencias || 0),
      parseInt(d.calificaciones || 0)
    ];

    if (datos.some(val => !isNaN(val))) {
      new Chart(ctxMetricas, {
        type: "bar",
        data: {
          labels: ["Usuarios", "Publicaciones", "Asistencias", "Calificaciones"],
          datasets: [{
            label: "Totales",
            data: datos,
            backgroundColor: ["#007bff", "#28a745", "#ffc107", "#dc3545"]
          }]
        },
        options: {
          responsive: true,
          plugins: { legend: { display: false } }
        }
      });
    }
  }

  // === Distribución por Grados ===
  const ctxGrados = document.getElementById("distribucionGradosChart")?.getContext("2d");
  if (ctxGrados) {
    const c = ctxGrados.canvas;
    const labels = c.dataset.labels?.includes(",") ? c.dataset.labels.split(",") : [c.dataset.labels];
    const values = c.dataset.values?.includes(",") ? c.dataset.values.split(",").map(Number) : [parseInt(c.dataset.values)];

    if (labels.length > 0 && values.length > 0 && !isNaN(values[0])) {
      new Chart(ctxGrados, {
        type: "pie",
        data: {
          labels: labels,
          datasets: [{
            label: "Estudiantes",
            data: values,
            backgroundColor: [
              "#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b", "#858796"
            ]
          }]
        },
        options: { responsive: true }
      });
    }
  }

  // === Tendencia de Matrículas ===
  const tendenciaCanvas = document.getElementById("tendenciaMatriculasChart");

  if (tendenciaCanvas) {
    const labels = tendenciaCanvas.dataset.labels ? tendenciaCanvas.dataset.labels.split(",") : [];
    const values = tendenciaCanvas.dataset.values ? tendenciaCanvas.dataset.values.split(",").map(Number) : [];

    if (labels.length > 0 && values.length > 0 && !isNaN(values[0])) {
      const ctx = tendenciaCanvas.getContext("2d");
      new Chart(ctx, {
        type: "line",
        data: {
          labels: labels,
          datasets: [{
            label: "Matrículas",
            data: values,
            fill: true,
            borderColor: "#0d6efd",
            backgroundColor: "rgba(13, 110, 253, 0.2)",
            tension: 0.4
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: { beginAtZero: true }
          }
        }
      });
    }
  }

  // === Título dinámico ===
  const titleDesktop = document.getElementById("pageTitleDesktop");
  const titleMobile = document.getElementById("pageTitleMobile");
  const dashboardTitle = "Panel de Administración";

  if (titleDesktop) titleDesktop.textContent = dashboardTitle;
  if (titleMobile) titleMobile.textContent = dashboardTitle;

  // === Notificación de bienvenida ===
  if (window.IntranetApp?.utils?.showNotification) {
    IntranetApp.utils.showNotification("Bienvenido al panel de administración", "info", 4000);
  }
});
