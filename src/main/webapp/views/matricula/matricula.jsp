<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <c:set var="paginaActiva" value="matricula" scope="request"/>
        <jsp:include page="/includes/meta.jsp"/>
        <title>Matrícula - Intranet Escolar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    </head>
    <body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
    <jsp:include page="/includes/sidebar.jsp"/>
    <c:set var="tituloPaginaDesktop" value="Gestión de Matrículas" scope="request"/>
    <c:set var="tituloPaginaMobile" value="Matrícula" scope="request"/>
    <c:set var="iconoPagina" value="fas fa-user-graduate me-2" scope="request"/>
    <jsp:include page="/includes/header.jsp"/>

    <main class="main-content">
        <!-- Filtros -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <div class="d-flex align-items-center gap-2">
                            <label for="anioLectivo" class="mb-0 fw-semibold">Año Lectivo:</label>
                            <select id="anioLectivo" class="form-select form-select-sm" style="min-width: 120px;" onchange="filtrarPorAnio()">
                                <c:forEach var="anio" items="${anios}">
                                    <option value="${anio.idAnioLectivo}" ${anio.idAnioLectivo == anioActual ? 'selected' : ''}>
                                        ${anio.nombre}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-success btn-sm btn-uniform" onclick="exportarMatriculas()" title="Exportar a Excel">
                                <i class="fas fa-file-excel me-1"></i> Exportar
                            </button>
                            <a href="${pageContext.request.contextPath}/matricula?action=nuevo" class="btn btn-admin-primary btn-sm btn-uniform">
                                <i class="fas fa-plus me-1"></i> Nueva Matrícula
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="tablaMatriculas" class="table table-striped table-hover align-middle">
                        <thead class="table-dark text-center">
                            <tr>
                                <th>#</th>
                                <th>DNI</th>
                                <th>Alumno</th>
                                <th>Código</th>
                                <th>Nivel</th>
                                <th>Grado</th>
                                <th>Sección</th>
                                <th>Estado</th>
                                <th>Fecha</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${matriculas}" varStatus="s">
                                <tr class="text-center">
                                    <td>${s.index + 1}</td>
                                    <td>${m.dni}</td>
                                    <td class="text-start">${m.nombres} ${m.apellidos}</td>
                                    <td>${m.codigoMatricula}</td>
                                    <td>${m.nivel}</td>
                                    <td>${m.grado}</td>
                                    <td>${m.seccion}</td>
                                    <td>
                                        <span class="badge ${m.estado == 'regular' ? 'bg-success' :
                                              m.estado == 'condicional' ? 'bg-warning text-dark' :
                                              'bg-danger'} text-uppercase">
                                            ${m.estado}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${m.fecha}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button onclick="verDetalleMatricula(${m.idMatricula})" class="btn btn-sm btn-outline-primary" title="Ver detalle">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button onclick="editarMatricula(${m.idMatricula})" class="btn btn-sm btn-outline-warning" title="Editar matrícula">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/matricula?action=anular&id=${m.idMatricula}" class="btn btn-sm btn-outline-danger" title="Anular matrícula">
                                                <i class="fas fa-ban"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/matricula?action=constancia&id=${m.idMatricula}" class="btn btn-sm btn-outline-secondary" title="Imprimir constancia">
                                                <i class="fas fa-file-pdf"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Modal Detalle -->
    <div class="modal fade" id="modalDetalleMatricula" tabindex="-1" aria-labelledby="detalleMatriculaLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title"><i class="fas fa-info-circle me-2"></i>Detalle de Matrícula</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body" id="contenidoDetalleMatricula">
            <div class="text-center">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Cargando...</span>
              </div>
              <p class="mt-2">Cargando información...</p>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-outline-secondary btn-sm btn-uniform" data-bs-dismiss="modal">
              <i class="fas fa-times me-1"></i> Cerrar
            </button>
            <div id="botonAccionModal" class="ms-auto d-flex gap-2"></div>
          </div>
        </div>
      </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />

    <!-- JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/matricula.js"></script>
    <script>
        $(document).ready(() => {
            $('#tablaMatriculas').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                },
                pageLength: 25,
                lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
                lengthChange: true,
                responsive: true
            });
        });


    </script>
</body>
</html>
