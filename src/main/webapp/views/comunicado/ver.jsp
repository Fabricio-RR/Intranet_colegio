<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="modal-header">
    <h5 class="modal-title"><i class="fas fa-eye me-2"></i>Detalle del Comunicado</h5>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
</div>

<div class="modal-body">
    <div class="row">
        <div class="col-md-8">
            <h5 class="fw-bold mb-2">${comunicado.titulo}</h5>
        </div>
        <div class="col-md-4 text-end">
            <span class="badge 
                ${comunicado.estado eq 'activa' ? 'bg-success' 
                : comunicado.estado eq 'programada' ? 'bg-primary' 
                : comunicado.estado eq 'expirada' ? 'bg-warning text-dark' 
                : 'bg-secondary'} text-uppercase">
                ${comunicado.estado}
            </span>
        </div>
    </div>

    <div class="mt-3">
        <label class="fw-semibold">Contenido:</label>
        <p class="text-justify">${comunicado.contenido}</p>
    </div>

    <div class="row mt-2">
        <div class="col-md-6">
            <label class="fw-semibold">Categoría:</label>
            <p class="mb-0 text-capitalize">${comunicado.categoria}</p>
        </div>
        <div class="col-md-6">
            <label class="fw-semibold">Destinatario:</label>
            <p class="mb-0 text-capitalize">${comunicado.destinatario}</p>
        </div>
    </div>

    <div class="row mt-2">
        <div class="col-md-6">
            <label class="fw-semibold">Fecha de inicio:</label>
            <p class="mb-0"><fmt:formatDate value="${comunicado.fecInicio}" pattern="dd/MM/yyyy"/></p>
        </div>
        <div class="col-md-6">
            <label class="fw-semibold">Fecha de fin:</label>
            <p class="mb-0"><fmt:formatDate value="${comunicado.fecFin}" pattern="dd/MM/yyyy"/></p>
        </div>
    </div>

    <div class="mt-3">
        <label class="fw-semibold">Archivo adjunto:</label>
        <c:choose>
            <c:when test="${not empty comunicado.archivo}">
                <a href="${pageContext.request.contextPath}/uploads/${comunicado.archivo}" target="_blank" class="d-block mt-1">
                    <i class="fas fa-file-alt me-1"></i> ${comunicado.archivo}
                </a>
            </c:when>
            <c:otherwise>
                <p class="text-muted mb-0">No se adjuntó archivo.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="mt-3">
        <label class="fw-semibold">Notificar por correo:</label>
        <p class="mb-0">${comunicado.notificarCorreo ? 'Sí' : 'No'}</p>
    </div>
</div>

<div class="modal-footer">
    <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Cerrar</button>
</div>
