const contextPath = document.body.getAttribute("data-context-path") || '';

document.addEventListener("DOMContentLoaded", function () {
    const selectAnio = document.getElementById("anioLectivo");
    if (selectAnio) {
        selectAnio.addEventListener("change", function () {
            const idAnio = this.value;
            window.location.href = contextPath + '/matricula?anio=' + idAnio;
        });
    }
});

function exportarMatriculas() {
    Swal.fire("Exportar", "Funcionalidad no implementada aún.", "info");
}

function verDetalleMatricula(id) {
    const ctx = document.body.getAttribute("data-context-path");
    document.querySelector("#modalDetalleMatricula .modal-title").innerHTML =
        '<i class="fas fa-info-circle me-2"></i>Detalle de Matrícula';

    document.getElementById("contenidoDetalleMatricula").innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Cargando...</span>
            </div>
            <p class="mt-2">Cargando información...</p>
        </div>
    `;
    // Limpia los botones personalizados
    document.getElementById("botonAccionModal").innerHTML = "";

    const modal = new bootstrap.Modal(document.getElementById("modalDetalleMatricula"));
    modal.show();

    fetch(ctx + '/matricula?action=ver&id=' + id)
        .then(res => res.text())
        .then(html => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = html;
            // Botón de acción se mantiene vacío
            document.getElementById("botonAccionModal").innerHTML = "";
        })
        .catch(err => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> Error al cargar el detalle.
                </div>
            `;
        });
}

function editarMatricula(id) {
    const ctx = document.body.getAttribute("data-context-path");

    document.querySelector("#modalDetalleMatricula .modal-title").innerHTML =
        '<i class="fas fa-edit me-2"></i>Editar Matrícula';

    document.getElementById("contenidoDetalleMatricula").innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Cargando...</span>
            </div>
            <p class="mt-2">Cargando información...</p>
        </div>
    `;
    document.getElementById("botonAccionModal").innerHTML = "";
    const modal = new bootstrap.Modal(document.getElementById("modalDetalleMatricula"));
    modal.show();

    fetch(ctx + '/matricula?action=editar&id=' + id)
        .then(res => res.text())
        .then(html => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = html;
            inicializarFormularioMatricula();
            interceptarFormularioMatricula(); // Importante para submit AJAX
            document.getElementById("botonAccionModal").innerHTML = `
                <button type="submit" class="btn btn-admin-primary" form="formEditarMatricula">
                    <i class="fas fa-save me-1"></i> Guardar cambios
                </button>
            `;
        })
        .catch(err => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> Error al cargar el formulario.
                </div>
            `;
        });
}

function inicializarFormularioMatricula() {
    const selectNivel = document.getElementById("selectNivel");
    const selectGrado = document.getElementById("selectGrado");
    const selectSeccion = document.getElementById("selectSeccion");

    if (!selectNivel || !selectGrado || !selectSeccion) return;

    const idGradoActual = document.getElementById("idGradoActual")?.value;
    const idSeccionActual = document.getElementById("idSeccionActual")?.value;
    const contextPath = document.body.getAttribute("data-context-path") || '';

    // Nivel → Grado
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

                    if (idGradoActual) {
                        selectGrado.dispatchEvent(new Event("change"));
                    }
                });
        }
    });

    // Grado → Sección
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

    // Activar si ya hay nivel seleccionado
    if (selectNivel.value) {
        selectNivel.dispatchEvent(new Event("change"));
    }
}

function interceptarFormularioMatricula() {
    const form = document.getElementById("formEditarMatricula");
    if (!form) return;

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const formData = new FormData(form);

        fetch(form.getAttribute("action"), {
            method: "POST",
            body: formData
        })
        .then(res => {
            if (!res.ok) return res.json().then(data => Promise.reject(data));
            return res.json();
        })
        .then(data => {
            if (data.exito) {
                Swal.fire({
                    icon: 'success',
                    title: '¡Actualizado!',
                    text: data.mensaje,
                    confirmButtonColor: '#110d59'
                }).then(() => {
                    const modal = bootstrap.Modal.getInstance(document.getElementById("modalDetalleMatricula"));
                    modal.hide();
                    window.location.reload();
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: data.mensaje,
                    confirmButtonColor: '#110d59'
                });
            }
        })
        .catch(err => {
            Swal.fire({
                icon: 'error',
                title: 'Error de red',
                text: err && err.mensaje ? err.mensaje : 'No se pudo enviar el formulario.',
                confirmButtonColor: '#110d59'
            });
        });
    });
}
