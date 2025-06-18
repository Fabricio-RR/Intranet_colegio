const contextPath = document.body.getAttribute("data-context-path") || '';

// Cambia el año lectivo (dropdown)
document.addEventListener("DOMContentLoaded", function() {
    const selectAnio = document.getElementById("anioLectivo");
    if (selectAnio) {
        selectAnio.addEventListener("change", function() {
            const idAnio = this.value;
            window.location.href = contextPath + '/malla-curricular?anio=' + idAnio;
        });
    }
});

/**
 * Muestra un modal genérico cargando contenido desde una URL
 */
function cargarModal(titulo, mensajeCargando, url) {
    $('#modalDetalleMalla').modal('show');
    $('#modalDetalleMalla .modal-title').text(titulo);
    $('#contenidoDetalleMalla').html(
        `<div class="text-center p-3">${mensajeCargando}</div>`
    );
    $.get(url)
      .done(html => $('#contenidoDetalleMalla').html(html))
      .fail(() => $('#contenidoDetalleMalla').html(
         '<div class="text-danger text-center p-3">Error al cargar el contenido.</div>'
      ));
}

/**
 * Ver detalle de un nivel en el modal
 */
function verDetalleMalla(idNivel) {
    const anio = document.getElementById("anioLectivo").value;
    const url = contextPath + '/malla-curricular?action=detallePorNivel&idNivel=' + idNivel + '&anio=' + anio;
    cargarModal('Detalle de Malla', '<div class="spinner-border text-primary" role="status"></div>', url);
}

/**
 * Cargar el formulario de edición en el mismo modal
 */
function editarMalla(idNivel) {
    const anio = document.getElementById("anioLectivo").value;
    const url = contextPath + '/malla-curricular?action=editar&idNivel=' + idNivel + '&anio=' + anio;
    cargarModal('Editar Malla', '<div class="spinner-border text-primary" role="status"></div>', url);
}

/**
 * Envío AJAX del formulario de edición de malla curricular
 */
$(document).on('submit', '#formEditarMalla', function(e) {
    e.preventDefault(); // Prevenir submit clásico
    
    console.log('¡Evento submit de #formEditarMalla capturado!');

    const $form = $(this);
    const url = $form.attr('action');
    const data = $form.serialize();

    $.post(url, data)
        .done(function(resp) {
            // Intenta parsear la respuesta como JSON
            let mensaje = "La malla curricular fue actualizada correctamente.";
            try {
                const resJson = typeof resp === "string" ? JSON.parse(resp) : resp;
                if (resJson.mensaje) mensaje = resJson.mensaje;
            } catch (e) {}
            Swal.fire({
                icon: 'success',
                title: '¡Cambios guardados!',
                text: mensaje,
                confirmButtonColor: '#110d59'
            }).then(() => {
                $('#modalDetalleMalla').modal('hide');
                location.reload();
            });
        })
        .fail(function(xhr) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'No se pudo actualizar la malla. Intente de nuevo.',
                confirmButtonColor: '#110d59'
            });
        });
});

/**
 * Desactivar malla por nivel (usando inline onclick)
 */
function desactivarNivel(idNivel) {
    const anio = document.getElementById("anioLectivo").value;
    Swal.fire({
        title: '¿Desactivar esta malla? (Nivel)',
        text: 'Se desactivarán todos los cursos de este nivel.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#110d59',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Sí, desactivar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            $.post(
                contextPath + '/malla-curricular',
                { action: 'desactivarPorNivel', idNivel, anio }
            )
            .done(resp => {
                Swal.fire({
                    icon: 'success',
                    title: '¡Hecho!',
                    text: resp.mensaje || 'La malla fue desactivada.'
                }).then(() => {
                    location.reload();
                });
            })
            .fail(() => {
                Swal.fire({ icon: 'error', title: 'Error', text: 'No se pudo desactivar.' });
            });
        }
    });
}

function verDetalleMallaInactivas(idNivel) {
    const anio = document.getElementById("anioLectivo").value;
    const url = contextPath + '/malla-curricular?action=detallePorNivelInactivas&idNivel=' + idNivel + '&anio=' + anio;
    cargarModal('Cursos Inactivos', '<div class="spinner-border text-danger" role="status"></div>', url);
}

function reactivarNivel(idNivel) {
    const anio = document.getElementById("anioLectivo").value;
    Swal.fire({
        title: '¿Reactivar este nivel?',
        text: 'Se activarán todos los cursos de este nivel.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#aaa',
        confirmButtonText: 'Sí, reactivar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            $.post(
                contextPath + '/malla-curricular',
                { action: 'reactivarPorNivel', idNivel, anio }
            )
            .done(resp => {
                Swal.fire({
                    icon: 'success',
                    title: '¡Hecho!',
                    text: resp.mensaje || 'El nivel fue reactivado.'
                }).then(() => {
                    location.reload();
                });
            })
            .fail(() => {
                Swal.fire({ icon: 'error', title: 'Error', text: 'No se pudo reactivar.' });
            });
        }
    });
}

/**
 * Exportar malla a Excel
 */
function exportarMalla() {
    const anio = document.getElementById("anioLectivo").value;
    window.location.href = contextPath + '/malla-curricular?action=exportarExcel&anio=' + anio;
}
