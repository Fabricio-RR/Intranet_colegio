<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Comunicado" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Comunicados - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Gestión de Comunicados" scope="request" />
<c:set var="tituloPaginaMobile" value="Comunicados" scope="request" />
<c:set var="iconoPagina" value="fas fa-bullhorn" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
                <div class="d-flex align-items-center gap-2 ">
                    <!--<label for="anioLectivo" class="mb-0 fw-semibold" style="white-space: nowrap;">Año Lectivo:</label>
                    <select id="anioLectivo" class="form-select form-select-sm" style="min-width: 120px;">
                        <c:forEach var="anio" items="${anios}">
                            <option value="${anio.idAnioLectivo}" ${anio.idAnioLectivo == anioActual ? 'selected' : ''}>${anio.nombre}</option>
                        </c:forEach>
                    </select>-->
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/comunicado?action=crear" class="btn btn-admin-primary btn-sm btn-uniform" title="Nuevo Comunicado">
                        <i class="fas fa-plus me-1"></i><span class="d-none d-sm-inline">Nuevo</span> Comunicado
                    </a>
                </div>
                </div>
            </div>
        </div>
    </div>
        <br>        
        <div class="card">
            <div class="card-body table-responsive">
                <table id="tablaComunicados" class="table table-hover align-middle table-bordered nowrap">
                    <thead class="table-light">
                        <tr>
                            <th>Título</th>
                            <th>Tipo</th>
                            <th>Público</th>
                            <th>Inicio</th>
                            <th>Fin</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="c" items="${comunicados}">
                        <tr>
                            <td>${c.titulo}</td>
                            <td><span class="badge bg-info text-dark">${c.categoria}</span></td>
                            <td>${c.destinatario}</td>
                            <td><fmt:formatDate value="${c.fecInicio}" pattern="dd/MM/yyyy" /></td>
                            <td><fmt:formatDate value="${c.fecFin}" pattern="dd/MM/yyyy" /></td>
                            <td>
                                <span class="badge bg-${c.estado eq 'VIGENTE' ? 'success' : c.estado eq 'BORRADOR' ? 'secondary' : 'danger'}">${c.estado}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/comunicado?action=ver&id=${c.id}" class="btn btn-sm btn-outline-info" title="Ver">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <c:if test="${c.estado == 'BORRADOR'}">
                                    <a href="${pageContext.request.contextPath}/comunicado?action=editar&id=${c.id}" class="btn btn-sm btn-outline-primary" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger btn-eliminar" data-id="${c.id}" title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
    <jsp:include page="/includes/footer.jsp" />
</main>

<!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<script>
    $(document).ready(function () {
        $('#tablaComunicados').DataTable({
            responsive: true,
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            }
        });

        // Confirmación al eliminar
        $('.btn-eliminar').click(function () {
            const id = $(this).data('id');
            Swal.fire({
                title: '¿Eliminar comunicado?',
                text: "Esta acción no se puede deshacer.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/comunicado?action=eliminar&id=' + id;
                }
            });
        });
    });
</script>
</body>
</html>
