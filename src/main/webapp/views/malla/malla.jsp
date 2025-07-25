<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="malla curricular" scope="request"/>
    <jsp:include page="/includes/meta.jsp"/>
    <title>Malla Curricular - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
    <jsp:include page="/includes/sidebar.jsp" />
    <c:set var="tituloPaginaDesktop" value="Malla Curricular" scope="request" />
    <c:set var="tituloPaginaMobile" value="Malla" scope="request" />
    <c:set var="iconoPagina" value="fas fa-layer-group me-2" scope="request" />
    <jsp:include page="/includes/header.jsp" />
<main class="main-content">
    <!-- Card de filtros y acciones -->
     <div class="row mb-4">
        <div class="col-12">
            <div class="card">
            <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex align-items-center gap-2 ">
                <label for="anioLectivo" class="mb-0 fw-semibold" style="white-space: nowrap;">Año Lectivo:</label>
                <select id="anioLectivo" class="form-select form-select-sm" style="min-width: 120px;">
                    <c:forEach var="anio" items="${anios}">
                        <option value="${anio.idAnioLectivo}" ${anio.idAnioLectivo == anioActual ? 'selected' : ''}>${anio.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/malla-curricular?action=nuevo" class="btn btn-admin-primary btn-sm btn-uniform" title="Nueva malla curricular">
                    <i class="fas fa-plus me-1"></i><span class="d-none d-sm-inline">Crear</span> Malla
                </a>
            </div>
        </div>
        </div>
        </div>
    </div>
    <!-- Tarjetas por nivel -->
    <div class="row g-4">
      <c:forEach var="nivel" items="${nivelesActivos}">
        <div class="col-lg-4 col-md-6">
          <div class="card shadow-sm border-0 h-100">
            <div class="card-body">
              <h5 class="card-title fw-bold text-primary">${nivel.nombreNivel}</h5>
              <ul class="list-unstyled mb-3">
                <li>
                  <span class="badge bg-info-subtle text-primary me-2"><i class="fas fa-graduation-cap"></i></span>
                  <span class="fw-bold text-dark">${nivel.totalGrados}</span> Grados
                </li>
                <br>
                <li>
                  <span class="badge bg-success-subtle text-success me-2"><i class="fas fa-book"></i></span>
                  <span class="fw-bold text-dark">${nivel.totalCursos}</span> Cursos
                </li>
                <br>
                <li>
                  <span class="badge bg-warning-subtle text-warning me-2"><i class="fas fa-chalkboard-teacher"></i></span>
                  <span class="fw-bold text-dark">${nivel.totalDocentes}</span> Docentes
                </li>
                <br>
                <c:if test="${nivel.totalInactivos > 0}">
                  <li>
                    <span class="badge bg-danger-subtle text-danger me-2"><i class="fas fa-ban"></i></span>
                    <span class="fw-bold text-danger">${nivel.totalInactivos}</span> Inactivas
                  </li>
                </c:if>
              </ul>
              <div class="d-flex gap-2">
                <button type="button" class="btn btn-outline-primary btn-sm flex-fill" onclick="verDetalleMalla(${nivel.idNivel})">
                  <i class="fas fa-eye me-1"></i> Ver Detalle
                </button>
                <button type="button" class="btn btn-outline-warning btn-sm flex-fill" onclick="cargarModal('Editar Malla', 'Cargando formulario...', '${pageContext.request.contextPath}/malla-curricular?action=editar&idNivel=${nivel.idNivel}&anio=${anioActual}')">
                  <i class="fas fa-edit me-1"></i> Editar
                </button>
                <button type="button" class="btn btn-outline-danger btn-sm flex-fill" onclick="desactivarNivel(${nivel.idNivel})">
                  <i class="fas fa-trash me-1"></i> Desactivar
                </button><!--
                <c:if test="${nivel.totalInactivos > 0}">
                  <button type="button"
                          class="btn btn-outline-danger btn-sm flex-fill"
                          onclick="verDetalleMallaInactivas(${nivel.idNivel})">
                    <i class="fas fa-eye-slash me-1"></i> Ver Inactivas
                  </button>
                </c:if>-->
              </div>
                  <br>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
    <c:if test="${not empty nivelesInactivos}">
    <h5 class="mt-4 text-danger">
      <i class="fas fa-ban me-2"></i> Niveles totalmente inactivos
    </h5>
    <div class="row g-4">
      <c:forEach var="nivel" items="${nivelesInactivos}">
        <div class="col-lg-4 col-md-6">
          <div class="card shadow-sm border-0 h-100 border-danger">
            <div class="card-body">
              <h5 class="card-title fw-bold text-secondary">
                ${nivel.nombreNivel}
                <span class="badge bg-danger ms-2">INACTIVO</span>
              </h5>
              <ul class="list-unstyled mb-3">
                <li>
                  <span class="badge bg-info-subtle text-primary me-2"><i class="fas fa-graduation-cap"></i></span>
                  <span class="fw-bold text-dark">${nivel.totalGrados}</span> Grados
                </li>
                <br>
                <li>
                  <span class="badge bg-success-subtle text-success me-2"><i class="fas fa-book"></i></span>
                  <span class="fw-bold text-dark">${nivel.totalCursos}</span> Cursos
                </li>
                <br>
                <li>
                  <span class="badge bg-warning-subtle text-warning me-2"><i class="fas fa-chalkboard-teacher"></i></span>
                  <span class="fw-bold text-dark">${nivel.totalDocentes}</span> Docentes
                </li>
                <br>
                <li>
                  <span class="badge bg-danger-subtle text-danger me-2"><i class="fas fa-ban"></i></span>
                  <span class="fw-bold text-danger">${nivel.totalInactivos}</span> Inactivas
                </li>
              </ul>
              <!-- Botón para reactivar -->
              <button type="button" class="btn btn-outline-success btn-sm flex-fill" onclick="reactivarNivel(${nivel.idNivel})">
                <i class="fas fa-redo me-1"></i> Reactivar Nivel
              </button>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>

    <br>
    <!-- Modal Detalle Malla -->
    <div class="modal fade" id="modalDetalleMalla" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-list-alt me-2"></i>Detalle de Malla</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="contenidoDetalleMalla"></div>
            </div>
        </div>
    </div>
    <jsp:include page="/includes/footer.jsp" />
</main>

    <!-- JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/malla.js"></script>
    <c:if test="${param.success == '1' && param.op == 'add'}">
        <script>
            Swal.fire({
                icon: 'success',
                title: '¡Malla curricular creada!',
                text: 'La malla curricular se registró correctamente.',
                confirmButtonText: 'Aceptar'
            });
        </script>
    </c:if>

</body>
</html>
