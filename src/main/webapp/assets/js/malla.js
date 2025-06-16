const contextPath = document.body.getAttribute("data-context-path") || '';

document.addEventListener("DOMContentLoaded", function() {
    const selectAnio = document.getElementById("anioLectivo");
    selectAnio.addEventListener("change", function() {
        const idAnio = this.value;
        window.location.href = contextPath + '/malla-curricular?anio=' + idAnio;
    });
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
 * Desactivar malla por nivel (usando inline onclick)
 */
function desactivarNivel(idNivel) {
    const anio = document.getElementById("anioLectivo").value;
    confirmarAccion({
        titulo: '¿Desactivar esta malla? (Nivel)',
        texto: 'Se desactivarán todos los cursos de este nivel.',
        icono: 'warning',
        confirmarTexto: 'Sí, desactivar',
        onConfirm: () => {
            $.post(
                contextPath + '/malla-curricular',
                { action: 'desactivarPorNivel', idNivel, anio }
            )
            .done(resp => {
                Swal.fire({ icon: 'success', title: '¡Hecho!', text: resp.mensaje });
                location.reload();
            })
            .fail(() => {
                Swal.fire({ icon: 'error', title: 'Error', text: 'No se pudo desactivar.' });
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
