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

// SweetAlert feedback
function mostrarExitoMatricula(mensaje, callback) {
    console.log('[DEBUG] Swal lanzado');
    Swal.fire({
        icon: 'success',
        title: 'Éxito',
        text: mensaje,
        confirmButtonColor: '#110d59'
    }).then(() => {
        console.log('[DEBUG] Callback de Swal.fire');
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
            // Botón guardar fuera del form y type="button"
            document.getElementById("botonAccionModal").innerHTML = `
                <button type="submit" class="btn btn-admin-primary">
                <i class="fas fa-save me-1"></i> Guardar cambios
            </button>
            <button type="button" class="btn btn-outline-secondary btn-uniform" data-bs-dismiss="modal">
                <i class="fas fa-times me-1"></i> Cancelar
            </button>
            `;
        })
        .catch(err => {
            document.getElementById("contenidoDetalleMatricula").innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> Error al cargar el formulario.
                </div>`;
        });
}

// Cascada dinámica: nivel → grado → sección
function inicializarFormularioMatricula() {
    const selectNivel = document.getElementById("selectNivel");
    const selectGrado = document.getElementById("selectGrado");
    const selectSeccion = document.getElementById("selectSeccion");
    if (!selectNivel || !selectGrado || !selectSeccion) return;

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

// === GUARDAR EDICIÓN MATRÍCULA ===
function guardarEdicionMatricula() {
    const form = document.getElementById("formEditarMatricula");
    if (!form) return;

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);

    // Debug de los datos enviados
    for (var pair of formData.entries()) {
        console.log(`[DEBUG] ${pair[0]} = ${pair[1]}`);
    }

    $.ajax({
        url: form.getAttribute("action"),
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json',
        success: function(response) {
            console.log('[DEBUG] Success AJAX:', response);
            mostrarExitoMatricula(response.mensaje || 'Matrícula actualizada.', () => {
                console.log('[DEBUG] Callback Swal ejecutado');
                const modal = bootstrap.Modal.getInstance(document.getElementById("modalDetalleMatricula"));
                if (modal) modal.hide();
                window.location.reload();
            });
        },
        error: function(jq) {
            let mensaje = 'No se pudieron guardar los cambios.';
            try {
                mensaje = jq.responseJSON?.mensaje || mensaje;
            } catch (e) {}
            mostrarErrorMatricula(mensaje);
        }
    });
}

// Cambiar estado (activar/desactivar)
function cambiarEstadoMatricula(id, estadoActual) {
    const nuevoEstado = estadoActual ? 0 : 1;
    const accionTexto = nuevoEstado ? 'activar' : 'desactivar';
    confirmarAccionMatricula({
        titulo: `¿Deseas ${accionTexto} esta matrícula?`,
        texto: 'El estado cambiará inmediatamente.',
        icono: 'question',
        confirmarTexto: `Sí, ${accionTexto}`,
        onConfirm: () => {
            fetch(`${contextPath}/matricula`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=cambiarEstado&id=${id}&estado=${nuevoEstado}`
            })
            .then(res => res.json())
            .then(resp => {
                mostrarExitoMatricula(resp.mensaje || 'Estado actualizado.', () => location.reload());
            })
            .catch(() => {
                mostrarErrorMatricula('No se pudo cambiar el estado.');
            });
        }
    });
}

// Eliminar matrícula
function eliminarMatricula(id) {
    confirmarAccionMatricula({
        titulo: '¿Eliminar matrícula?',
        texto: 'Esta acción no se puede deshacer.',
        icono: 'warning',
        confirmarTexto: 'Sí, eliminar',
        onConfirm: () => {
            fetch(`${contextPath}/matricula`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=eliminar&id=${id}`
            })
            .then(res => res.json())
            .then(resp => {
                mostrarExitoMatricula(resp.mensaje || 'Matrícula eliminada.', () => location.reload());
            })
            .catch(() => {
                mostrarErrorMatricula('No se pudo eliminar.');
            });
        }
    });
}
// Asegura AJAX SIEMPRE: click o Enter
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formEditarMatricula");
    if (form) {
        form.addEventListener("submit", function(e) {
            e.preventDefault();
            guardarEdicionMatricula();
        });
    }
});

// Tu función AJAX
function guardarEdicionMatricula() {
    const form = document.getElementById("formEditarMatricula");
    if (!form) return;

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);

    $.ajax({
        url: form.getAttribute("action"),
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json',
        success: function(response) {
            Swal.fire({
                icon: 'success',
                title: 'Éxito',
                text: response.mensaje || 'Matrícula actualizada.',
                confirmButtonColor: '#110d59'
            }).then(() => {
                const modal = bootstrap.Modal.getInstance(document.getElementById("modalDetalleMatricula"));
                if (modal) modal.hide();
                window.location.reload();
            });
        },
        error: function(jq) {
            let mensaje = 'No se pudieron guardar los cambios.';
            try {
                mensaje = jq.responseJSON?.mensaje || mensaje;
            } catch (e) {}
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: mensaje,
                confirmButtonColor: '#110d59'
            });
        }
    });
}

