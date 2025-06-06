const contextPath = document.body.getAttribute("data-context-path") || '';

// === Funciones reutilizables de alerta ===
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

// Funciones de acción 

function verUsuario(id) {
    $('#modalVerUsuario').modal('show');
    $('#contenidoUsuario').html('<div class="text-center p-3">Cargando detalles...</div>');
    $('#botonAccionModal').html(''); 

    $.get(`${contextPath}/usuario`, { action: 'ver', id: id }, function (html) {
        $('#contenidoUsuario').html(html);
    }).fail(() => {
        $('#contenidoUsuario').html('<div class="text-danger">Error al cargar los datos.</div>');
    });
}

function editarUsuario(id) {
    $('#modalVerUsuario').modal('show');
    $('#contenidoUsuario').html('<div class="text-center p-3">Cargando formulario...</div>');
    $('#botonAccionModal').html(''); // Limpiar antes

    $.get(`${contextPath}/usuario`, { action: 'editar', id: id }, function (html) {
        $('#contenidoUsuario').html(html);
        // Agrega botón para guardar
        $('#botonAccionModal').html(`
            <button type="button" class="btn btn-admin-primary" onclick="guardarEdicionUsuario()">
                <i class="fas fa-save me-1"></i>Guardar Cambios
            </button>
        `);
    }).fail(() => {
        $('#contenidoUsuario').html('<div class="text-danger">Error al cargar el formulario.</div>');
    });
}


function guardarEdicionUsuario() {
    const form = $('#formEditarUsuario');
    const data = form.serialize();

    $.post(`${contextPath}/usuario`, data, response => {
        mostrarExito(response.mensaje || 'Datos actualizados.', () => {
            $('#modalVerUsuario').modal('hide');
            location.reload();
        });
    }).fail(() => {
        mostrarError('No se pudieron guardar los cambios.');
    });
}

function resetearPassword(id) {
    confirmarAccion({
        titulo: '¿Resetear contraseña?',
        texto: 'Se generará una nueva contraseña y se enviará al correo.',
        icono: 'question',
        confirmarTexto: 'Sí, resetear',
        onConfirm: () => {
            $.post(`${contextPath}/usuario`, { action: 'resetear', id }, resp => {
                mostrarExito(resp.mensaje || 'Contraseña reseteada.');
            }).fail(() => {
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
            $.post(`${contextPath}/usuario`, {
                action: 'cambiarEstado',
                id,
                estado: nuevoEstado
            }, resp => {
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
            $.post(`${contextPath}/usuario`, { action: 'eliminar', id }, resp => {
                mostrarExito(resp.mensaje || 'Usuario eliminado.', () => location.reload());
            }).fail(() => {
                mostrarError('No se pudo eliminar.');
            });
        }
    });
}

function verBitacora(id) {
    $('#modalVerUsuario').modal('show');
    $('#contenidoUsuario').html('<div class="text-center p-3">Cargando bitácora...</div>');
    $('#botonAccionModal').html(''); // Nada que mostrar

    $.get(`${contextPath}/usuario`, {
        action: 'bitacora',
        id: id
    }, function (html) {
        $('#contenidoUsuario').html(html);
    }).fail(() => {
        $('#contenidoUsuario').html('<div class="text-danger">Error al obtener bitácora.</div>');
    });
}

