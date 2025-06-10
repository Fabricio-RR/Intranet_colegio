document.addEventListener("DOMContentLoaded", function () {
    const nivelSelects = document.querySelectorAll("select[name='idNivel']");
    const gradoSelects = document.querySelectorAll("select[name='idGrado']");

    nivelSelects.forEach((nivelSelect, index) => {
        nivelSelect.addEventListener("change", function () {
            const nivelId = this.value;

            if (nivelId) {
                fetchGrados(nivelId, gradoSelects[index]);
            } else {
                gradoSelects[index].innerHTML = "<option value='' disabled selected>Seleccione grado</option>";
            }
        });
    });
});

/**
 * Simulación de carga de grados por nivel (reemplaza con fetch real si usas endpoint dinámico)
 */
function fetchGrados(idNivel, gradoSelect) {
    // Aquí deberías usar fetch real a tu backend. Ejemplo simulado:
    const gradosPorNivel = {
        1: [ { id: 101, nombre: "1° Inicial" }, { id: 102, nombre: "2° Inicial" } ],
        2: [ { id: 201, nombre: "1° Primaria" }, { id: 202, nombre: "2° Primaria" }, { id: 203, nombre: "3° Primaria" } ],
        3: [ { id: 301, nombre: "1° Secundaria" }, { id: 302, nombre: "2° Secundaria" } ]
    };

    const grados = gradosPorNivel[idNivel] || [];

    let options = "<option value='' disabled selected>Seleccione grado</option>";
    grados.forEach(grado => {
        options += `<option value="${grado.id}">${grado.nombre}</option>`;
    });

    gradoSelect.innerHTML = options;
}
