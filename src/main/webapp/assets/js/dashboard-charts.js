document.addEventListener("DOMContentLoaded", function () {
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
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        };

        chartNivel = new Chart(ctx, {
            type: "bar",
            data: data,
            options: options
        });

        // Cambiar tipo de gráfico
        window.changeChartType = function (type) {
            if (chartNivel) chartNivel.destroy();
            chartNivel = new Chart(ctx, {
                type: type,
                data: data,
                options: options
            });

            // Activar botón seleccionado
            document.querySelectorAll(".chart-controls button").forEach(btn => btn.classList.remove("active"));
            document.getElementById(type + "Btn").classList.add("active");
        };
    }
});
