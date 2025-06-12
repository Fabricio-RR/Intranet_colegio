
document.addEventListener("DOMContentLoaded", function () {
  // Helper: crear un gráfico de Chart.js
  function crearGrafico(canvas, tipo, data, options = {}) {
    try {
      return new Chart(canvas.getContext("2d"), { type: tipo, data, options });
    } catch (e) {
      console.error("Error al crear gráfico en", canvas.id, e);
    }
  }

  // -----------------------------------------------
  // 1) Rendimiento por Curso (apoderado)
  // -----------------------------------------------
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

  // -----------------------------------------------
  // 2) Evolución del Promedio (apoderado)
  // -----------------------------------------------
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

  // -----------------------------------------------
  // 3) Notificación de bienvenida (solo apoderado)
  // -----------------------------------------------
  if (window.IntranetApp?.utils?.showNotification) {
    IntranetApp.utils.showNotification("Bienvenido/a al Portal de Padres", "info", 4000);
  }

  // Mensaje de carga exitosa (opcional, para debug)
  console.log("apoderado.js inicializado correctamente.");
});
