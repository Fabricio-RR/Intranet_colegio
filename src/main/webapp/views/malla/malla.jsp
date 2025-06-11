<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp"/>
    <title>Malla Curricular - Intranet Escolar</title>
    <!--
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
--></head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Malla Curricular" scope="request" />
<c:set var="tituloPaginaMobile" value="Malla" scope="request" />
<c:set var="iconoPagina" value="fas fa-layer-group me-2" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content container py-4">

    <!-- Card de filtros y acciones -->
     <div class="row mb-4">
        <div class="col-12">
            <div class="card">
            <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex align-items-center gap-2 ">
                <label for="anioLectivo" class="mb-0 fw-semibold" style="white-space: nowrap;">Año Lectivo:</label>
                <select id="anioLectivo" class="form-select form-select-sm" style="min-width: 100px;">
                    <c:forEach var="anio" items="${anios}">
                        <option value="${anio}" ${anio == anioActual ? 'selected' : ''}>${anio}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-outline-success btn-sm btn-uniform" onclick="exportarUsuarios()" title="Exportar a Excel">
                    <i class="fas fa-file-excel me-1"></i><span>Exportar</span>
                </button>
                <a href="${pageContext.request.contextPath}/malla?action=nuevo" class="btn btn-admin-primary btn-sm btn-uniform" title="Nueva malla curricular">
                    <i class="fas fa-plus me-1"></i><span class="d-none d-sm-inline">Crear</span> Malla
                </a>
            </div>
        </div>
        </div>
        </div>
    </div>
    <!-- Tarjetas por nivel -->
    <div class="row g-4">
        <c:forEach var="nivel" items="${resumenNiveles}">
            <div class="col-md-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">${nivel.nombreNivel}</h5>
                        <p class="mb-1">📘 Grados con malla: <strong>${nivel.totalGrados}</strong></p>
                        <p class="mb-1">📘 Cursos asignados: <strong>${nivel.totalCursos}</strong></p>
                        <p class="mb-1">📘 Docentes asignados: <strong>${nivel.totalDocentes}</strong></p>
                        <div class="mt-3 d-flex justify-content-between">
                            <button class="btn btn-sm btn-outline-primary" onclick="verDetalleNivel(${nivel.idNivel})">
                                <i class="fas fa-eye me-1"></i> Ver Detalle
                            </button>
                            <a href="${pageContext.request.contextPath}/malla?action=crear&idNivel=${nivel.idNivel}" class="btn btn-sm btn-outline-success">
                                <i class="fas fa-plus me-1"></i> Crear Malla
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Modal Detalle -->
    <div class="modal fade" id="modalDetalleMalla" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-list-alt me-2"></i>Detalle de Malla Curricular</h5>
                    <button class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body" id="contenidoDetalleMalla">
                    <!-- Contenido cargado por AJAX -->
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/includes/footer.jsp" />
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    function verDetalleNivel(idNivel) {
        const anio = document.getElementById("anioLectivo").value;
        $('#contenidoDetalleMalla').html('<p class="text-center my-4">Cargando...</p>');
        fetch(`${document.body.dataset.contextPath}/malla?action=detallePorNivel&idNivel=${idNivel}&anio=${anio}`)
            .then(res => res.text())
            .then(html => {
                $('#contenidoDetalleMalla').html(html);
                const modal = new bootstrap.Modal(document.getElementById('modalDetalleMalla'));
                modal.show();
            });
    }

    function exportarUsuarios() {
        const anio = document.getElementById("anioLectivo").value;
        window.location.href = `${document.body.dataset.contextPath}/malla?action=exportarExcel&anio=${anio}`;
    }
</script>
</body>
</html>
