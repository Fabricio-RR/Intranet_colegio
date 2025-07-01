<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="modal-content d-flex flex-column" style="max-height: 95vh; border: none;">
    <form id="formEditarComunicado" method="post" action="${pageContext.request.contextPath}/comunicado"
          enctype="multipart/form-data" class="d-flex flex-column h-100">
        <input type="hidden" name="action" value="editarGuardar"/>
        <input type="hidden" name="id" value="${comunicado.id}"/>
        <input type="hidden" name="idAnioLectivo" value="${comunicado.idAnioLectivo}"/>

        <div class="modal-header">
            <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Editar comunicado</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>

        <div class="modal-body overflow-auto" style="flex: 1 1 auto;">
            <div class="mb-3">
                <label class="form-label">Título</label>
                <input type="text" name="titulo" class="form-control" value="${comunicado.titulo}" required maxlength="200"/>
            </div>

            <div class="mb-3">
                <label class="form-label">Contenido</label>
                <textarea name="contenido" class="form-control" rows="2" required>${comunicado.contenido}</textarea>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Categoría</label>
                    <input type="text" name="categoria" class="form-control" value="${comunicado.categoria}" readonly>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Destinatario</label>
                    <select name="destinatario" id="destinatarioEditar" class="form-select" required onchange="mostrarOpcionesEditar(this.value)">
                        <option value="todos" ${comunicado.destinatario == 'todos' ? 'selected' : ''}>Todos</option>
                        <option value="docentes" ${comunicado.destinatario == 'docentes' ? 'selected' : ''}>Docentes</option>
                        <option value="estudiantes" ${comunicado.destinatario == 'estudiantes' ? 'selected' : ''}>Estudiantes</option>
                        <option value="padres" ${comunicado.destinatario == 'padres' ? 'selected' : ''}>Padres</option>
                        <option value="seccion" ${comunicado.destinatario == 'seccion' ? 'selected' : ''}>Sección específica</option>
                    </select>
                </div>
            </div>

            <div class="row" id="grupoSeccionEditar" style="display: none;">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Sección</label>
                    <select name="idAperturaSeccion" class="form-select" id="selectSeccionEditar">
                        <option value="">-- Seleccione --</option>
                        <c:forEach items="${seccionesActivas}" var="sec">
                            <option value="${sec.idAperturaSeccion}"
                                ${comunicado.idAperturaSeccion == sec.idAperturaSeccion ? 'selected' : ''}>
                                ${sec.nivel} ${sec.grado} "${sec.seccion}"
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6 mb-3" id="grupoDestinatarioSeccionEditar" style="display: none;">
                    <label class="form-label">Dirigido a</label>
                    <select name="destinatario_seccion" class="form-select" id="selectDestinatarioSeccionEditar">
                        <option value="">-- Seleccione --</option>
                        <option value="Padres" ${comunicado.destinatarioSeccion == 'Padres' ? 'selected' : ''}>Apoderados</option>
                        <option value="Estudiantes" ${comunicado.destinatarioSeccion == 'Estudiantes' ? 'selected' : ''}>Alumnos</option>
                        <option value="ambos" ${comunicado.destinatarioSeccion == 'ambos' ? 'selected' : ''}>Apoderado y Alumno</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Fecha de inicio</label>
                    <input type="date" name="fec_inicio" class="form-control" value="${comunicado.fecInicio}" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Fecha de fin</label>
                    <input type="date" name="fec_fin" class="form-control" value="${comunicado.fecFin}" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Notificar por correo</label><br>
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" name="notificar_correo" value="1" ${comunicado.notificarCorreo ? 'checked' : ''}>
                </div>
            </div>

            <div class="mb-3">
                <label for="archivo" class="form-label">Archivo adjunto (PDF, JPG, PNG – máx. 5MB)</label>
                <input type="file" class="form-control" id="archivo" name="archivo" accept=".pdf,.jpg,.jpeg,.png">
            </div>

            <c:if test="${not empty comunicado.archivo}">
                <div class="mb-3" id="archivoActualBox">
                    <label class="form-label">Archivo actual:</label>
                    <div class="d-flex align-items-center">
                        <a href="${pageContext.request.contextPath}/uploads/${comunicado.archivo}" target="_blank" class="me-2">
                            <i class="fas fa-file-alt me-1"></i>${comunicado.archivo}
                        </a>
                        <button type="button" class="btn btn-sm btn-outline-danger" id="btnEliminarArchivo" title="Eliminar archivo actual">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <input type="hidden" name="eliminar_archivo" id="eliminar_archivo" value="0">
                </div>
            </c:if>

            <div class="mt-3">
                <label for="estado" class="form-label fw-semibold">Estado</label>
                <select class="form-select" name="estado" required>
                    <option value="programada" ${comunicado.estado == 'programada' ? 'selected' : ''}>Programada</option>
                    <option value="activa" ${comunicado.estado == 'activa' ? 'selected' : ''}>Activa</option>
                    <option value="expirada" ${comunicado.estado == 'expirada' ? 'selected' : ''}>Expirada</option>
                    <option value="archivada" ${comunicado.estado == 'archivada' ? 'selected' : ''}>Archivada</option>
                </select>
            </div>
        </div>

        <div class="modal-footer">
            <button type="submit" class="btn btn-admin-primary">
                <i class="fas fa-save me-1"></i> Guardar cambios
            </button>
            <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Cancelar</button>
        </div>
    </form>
</div>

<script>
    function mostrarOpcionesEditar(valor) {
        const seccionBox = document.getElementById('grupoSeccionEditar');
        const destinatarioSeccionBox = document.getElementById('grupoDestinatarioSeccionEditar');
        const selectSeccion = document.getElementById('selectSeccionEditar');
        const selectDestinatario = document.getElementById('selectDestinatarioSeccionEditar');

        if (valor === 'seccion') {
            seccionBox.style.display = 'flex';
            destinatarioSeccionBox.style.display = 'block';
            selectSeccion.setAttribute('required', 'required');
            selectDestinatario.setAttribute('required', 'required');
        } else {
            seccionBox.style.display = 'none';
            destinatarioSeccionBox.style.display = 'none';
            selectSeccion.removeAttribute('required');
            selectDestinatario.removeAttribute('required');
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        mostrarOpcionesEditar(document.getElementById("destinatarioEditar").value);
    });

    document.getElementById("btnEliminarArchivo")?.addEventListener("click", function () {
        document.getElementById("archivoActualBox").style.display = "none";
        document.getElementById("eliminar_archivo").value = "1";
    });
</script>
