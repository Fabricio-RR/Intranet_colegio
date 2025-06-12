document.addEventListener("DOMContentLoaded", function () {
  // Detecta el dashboard actual por la clase del body
  const body = document.body;
  let dashboardRol = "";
  if (body.classList.contains("admin-dashboard")) dashboardRol = "admin";
  else if (body.classList.contains("docente-dashboard")) dashboardRol = "docente";
  else if (body.classList.contains("apoderado-dashboard")) dashboardRol = "apoderado";

  // Notificación SOLO para el dashboard correcto
  if (window.IntranetApp?.utils?.showNotification) {
    if (dashboardRol === "admin") {
      IntranetApp.utils.showNotification("Bienvenido al panel de administración", "info", 4000);
    } else if (dashboardRol === "docente") {
      IntranetApp.utils.showNotification("Bienvenido al panel docente", "info", 4000);
    } else if (dashboardRol === "apoderado") {
      IntranetApp.utils.showNotification("Bienvenido/a al Portal de Padres", "info", 4000);
    }
  }

  // ========== ADMIN DASHBOARD ==========
  if (dashboardRol === "admin") {
    // Matrícula por Nivel Educativo
    const canvasNivel = document.getElementById("matriculaPorNivelChart");
    let chartNivel;
    if (canvasNivel) {
      const ctx = canvasNivel.getContext("2d");
      const data = {
        labels: ["Inicial", "Primaria", "Secundaria"],
        datasets: [{
          label: "Estudiantes",
          data: [
            parseInt(canvasNivel.dataset.inicial || 0),
            parseInt(canvasNivel.dataset.primaria || 0),
            parseInt(canvasNivel.dataset.secundaria || 0)
          ],
          backgroundColor: ["#0d6efd", "#198754", "#ffc107"]
        }]
      };
      const options = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
      };
      chartNivel = new Chart(ctx, { type: "bar", data: data, options: options });

      window.changeChartType = function (type) {
        if (chartNivel) chartNivel.destroy();
        chartNivel = new Chart(ctx, { type: type, data: data, options: options });
        document.querySelectorAll(".chart-controls button").forEach((btn) =>
          btn.classList.remove("active")
        );
        const activeBtn = document.getElementById(type + "Btn");
        if (activeBtn) activeBtn.classList.add("active");
      };
    }

    // Métricas del Sistema
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
          options: { responsive: true, plugins: { legend: { display: false } } }
        });
      }
    }

    // Distribución por Grados
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

    // Tendencia de Matrículas
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
            scales: { y: { beginAtZero: true } }
          }
        });
      }
    }
  }

  // ========== APODERADO DASHBOARD ==========
  if (dashboardRol === "apoderado") {
    // Helper para crear gráfico
    function crearGrafico(canvas, tipo, data, options = {}) {
      try { return new Chart(canvas.getContext("2d"), { type: tipo, data, options }); }
      catch (e) { console.error("Error al crear gráfico en", canvas.id, e); }
    }

    // Rendimiento por Curso
    const canvasCursos = document.getElementById("rendimientoCursosChart");
    if (canvasCursos) {
      const rawCursos = canvasCursos.dataset.cursos || "";
      const rawNotas  = canvasCursos.dataset.notas  || "";
      const cursos = rawCursos.split(",").map(s => s.trim()).filter(Boolean);
      const notas  = rawNotas.split(",").map(n => parseFloat(n)).filter(n => !isNaN(n));
      if (cursos.length && notas.length && cursos.length === notas.length) {
        crearGrafico(canvasCursos, "bar", {
          labels: cursos,
          datasets: [{
            label: "Nota",
            data: notas,
            backgroundColor: "#0d6efd"
          }]
        }, {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: { y: { beginAtZero: true } }
        });
      } else {
        console.warn("Datos insuficientes o desalineados para rendimientoCursosChart");
      }
    }

    // Evolución del Promedio
    const canvasEvo = document.getElementById("evolucionPromedioChart");
    if (canvasEvo) {
      const periodos = (canvasEvo.dataset.periodos || "").split(",").map(s => s.trim()).filter(Boolean);
      const proms    = (canvasEvo.dataset.promedios || "").split(",").map(n => parseFloat(n)).filter(n => !isNaN(n));
      if (periodos.length && proms.length && periodos.length === proms.length) {
        crearGrafico(canvasEvo, "line", {
          labels: periodos,
          datasets: [{
            label: "Promedio",
            data: proms,
            fill: false,
            tension: 0.3
          }]
        }, {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: { y: { beginAtZero: true } }
        });
      } else {
        console.warn("Datos insuficientes o desalineados para evolucionPromedioChart");
      }
    }
  }

  // ========== DOCENTE DASHBOARD ==========
  if (dashboardRol === "docente") {
    // Puedes agregar gráficos aquí si algún día los tienes para docente
    // Por ahora, solo la notificación y título dinámico
  }

  // ========== TÍTULO GENERAL ==========
  const tDesk = document.getElementById("pageTitleDesktop");
  const tMob  = document.getElementById("pageTitleMobile");
  if (tDesk && tMob) {
    const title = document.title;
    tDesk.textContent = title;
    tMob.textContent  = title;
  }

  console.log("Dashboard.js inicializado correctamente.");
});
