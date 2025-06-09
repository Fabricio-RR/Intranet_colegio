const contextPath = document.body.getAttribute("data-context-path") || '';

function alternarTextoFiltro(btn) {
    const span = btn.querySelector('.toggle-text');
    span.textContent = span.textContent.includes('Mostrar') ? 'Ocultar filtros avanzados' : 'Mostrar filtros avanzados';
}

function filtrarUsuarios() {
    const estado = $('#filtroEstado').val();
    const rol = $('#filtroRol').val();
    const fecha = $('#filtroFecha').val();
    const nivel = $('#filtroNivel').val();
    const grado = $('#filtroGrado').val();
    const seccion = $('#filtroSeccion').val();

    const params = new URLSearchParams();
    if (estado) params.append('estado', estado);
    if (rol) params.append('rol', rol);
    if (fecha) params.append('fecha', fecha);
    if (nivel) params.append('nivel', nivel);
    if (grado) params.append('grado', grado);
    if (seccion) params.append('seccion', seccion);

    // Redirige con los filtros como query params
    const contextPath = document.body.getAttribute('data-context-path') || '';
    window.location.href = contextPath + '/usuarios?' + params.toString();
}

function mostrarExito(mensaje, callback) {
    Swal.fire({
        icon: 'success',
        title: 'Éxito',
        text: mensaje,
        confirmButtonColor: '#110d59'
    }).then(() => {
        if (callback) callback();
    });
}

function mostrarError(mensaje) {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: mensaje,
        confirmButtonColor: '#110d59'
    });
}

function confirmarAccion({ titulo, texto, icono = 'warning', confirmarTexto = 'Sí', cancelarTexto = 'Cancelar', onConfirm }) {
    Swal.fire({
        title: titulo,
        text: texto,
        icon: icono,
        showCancelButton: true,
        confirmButtonColor: '#110d59',
        cancelButtonColor: '#d33',
        confirmButtonText: confirmarTexto,
        cancelButtonText: cancelarTexto,
        reverseButtons: true,
        focusCancel: true
    }).then(result => {
        if (result.isConfirmed && typeof onConfirm === 'function') {
            onConfirm();
        }
    });
}

function cargarModal(titulo, contenidoCargando, url, botonHtml = '') {
    $('#modalVerUsuario').modal('show');
    $('#contenidoUsuario').html(`<div class="text-center p-3">${contenidoCargando}</div>`);
    $('#botonAccionModal').html('');

    $.get(url, function (html) {
        $('#contenidoUsuario').html(html);
        $('#botonAccionModal').html(botonHtml);
    }).fail(() => {
        $('#contenidoUsuario').html('<div class="text-danger">Error al cargar el contenido.</div>');
    });
}

function verUsuario(id) {
    cargarModal('Ver Usuario', 'Cargando detalles...', `${contextPath}/usuarios?action=ver&id=${id}`);
}
function editarUsuario(id) {
    const botonGuardar = `
        <button type="button" class="btn btn-admin-primary" onclick="guardarEdicionUsuario()">
            <i class="fas fa-save me-1"></i>Guardar Cambios
        </button>
    `;
    cargarModal('Editar Usuario', 'Cargando formulario...', `${contextPath}/usuarios?action=editar&id=${id}`, botonGuardar);
}

function guardarEdicionUsuario() {
    const form = $('#formEditarUsuario')[0];

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);

    $.ajax({
        url: `${contextPath}/usuarios`,
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            mostrarExito(response.mensaje || 'Datos actualizados.', () => {
                $('#modalVerUsuario').modal('hide');
                location.reload();
            });
        },
        error: function(jq) {
            mostrarError(jq.responseJSON?.mensaje || 'No se pudieron guardar los cambios.');
        }
    });
}

function resetearPassword(id) {
    confirmarAccion({
        titulo: '¿Resetear contraseña?',
        texto: 'Se enviará una nueva contraseña al correo.',
        icono: 'question',
        confirmarTexto: 'Sí, resetear',
        onConfirm: () => {
            Swal.fire({
                title: 'Enviando...',
                text: 'Estamos reseteando la contraseña y enviándola al correo.',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.post(`${contextPath}/usuarios`, { action: 'resetear', id }, resp => {
                Swal.close();
                mostrarExito(resp.mensaje || 'Contraseña reseteada.');
            }).fail(() => {
                Swal.close();
                mostrarError('No se pudo completar la operación.');
            });
        }
    });
}

function cambiarEstado(id, estadoActual) {
    const nuevoEstado = estadoActual ? 0 : 1;
    const accionTexto = nuevoEstado ? 'activar' : 'desactivar';
    confirmarAccion({
        titulo: `¿Deseas ${accionTexto} este usuario?`,
        texto: 'El estado cambiará inmediatamente.',
        icono: 'question',
        confirmarTexto: `Sí, ${accionTexto}`,
        onConfirm: () => {
            $.post(`${contextPath}/usuarios`, { action: 'cambiarEstado', id, estado: nuevoEstado }, resp => {
                mostrarExito(resp.mensaje || 'Estado actualizado.', () => location.reload());
            }).fail(() => {
                mostrarError('No se pudo cambiar el estado.');
            });
        }
    });
}

function eliminarUsuario(id) {
    confirmarAccion({
        titulo: '¿Eliminar usuario?',
        texto: 'Esta acción no se puede deshacer.',
        icono: 'warning',
        confirmarTexto: 'Sí, eliminar',
        onConfirm: () => {
            $.post(`${contextPath}/usuarios`, { action: 'eliminar', id }, resp => {
                mostrarExito(resp.mensaje || 'Usuario eliminado.', () => location.reload());
            }).fail(() => {
                mostrarError('No se pudo eliminar.');
            });
        }
    });
}

function verBitacora(id) {
    cargarModal('Bitácora', 'Cargando bitácora...', `${contextPath}/usuarios?action=bitacora&id=${id}`);
}
