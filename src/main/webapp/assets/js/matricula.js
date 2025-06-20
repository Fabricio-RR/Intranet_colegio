const contextPath = document.body.getAttribute("data-context-path") || '';

// Cambia de año lectivo
document.addEventListener("DOMContentLoaded", function () {
    const selectAnio = document.getElementById("anioLectivo");
    if (selectAnio) {
        selectAnio.addEventListener("change", function () {
            const idAnio = this.value;
            window.location.href = contextPath + '/matricula?anio=' + idAnio;
        });
    }
});

// SweetAlert feedback (puedes usarlo para otras acciones, no para guardar)
function mostrarExitoMatricula(mensaje, callback) {
    Swal.fire({
        icon: 'success',
        title: 'Éxito',
        text: mensaje,
        confirmButtonColor: '#110d59'
    }).then(() => {
        if (callback) callback();
    });
}
function mostrarErrorMatricula(mensaje) {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: mensaje,
        confirmButtonColor: '#110d59'
    });
}

// Modal Detalle
function verDetalleMatricula(id) {
    document.querySelector("#modalDetalleMatricula .modal-title").innerHTML =
        '<i class="fas fa-info-circle me-2"></i>Detalle de Matrícula';
    document.getElementById("contenidoDetalleMatricula").innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Cargando...</span>
            </div>
            <p class="mt-2">Cargando información...</p>
        </div>`;
    document.getElementById("botonAccionModal").innerHTML = "";

    const modal = new bootstrap.Modal(document.getElementById("modalDetalleMatricula"));
    modal.show();

    fetch(contextPath + '/matricula?action=ver&id=' + id)
        .then(res => res.text())
        .then(html => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = html;
            document.getElementById("botonAccionModal").innerHTML = "";
        })
        .catch(err => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> Error al cargar el detalle.
                </div>`;
        });
}

// Modal Edición
function editarMatricula(id) {
    document.querySelector("#modalDetalleMatricula .modal-title").innerHTML =
        '<i class="fas fa-edit me-2"></i>Editar Matrícula';
    document.getElementById("contenidoDetalleMatricula").innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Cargando...</span>
            </div>
            <p class="mt-2">Cargando información...</p>
        </div>`;
    document.getElementById("botonAccionModal").innerHTML = "";

    const modal = new bootstrap.Modal(document.getElementById("modalDetalleMatricula"));
    modal.show();

    fetch(contextPath + '/matricula?action=editar&id=' + id)
        .then(res => res.text())
        .then(html => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = html;
            inicializarFormularioMatricula();
            document.getElementById("botonAccionModal").innerHTML = ``; // Botones están en el JSP
        })
        .catch(err => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> Error al cargar el formulario.
                </div>`;
        });
}
document.addEventListener("DOMContentLoaded", function() {
    const selectEstado = document.querySelector('select[name="estado"]');
    const grupoObs = document.getElementById("grupoObservacion");

    if (selectEstado && grupoObs) {
        selectEstado.addEventListener("change", function() {
            if (this.value === "condicional") {
                grupoObs.style.display = "block";
            } else {
                grupoObs.style.display = "none";
                // Opcional: limpiar el campo si NO es condicional
                grupoObs.querySelector("textarea").value = "";
            }
        });
        // Esto asegura que el estado inicial se muestre bien
        selectEstado.dispatchEvent(new Event("change"));
    }
});

function inicializarFormularioMatricula() {
    const selectNivel = document.getElementById("selectNivel");
    const selectGrado = document.getElementById("selectGrado");
    const selectSeccion = document.getElementById("selectSeccion");
    const selectEstado = document.querySelector('select[name="estado"]');
    const grupoObs = document.getElementById("grupoObservacion");

    // CASCADA
    if (selectNivel && selectGrado && selectSeccion) {
        const idGradoActual = document.getElementById("idGradoActual")?.value;
        const idSeccionActual = document.getElementById("idSeccionActual")?.value;

        selectNivel.addEventListener("change", function () {
            const idNivel = this.value;
            selectGrado.innerHTML = '<option value="">Cargando grados...</option>';
            selectGrado.disabled = true;
            selectSeccion.innerHTML = '<option value="">Seleccione una sección</option>';
            selectSeccion.disabled = true;

            if (idNivel) {
                fetch(`${contextPath}/carga-academica?tipo=cargar-grados&id=${idNivel}`)
                    .then(res => res.json())
                    .then(data => {
                        selectGrado.innerHTML = '<option value="">Seleccione un grado</option>';
                        data.forEach(g => {
                            const opt = document.createElement("option");
                            opt.value = g.idGrado;
                            opt.textContent = g.nombre;
                            if (g.idGrado == idGradoActual) opt.selected = true;
                            selectGrado.appendChild(opt);
                        });
                        selectGrado.disabled = false;
                        if (idGradoActual) selectGrado.dispatchEvent(new Event("change"));
                    });
            }
        });

        selectGrado.addEventListener("change", function () {
            const idGrado = this.value;
            selectSeccion.innerHTML = '<option value="">Cargando secciones...</option>';
            selectSeccion.disabled = true;

            if (idGrado) {
                fetch(`${contextPath}/carga-academica?tipo=cargar-secciones&id=${idGrado}`)
                    .then(res => res.json())
                    .then(data => {
                        selectSeccion.innerHTML = '<option value="">Seleccione una sección</option>';
                        data.forEach(s => {
                            const opt = document.createElement("option");
                            opt.value = s.idSeccion;
                            opt.textContent = s.nombre;
                            if (s.idSeccion == idSeccionActual) opt.selected = true;
                            selectSeccion.appendChild(opt);
                        });
                        selectSeccion.disabled = false;
                    });
            }
        });

        if (selectNivel.value) selectNivel.dispatchEvent(new Event("change"));
    }

    // ESTADO/OBSERVACION
    if (selectEstado && grupoObs) {
        selectEstado.addEventListener("change", function() {
            if (this.value === "condicional") {
                grupoObs.style.display = "block";
                grupoObs.querySelector("textarea").required = true;
            } else {
                grupoObs.style.display = "none";
                grupoObs.querySelector("textarea").value = "";
                grupoObs.querySelector("textarea").required = false;
            }
        });
        // Asegura que la observación se muestre/oculte según el valor actual al cargar
        selectEstado.dispatchEvent(new Event("change"));
    }
}

function confirmarAnularMatricula(idMatricula) {
    Swal.fire({
        title: '¿Estás seguro?',
        text: 'Esta acción marcará la matrícula como RETIRADO. ¿Deseas continuar?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, anular',
        cancelButtonText: 'Cancelar',
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d'
    }).then((result) => {
        if (result.isConfirmed) {
            // Llama a la función para anular (POST)
            anularMatricula(idMatricula);
        }
    });
}

function anularMatricula(idMatricula) {
    fetch(contextPath + '/matricula', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `action=anular&id=${idMatricula}`
    })
    .then(res => res.json())
    .then(resp => {
        if (resp.exito) {
            Swal.fire({
                icon: 'success',
                title: '¡Matrícula anulada!',
                text: resp.mensaje || 'El alumno fue marcado como retirado.',
                confirmButtonColor: '#110d59'
            }).then(() => location.reload());
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: resp.mensaje || 'No se pudo anular la matrícula.',
                confirmButtonColor: '#110d59'
            });
        }
    })
    .catch(() => {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'No se pudo conectar al servidor.',
            confirmButtonColor: '#110d59'
        });
    });
}

// Exportar (dummy, luego implementar)
function exportarMatriculas() {
    Swal.fire("Exportar", "Funcionalidad no implementada aún.", "info");
}
