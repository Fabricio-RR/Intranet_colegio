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
        const modal = new bootstrap.Modal(document.getElementById("modalDetalleMatricula"));
        modal.show();

        fetch(ctx + '/matricula?action=ver&id=' + id)
            .then(res => res.text())
            .then(html => {
                document.getElementById("contenidoDetalleMatricula").innerHTML = html;
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
        // Cambia el título
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
        const modal = new bootstrap.Modal(document.getElementById("modalDetalleMatricula"));
        modal.show();

        fetch(ctx + '/matricula?action=editar&id=' + id)
            .then(res => res.text())
            .then(html => {
                document.getElementById("contenidoDetalleMatricula").innerHTML = html;
            })
            .catch(err => {
                document.getElementById("contenidoDetalleMatricula").innerHTML = `
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i> Error al cargar el formulario.
                    </div>
                `;
            });
    }
